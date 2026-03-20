import 'dart:convert';
import 'dart:io';

class ImportStats {
  int totalRows = 0;
  int skippedRows = 0;
  int authCreated = 0;
  int authExisting = 0;
  int profileCreated = 0;
  int profileExisting = 0;
  int failures = 0;
}

class ParticipantRow {
  final String email;
  final String name;
  final String password;
  final String role;

  const ParticipantRow({
    required this.email,
    required this.name,
    required this.password,
    required this.role,
  });
}

void main(List<String> args) async {
  final options = _parseArgs(args);
  if (options == null) return;

  final csvFile = File(options['file']!);
  if (!csvFile.existsSync()) {
    stderr.writeln('Datei nicht gefunden: ${csvFile.path}');
    exitCode = 2;
    return;
  }

  final endpoint = _requiredEnv('APPWRITE_ENDPOINT');
  final projectId = _requiredEnv('APPWRITE_PROJECT_ID');
  final apiKey = _requiredEnv('APPWRITE_API_KEY');
  if (endpoint == null || projectId == null || apiKey == null) {
    exitCode = 2;
    return;
  }

  final databaseId =
      Platform.environment['APPWRITE_DATABASE_ID'] ?? 'mbsr_database';
  final usersTableId = Platform.environment['APPWRITE_USERS_TABLE_ID'] ?? 'users';
  final defaultRole = Platform.environment['DEFAULT_ROLE'] ?? 'mbsr';
  final dryRun = options['dry-run'] == 'true';

  final rawContent = csvFile.readAsStringSync();
  final delimiter = _detectDelimiter(rawContent, options['delimiter']);
  final lines = const LineSplitter()
      .convert(rawContent)
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  if (lines.length < 2) {
    stderr.writeln('CSV enthält keine Datenzeilen.');
    exitCode = 2;
    return;
  }

  final header = _splitCsvLine(lines.first, delimiter)
      .map((e) => e.trim().toLowerCase())
      .toList();
  final participants = <ParticipantRow>[];
  final stats = ImportStats();

  for (var i = 1; i < lines.length; i++) {
    stats.totalRows++;
    final values = _splitCsvLine(lines[i], delimiter);
    final row = _mapRow(values, header, defaultRole);
    if (row == null) {
      stats.skippedRows++;
      stderr.writeln('Zeile ${i + 1} übersprungen (ungültig).');
      continue;
    }
    participants.add(row);
  }

  stdout.writeln('Import-Datei: ${csvFile.path}');
  stdout.writeln('Modus: ${dryRun ? "DRY-RUN" : "LIVE"}');
  stdout.writeln('Datensätze gültig: ${participants.length}');
  stdout.writeln('---');

  for (final p in participants) {
    final normalizedEmail = p.email.trim().toLowerCase();
    try {
      final authStatus = await _createAuthUser(
        endpoint: endpoint,
        projectId: projectId,
        apiKey: apiKey,
        participant: p,
        dryRun: dryRun,
      );
      if (authStatus == _CreateStatus.created) {
        stats.authCreated++;
      } else if (authStatus == _CreateStatus.existing) {
        stats.authExisting++;
      }

      final profileStatus = await _createProfileRow(
        endpoint: endpoint,
        projectId: projectId,
        apiKey: apiKey,
        databaseId: databaseId,
        tableId: usersTableId,
        participant: p,
        normalizedEmail: normalizedEmail,
        dryRun: dryRun,
      );
      if (profileStatus == _CreateStatus.created) {
        stats.profileCreated++;
      } else if (profileStatus == _CreateStatus.existing) {
        stats.profileExisting++;
      }
    } catch (e) {
      stats.failures++;
      stderr.writeln('Fehler bei ${p.email}: $e');
    }
  }

  stdout.writeln('\n=== Ergebnis ===');
  stdout.writeln('Gesamtzeilen: ${stats.totalRows}');
  stdout.writeln('Übersprungen (ungültig): ${stats.skippedRows}');
  stdout.writeln('Auth neu: ${stats.authCreated}');
  stdout.writeln('Auth bereits vorhanden: ${stats.authExisting}');
  stdout.writeln('Profil neu: ${stats.profileCreated}');
  stdout.writeln('Profil bereits vorhanden: ${stats.profileExisting}');
  stdout.writeln('Fehler: ${stats.failures}');
}

Map<String, String>? _parseArgs(List<String> args) {
  final options = <String, String>{
    'file': 'import/teilnehmende.csv',
    'dry-run': 'false',
  };

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--help' || arg == '-h') {
      stdout.writeln('''
Teilnehmenden-Import (Auth + users-Tabelle)

Optionen:
  --file <pfad>        CSV-Datei (Default: import/teilnehmende.csv)
  --delimiter <,|;>    Optionales Trennzeichen
  --dry-run            Nur prüfen, nichts schreiben
  --help               Hilfe anzeigen

Erforderliche Umgebungsvariablen:
  APPWRITE_ENDPOINT
  APPWRITE_PROJECT_ID
  APPWRITE_API_KEY

Optionale Umgebungsvariablen:
  APPWRITE_DATABASE_ID   (Default: mbsr_database)
  APPWRITE_USERS_TABLE_ID(Default: users)
  DEFAULT_ROLE           (Default: mbsr)
''');
      return null;
    }
    if (arg == '--dry-run') {
      options['dry-run'] = 'true';
      continue;
    }
    if (arg.startsWith('--file=')) {
      options['file'] = arg.split('=').last;
      continue;
    }
    if (arg == '--file' && i + 1 < args.length) {
      options['file'] = args[++i];
      continue;
    }
    if (arg.startsWith('--delimiter=')) {
      options['delimiter'] = arg.split('=').last;
      continue;
    }
    if (arg == '--delimiter' && i + 1 < args.length) {
      options['delimiter'] = args[++i];
    }
  }
  return options;
}

String? _requiredEnv(String key) {
  final value = Platform.environment[key];
  if (value == null || value.trim().isEmpty) {
    stderr.writeln('Fehlende Umgebungsvariable: $key');
    return null;
  }
  return value;
}

String _detectDelimiter(String content, String? explicitDelimiter) {
  if (explicitDelimiter == ',' || explicitDelimiter == ';') {
    return explicitDelimiter!;
  }
  final firstLine = const LineSplitter().convert(content).first;
  final commaCount = ','.allMatches(firstLine).length;
  final semicolonCount = ';'.allMatches(firstLine).length;
  return semicolonCount > commaCount ? ';' : ',';
}

List<String> _splitCsvLine(String line, String delimiter) {
  final result = <String>[];
  var current = '';
  var inQuotes = false;

  for (var i = 0; i < line.length; i++) {
    final ch = line[i];
    if (ch == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        current += '"';
        i++;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }
    if (!inQuotes && ch == delimiter) {
      result.add(current.trim());
      current = '';
      continue;
    }
    current += ch;
  }
  result.add(current.trim());
  return result;
}

ParticipantRow? _mapRow(
  List<String> values,
  List<String> header,
  String defaultRole,
) {
  String? read(String key) {
    final idx = header.indexOf(key);
    if (idx == -1 || idx >= values.length) return null;
    return values[idx].trim();
  }

  final email = read('email');
  final password = read('password');
  final name = read('name') ?? '';
  final role = (read('role') ?? defaultRole).trim().toLowerCase();

  if (email == null || email.isEmpty) return null;
  if (password == null || password.isEmpty) return null;

  return ParticipantRow(
    email: email.trim().toLowerCase(),
    name: name.isEmpty ? _fallbackNameFromEmail(email) : name,
    password: password,
    role: role.isEmpty ? defaultRole : role,
  );
}

String _fallbackNameFromEmail(String email) {
  final prefix = email.split('@').first;
  if (prefix.isEmpty) return 'Teilnehmer';
  return prefix[0].toUpperCase() + prefix.substring(1);
}

enum _CreateStatus { created, existing }

Future<_CreateStatus> _createAuthUser({
  required String endpoint,
  required String projectId,
  required String apiKey,
  required ParticipantRow participant,
  required bool dryRun,
}) async {
  if (dryRun) {
    stdout.writeln('[DRY] Auth anlegen: ${participant.email}');
    return _CreateStatus.created;
  }
  final response = await _appwriteRequest(
    method: 'POST',
    endpoint: endpoint,
    path: '/users',
    projectId: projectId,
    apiKey: apiKey,
    body: {
      'userId': 'unique()',
      'email': participant.email,
      'password': participant.password,
      'name': participant.name,
    },
  );

  if (_isAlreadyExists(response)) {
    return _CreateStatus.existing;
  }
  if (response.statusCode >= 200 && response.statusCode < 300) {
    stdout.writeln('Auth angelegt: ${participant.email}');
    return _CreateStatus.created;
  }
  throw Exception(
    'Auth fehlgeschlagen für ${participant.email}: ${response.statusCode} ${response.body}',
  );
}

Future<_CreateStatus> _createProfileRow({
  required String endpoint,
  required String projectId,
  required String apiKey,
  required String databaseId,
  required String tableId,
  required ParticipantRow participant,
  required String normalizedEmail,
  required bool dryRun,
}) async {
  final rowId = _rowIdForEmail(normalizedEmail);
  if (dryRun) {
    stdout.writeln('[DRY] Profil anlegen: ${participant.email} (${participant.role})');
    return _CreateStatus.created;
  }

  final response = await _appwriteRequest(
    method: 'POST',
    endpoint: endpoint,
    path: '/databases/$databaseId/tables/$tableId/rows',
    projectId: projectId,
    apiKey: apiKey,
    body: {
      'rowId': rowId,
      'data': {
        'email': normalizedEmail,
        'role': participant.role,
        'name': participant.name,
      },
    },
  );

  if (_isAlreadyExists(response)) {
    return _CreateStatus.existing;
  }
  if (response.statusCode >= 200 && response.statusCode < 300) {
    stdout.writeln('Profil angelegt: ${participant.email} (${participant.role})');
    return _CreateStatus.created;
  }
  throw Exception(
    'Profil fehlgeschlagen für ${participant.email}: ${response.statusCode} ${response.body}',
  );
}

bool _isAlreadyExists(_HttpResponse response) {
  if (response.statusCode != 409) return false;
  final lower = response.body.toLowerCase();
  return lower.contains('already') ||
      lower.contains('exists') ||
      lower.contains('duplicate');
}

String _rowIdForEmail(String email) {
  final cleaned = email.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  if (cleaned.isEmpty) return 'u_default';
  return cleaned.length > 36 ? cleaned.substring(0, 36) : cleaned;
}

Future<_HttpResponse> _appwriteRequest({
  required String method,
  required String endpoint,
  required String path,
  required String projectId,
  required String apiKey,
  Map<String, dynamic>? body,
}) async {
  final uri = Uri.parse('${endpoint.replaceFirst(RegExp(r'/$'), '')}$path');
  final client = HttpClient();
  try {
    final request = await client.openUrl(method, uri);
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.set('X-Appwrite-Project', projectId);
    request.headers.set('X-Appwrite-Key', apiKey);
    if (body != null) {
      request.write(jsonEncode(body));
    }
    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);
    return _HttpResponse(
      statusCode: response.statusCode,
      body: responseBody,
    );
  } finally {
    client.close();
  }
}

class _HttpResponse {
  final int statusCode;
  final String body;

  const _HttpResponse({required this.statusCode, required this.body});
}


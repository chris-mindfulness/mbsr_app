import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final options = _parseArgs(args);
  if (options == null) return;

  final endpoint = _requiredEnv('APPWRITE_ENDPOINT');
  final projectId = _requiredEnv('APPWRITE_PROJECT_ID');
  final apiKey = _requiredEnv('APPWRITE_API_KEY');
  if (endpoint == null || projectId == null || apiKey == null) {
    exitCode = 2;
    return;
  }

  final databaseId =
      Platform.environment['APPWRITE_DATABASE_ID'] ?? 'mbsr_database';
  final audioTable =
      Platform.environment['APPWRITE_AUDIO_DAILY_TABLE_ID'] ??
      'audio_daily_aggregate';
  final slotTable =
      Platform.environment['APPWRITE_SLOT_DAILY_TABLE_ID'] ??
      'slot_daily_aggregate';
  final weeklyTable =
      Platform.environment['APPWRITE_WEEKLY_DISTRIBUTION_TABLE_ID'] ??
      'weekly_distribution_aggregate';
  final outDir = Directory(options['out-dir']!);
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  final fromDate = options['from'];
  final toDate = options['to'];
  final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');

  stdout.writeln('Exportiere Tracking-Aggregate...');
  stdout.writeln('Datenbank: $databaseId');
  stdout.writeln('Zeitraum: ${fromDate ?? "offen"} bis ${toDate ?? "offen"}');

  final audioRows = await _listAllRows(
    endpoint: endpoint,
    projectId: projectId,
    apiKey: apiKey,
    databaseId: databaseId,
    tableId: audioTable,
  );
  final slotRows = await _listAllRows(
    endpoint: endpoint,
    projectId: projectId,
    apiKey: apiKey,
    databaseId: databaseId,
    tableId: slotTable,
  );
  final weeklyRows = await _listAllRows(
    endpoint: endpoint,
    projectId: projectId,
    apiKey: apiKey,
    databaseId: databaseId,
    tableId: weeklyTable,
  );

  final filteredAudio = audioRows
      .where(
        (row) => _isDateInRange(row['date_key']?.toString(), fromDate, toDate),
      )
      .toList();
  final filteredSlot = slotRows
      .where(
        (row) => _isDateInRange(row['date_key']?.toString(), fromDate, toDate),
      )
      .toList();
  final filteredWeekly = weeklyRows
      .where(
        (row) => _isWeekInRange(row['week_key']?.toString(), fromDate, toDate),
      )
      .toList();

  final audioPath = '${outDir.path}/audio_daily_aggregate_$timestamp.csv';
  final slotPath = '${outDir.path}/slot_daily_aggregate_$timestamp.csv';
  final weeklyPath =
      '${outDir.path}/weekly_distribution_aggregate_$timestamp.csv';

  _writeCsv(
    path: audioPath,
    header: const [
      'date_key',
      'audio_id',
      'audio_title',
      'plays_80_count',
      'heard_seconds_sum',
      'updated_at',
    ],
    rows: filteredAudio.map((row) {
      return [
        row['date_key']?.toString() ?? '',
        row['audio_id']?.toString() ?? '',
        row['audio_title']?.toString() ?? '',
        row['plays_80_count']?.toString() ?? '0',
        row['heard_seconds_sum']?.toString() ?? '0',
        row['updated_at']?.toString() ?? '',
      ];
    }).toList(),
  );

  _writeCsv(
    path: slotPath,
    header: const [
      'date_key',
      'slot_key',
      'plays_80_count',
      'heard_seconds_sum',
      'updated_at',
    ],
    rows: filteredSlot.map((row) {
      return [
        row['date_key']?.toString() ?? '',
        row['slot_key']?.toString() ?? '',
        row['plays_80_count']?.toString() ?? '0',
        row['heard_seconds_sum']?.toString() ?? '0',
        row['updated_at']?.toString() ?? '',
      ];
    }).toList(),
  );

  _writeCsv(
    path: weeklyPath,
    header: const ['week_key', 'bucket_key', 'participant_count', 'updated_at'],
    rows: filteredWeekly.map((row) {
      return [
        row['week_key']?.toString() ?? '',
        row['bucket_key']?.toString() ?? '',
        row['participant_count']?.toString() ?? '0',
        row['updated_at']?.toString() ?? '',
      ];
    }).toList(),
  );

  stdout.writeln('Fertig:');
  stdout.writeln('- $audioPath (${filteredAudio.length} Zeilen)');
  stdout.writeln('- $slotPath (${filteredSlot.length} Zeilen)');
  stdout.writeln('- $weeklyPath (${filteredWeekly.length} Zeilen)');
}

Map<String, String>? _parseArgs(List<String> args) {
  final options = <String, String>{'out-dir': 'export'};
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--help' || arg == '-h') {
      stdout.writeln('''
CSV-Export fuer Tracking-Aggregate

Optionen:
  --from <YYYY-MM-DD>   Optionales Startdatum (inklusive)
  --to <YYYY-MM-DD>     Optionales Enddatum (inklusive)
  --out-dir <pfad>      Zielordner (Default: export)
  --help                Hilfe anzeigen

Erforderliche Umgebungsvariablen:
  APPWRITE_ENDPOINT
  APPWRITE_PROJECT_ID
  APPWRITE_API_KEY

Optionale Umgebungsvariablen:
  APPWRITE_DATABASE_ID
  APPWRITE_AUDIO_DAILY_TABLE_ID
  APPWRITE_SLOT_DAILY_TABLE_ID
  APPWRITE_WEEKLY_DISTRIBUTION_TABLE_ID
''');
      return null;
    }
    if (arg.startsWith('--from=')) {
      options['from'] = arg.split('=').last;
      continue;
    }
    if (arg == '--from' && i + 1 < args.length) {
      options['from'] = args[++i];
      continue;
    }
    if (arg.startsWith('--to=')) {
      options['to'] = arg.split('=').last;
      continue;
    }
    if (arg == '--to' && i + 1 < args.length) {
      options['to'] = args[++i];
      continue;
    }
    if (arg.startsWith('--out-dir=')) {
      options['out-dir'] = arg.split('=').last;
      continue;
    }
    if (arg == '--out-dir' && i + 1 < args.length) {
      options['out-dir'] = args[++i];
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

Future<List<Map<String, dynamic>>> _listAllRows({
  required String endpoint,
  required String projectId,
  required String apiKey,
  required String databaseId,
  required String tableId,
}) async {
  final rows = <Map<String, dynamic>>[];
  const pageSize = 100;
  var offset = 0;
  while (true) {
    final response = await _appwriteRequest(
      method: 'GET',
      endpoint: endpoint,
      path: '/databases/$databaseId/tables/$tableId/rows',
      projectId: projectId,
      apiKey: apiKey,
      queryParametersAll: {
        'queries[]': [_queryLimit(pageSize), _queryOffset(offset)],
      },
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Fehler beim Lesen von $tableId: ${response.statusCode} ${response.body}',
      );
    }
    final parsed = jsonDecode(response.body);
    if (parsed is! Map<String, dynamic>) break;
    final pageRows = parsed['rows'];
    if (pageRows is! List || pageRows.isEmpty) break;
    for (final row in pageRows) {
      if (row is Map<String, dynamic>) {
        rows.add(row);
      }
    }
    if (pageRows.length < pageSize) break;
    offset += pageSize;
  }
  return rows;
}

String _queryLimit(int n) => jsonEncode({
  'method': 'limit',
  'values': [n],
});

String _queryOffset(int n) => jsonEncode({
  'method': 'offset',
  'values': [n],
});

bool _isDateInRange(String? dateKey, String? from, String? to) {
  if (dateKey == null || dateKey.isEmpty) return false;
  if (from != null && dateKey.compareTo(from) < 0) return false;
  if (to != null && dateKey.compareTo(to) > 0) return false;
  return true;
}

bool _isWeekInRange(String? weekKey, String? from, String? to) {
  if (weekKey == null || weekKey.isEmpty) return false;
  if (from == null && to == null) return true;

  final weekStart = _weekToDateKey(weekKey);
  if (weekStart == null) return true;
  if (from != null && weekStart.compareTo(from) < 0) return false;
  if (to != null && weekStart.compareTo(to) > 0) return false;
  return true;
}

String? _weekToDateKey(String weekKey) {
  final match = RegExp(r'^(\d{4})-W(\d{2})$').firstMatch(weekKey);
  if (match == null) return null;
  final year = int.tryParse(match.group(1)!);
  final week = int.tryParse(match.group(2)!);
  if (year == null || week == null) return null;

  final jan4 = DateTime.utc(year, 1, 4);
  final jan4Weekday = jan4.weekday; // 1=Mon ... 7=Sun
  final week1Monday = jan4.subtract(Duration(days: jan4Weekday - 1));
  final target = week1Monday.add(Duration(days: (week - 1) * 7));
  return '${target.year.toString().padLeft(4, '0')}-'
      '${target.month.toString().padLeft(2, '0')}-'
      '${target.day.toString().padLeft(2, '0')}';
}

void _writeCsv({
  required String path,
  required List<String> header,
  required List<List<String>> rows,
}) {
  final file = File(path);
  final buffer = StringBuffer();
  buffer.writeln(header.map(_csvCell).join(','));
  for (final row in rows) {
    buffer.writeln(row.map(_csvCell).join(','));
  }
  file.writeAsStringSync(buffer.toString(), flush: true);
}

String _csvCell(String value) {
  final escaped = value.replaceAll('"', '""');
  return '"$escaped"';
}

Future<_HttpResponse> _appwriteRequest({
  required String method,
  required String endpoint,
  required String path,
  required String projectId,
  required String apiKey,
  Map<String, dynamic>? body,
  Map<String, List<String>>? queryParametersAll,
}) async {
  var uri = Uri.parse('${endpoint.replaceFirst(RegExp(r'/$'), '')}$path');
  if (queryParametersAll != null && queryParametersAll.isNotEmpty) {
    final sb = StringBuffer(uri.toString());
    sb.write(uri.hasQuery ? '&' : '?');
    var first = true;
    for (final entry in queryParametersAll.entries) {
      for (final v in entry.value) {
        if (!first) sb.write('&');
        first = false;
        sb.write(
          '${Uri.encodeQueryComponent(entry.key)}='
          '${Uri.encodeQueryComponent(v)}',
        );
      }
    }
    uri = Uri.parse(sb.toString());
  }
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
    return _HttpResponse(statusCode: response.statusCode, body: responseBody);
  } finally {
    client.close();
  }
}

class _HttpResponse {
  final int statusCode;
  final String body;

  const _HttpResponse({required this.statusCode, required this.body});
}

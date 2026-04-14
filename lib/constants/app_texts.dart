/// Zentrale Textverwaltung für die App
/// 
/// Alle User-facing Texte an einem Ort für einfache Anpassungen
/// und Mehrsprachigkeit in der Zukunft
class AppTexts {
  // Tracking-Erklärung
  static const String trackingInfoTitle = 'Über deine Statistiken';
  
  static const String trackingInfoText = 
      'Wir speichern deinen Fortschritt automatisch, sobald du etwa 80% '
      'einer Übung abgeschlossen hast. Dies hilft dir, den Überblick über '
      'deinen MBSR-Kurs zu behalten.\n\n'
      'Ein kurzes Anspielen oder reines Vorspulen wird nicht gewertet, '
      'damit deine Statistik aussagekräftig bleibt.\n\n'
      'Aktueller Stand: Die Statistik ist lokal im Browser gespeichert. '
      'Wenn du den Browser wechselst oder den Browser-Cache leerst, kann '
      'dein bisheriges Tracking verloren gehen.\n\n'
      'Wichtig: Es geht nicht um Leistungskontrolle, sondern um die '
      'Unterstützung deiner Praxis. Auch kleine Schritte sind wertvoll.\n\n'
      '🔒 Datenschutz: Deine Statistiken werden ausschließlich lokal auf '
      'deinem Gerät gespeichert und sind nicht für die Seminarleitung oder '
      'andere Personen zugänglich.';

  /// Mediathek: Hinweis neben dem Download pro Übung (einmal unter der Suche).
  static const String mediathekDownloadHint =
      'Tipp: Bei Problemen mit dem Internet kannst du eine Übung über das '
      'Download-Symbol herunterladen und später anhören. Zum Üben in der App '
      'startest du wie gewohnt mit Play.';

  /// Mediathek: kurze Hinweise zum Streamen (kein Ersatz für Offline-Download).
  static const String playbackTipsTitle = 'Tipps für stabiles Abspielen';

  static const String playbackTipsText =
      'Die Übungen werden über das Internet geladen. Für ruhiges Anhören '
      'ohne Unterbrechungen kannst du Folgendes beachten:\n\n'
      '• Nutze wenn möglich eine stabile Verbindung (WLAN statt schwachem '
      'Mobilfunk).\n'
      '• Lass die App oder den Browser-Tab während der Übung im '
      'Vordergrund — manche Geräte drosseln sonst Ton oder Datenübertragung.\n'
      '• Bei längeren Anleitungen kann der Start kurz dauern, bis alles '
      'nachgeladen ist — etwas Geduld ist normal.\n'
      '• Wenn es hakt: kurz warten, die Seite neu laden oder ein anderes '
      'Netz probieren.\n\n'
      'Es geht nicht darum, etwas „richtig“ einzustellen — kleine '
      'Anpassungen reichen oft.';

  // Motivations-Texte
  static const String motivationRegular = 
      'Regelmäßige Praxis ist der Schlüssel';
  
  static const String motivationDescription = 
      'Auch kleine Schritte führen zum Ziel. Deine tägliche Praxis ist '
      'wertvoll, unabhängig von der Dauer.';

  // Streak-Texte
  static const String streakContinue = 'Weiter so!';
  static const String streakStart = 'Starte deine Serie!';
  
  // Offline-Texte
  static const String offlineGeneral = 'Keine Internetverbindung';
  static const String offlineAudio =
      'Offline – Audios können nicht geladen werden';
  
  // Error-Texte
  static const String errorConnection = 'Verbindungsfehler';
  static const String errorConnectionDescription = 
      'Bitte prüfe deine Internetverbindung.';
  static const String errorRetry = 'Erneut versuchen';
}

/// Zentrale Datenquelle für die gesamte App
/// Diese Datei enthält alle Kursdaten, die sowohl im MBSR-Bereich
/// als auch im Gastbereich verwendet werden
class AppDaten {
  /// Zentrale Mediathek-Daten (Quelle für alle Audios)
  static const List<Map<String, String>> mediathekAudios = [
    {
      'title': 'Ankommen',
      'duration': '3 Min',
      'appwrite_id': '696bfa4c0028c1c9b7b3',
      'description':
          'Eine kurze Übung zum Ankommen im Moment. Ideal zum Einstieg in den Tag oder als Pause zwischendurch.',
    },
    {
      'title': 'Body-Scan (kurz)',
      'duration': '20 Min',
      'appwrite_id': '696bff8a003533170ca4',
      'description':
          'In der kurzen Version des Body-Scans wanderst du zügig durch den Körper. Ideal, um zwischendurch die Verbindung zu dir selbst zu stärken.',
    },
    {
      'title': 'Body-Scan (mittel)',
      'duration': '27 Min',
      'appwrite_id': '696bff9400283154816e',
      'description':
          'Die mittlere Version bietet mehr Raum für das Spüren einzelner Bereiche und das Atmen in den Körper.',
    },
    {
      'title': 'Body-Scan (lang)',
      'duration': '35 Min',
      'appwrite_id': '696bff9b000d16345521',
      'description':
          'Die klassische, ausführliche Übung. Du nimmst dir Zeit für jeden Winkel deines Körpers und entwickelst tiefe Präsenz.',
    },
    {
      'title': 'Sitzmeditation (kurz)',
      'duration': '10 Min',
      'appwrite_id': '696bffa2000a833c13ce',
      'description':
          'In der Sitzmeditation stabilisierst du deine Aufmerksamkeit auf einem primären Objekt (meist der Atembewegung). Wenn der Fokus abschweift – was ein natürlicher Prozess des Gehirns ist – wird dies wertfrei registriert und die Aufmerksamkeit aktiv zum Anker zurückgeführt.',
    },
    {
      'title': 'Sitzmeditation (mittel)',
      'duration': '15 Min',
      'appwrite_id': '696bffaa00090187914b',
      'description':
          'In der Sitzmeditation stabilisierst du deine Aufmerksamkeit auf einem primären Objekt (meist der Atembewegung). Wenn der Fokus abschweift – was ein natürlicher Prozess des Gehirns ist – wird dies wertfrei registriert und die Aufmerksamkeit aktiv zum Anker zurückgeführt.',
    },
    {
      'title': 'Sitzmeditation (lang)',
      'duration': '20 Min',
      'appwrite_id': '696bffb000325d0acc84',
      'description':
          'In der Sitzmeditation stabilisierst du deine Aufmerksamkeit auf einem primären Objekt (meist der Atembewegung). Wenn der Fokus abschweift – was ein natürlicher Prozess des Gehirns ist – wird dies wertfrei registriert und die Aufmerksamkeit aktiv zum Anker zurückgeführt.',
    },
    {
      'title': 'Achtsamkeit in Bewegung',
      'duration': '20 Min',
      'appwrite_id': '696bffb90034f23257c2',
      'description':
          'Diese Übung kombiniert langsame Bewegungen mit kontinuierlicher Aufmerksamkeit. Du trainierst, die Signale deines Bewegungsapparates (Dehnung, Kraft, Gleichgewicht) in Aktion zu beobachten. Dabei lernst du, auch während körperlicher Anstrengung die begleitenden Gedanken und Bewertungen wahrzunehmen.',
    },
    {
      'title': 'Mitgefühl',
      'duration': '12 Min',
      'appwrite_id': '696bffcc000a9fa2ce09',
      'description':
          'Die Metta-Meditation stärkt die liebevolle Güte dir selbst und anderen gegenüber. Besonders wertvoll für das Wohlbefinden.',
    },
    {
      'title': 'Tour der Sinne',
      'duration': '10 Min',
      'appwrite_id': '696bffd600298b5e9c51',
      'description':
          'Erforsche die Welt durch deine Sinne – Hören, Spüren, Riechen. Eine Einladung, die Welt ganz neu wahrzunehmen.',
    },
  ];

  // Alle Wochen-Daten (Audios entfernt, nur PDFs und Aufgaben)
  static const List<Map<String, dynamic>> wochenDaten = [
    {
      'n': '1',
      't': 'Was ist Achtsamkeit (nicht)?',
      'teaser': 'Zum Auftakt geht es darum, im Kurs anzukommen und erste Erfahrungen mit Achtsamkeit zu sammeln. Wir erkunden, was es bedeutet, den Autopiloten zu bemerken und dem eigenen Erleben im Moment Aufmerksamkeit zu schenken. Der Körper dient dabei als erster Anker.',
      'fokus': 'Vom Tun ins Sein kommen.',
      'zitat': 'Du kannst die Wellen nicht stoppen, aber du kannst lernen zu surfen.',
      'zitatAutor': 'Jon Kabat-Zinn',
      'alltagsTipp': 'Nimm heute 3 bewusste Atemzüge, bevor du morgens aufstehst.',
      'reflexionsFragen': [
        'Wann warst du heute im Autopiloten unterwegs?',
        'In welchen Momenten warst du ganz präsent?',
      ],
      'audioRefs': ['Ankommen', 'Body-Scan (kurz)'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 1',
          'appwrite_id': '696bfa6b0039f0497205',
        },
      ],
      'wochenAufgaben': [
        '1.	Body-Scan mehrmals pro Woche mit Audiodatei üben.',
        '2.	Eine Mahlzeit in dieser Woche achtsam einnehmen.',
        '3.	Die Neun-Punkte-Übung bearbeiten.',
        '4.	Die Geschichte vom Oberfluss und Unterfluss lesen.',
      ],
    },
    {
      'n': '2',
      't': 'Wie wir die Welt wahrnehmen',
      'teaser': 'In diesem Termin vertiefen wir die Aufmerksamkeit für den Körper und erforschen, wie Wahrnehmung durch Bewertungen und Gewohnheiten geprägt ist. Durch praktische Übungen wird erfahrbar, wie schnell wir interpretieren – und was sich verändert, wenn wir offener wahrnehmen.',
      'fokus': 'Wahrnehmung vs. Interpretation',
      'zitat': 'Wir sehen die Dinge nicht, wie sie sind, wir sehen sie, wie wir sind.',
      'zitatAutor': 'Anaïs Nin',
      'alltagsTipp': 'Achte heute beim Essen darauf, wie der erste Bissen wirklich schmeckt, bevor du ihn bewertest.',
      'reflexionsFragen': [
        'Wann hast du heute etwas bewertet, statt es nur wahrzunehmen?',
        'Wie fühlt sich dein Körper an, wenn du gestresst bist?',
      ],
      'audioRefs': ['Ankommen', 'Body-Scan (kurz)'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 2',
          'appwrite_id': '696bfc7f003e17db0a1e',
        },
      ],
      'wochenAufgaben': [
        '1.	Body-Scan mit Audiodatei mehrmals pro Woche üben.',
        '2.	Eine alltägliche Tätigkeit mit Anfängergeist ausführen (z. B. Zähneputzen, Duschen, Geschirrspülen).',
        '3.	Möglichst täglich für einige Minuten die Aufmerksamkeit auf den Atem richten.',
        '4.	Den Kalender der angenehmen Erlebnisse nutzen.',
      ],
    },
    {
      'n': '3',
      't': 'Im Körper beheimatet sein',
      'teaser': 'Achtsame Bewegung eröffnet einen weiteren Zugang zum eigenen Erleben und zu persönlichen Grenzen. Gleichzeitig richten wir den Blick auf angenehme Erfahrungen im Alltag und darauf, wie sie bewusster wahrgenommen und verankert werden können.',
      'fokus': 'Grenzen spüren und respektieren',
      'zitat': 'Aufmerksamkeit ist der Weg zum Leben.',
      'zitatAutor': 'Buddha',
      'alltagsTipp': 'Spüre beim Gehen ganz bewusst den Kontakt deiner Füße zum Boden.',
      'reflexionsFragen': [
        'Wie gehst du mit deinen körperlichen Grenzen um?',
        'Welche angenehmen Momente hast du heute erlebt?',
      ],
      'audioRefs': ['Ankommen', 'Achtsamkeit in Bewegung', 'Body-Scan (kurz)'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 3',
          'appwrite_id': '696bfc8c001ab2d0d7fb',
        },
      ],
      'wochenAufgaben': [
        '1.	Mehrmals pro Woche Body-Scan oder achtsame Körperarbeit üben.',
        '2.	Möglichst täglich den Atem im Alltag beobachten.',
        '3.	Den Kalender der unangenehmen Erlebnisse ausfüllen.',
      ],
    },
    {
      'n': '4',
      't': 'Dem Stress auf der Spur',
      'teaser': 'Dieser Termin widmet sich unangenehmen Erfahrungen und der Frage, wie Stress entsteht. Wir untersuchen persönliche Stressmuster und nähern uns dem Zusammenhang von Wahrnehmung, Reaktion und Belastung.',
      'fokus': 'Stressreaktion verstehen',
      'zitat': 'Nicht die Dinge selbst beunruhigen die Menschen, sondern ihre Meinungen über die Dinge.',
      'zitatAutor': 'Epiktet',
      'alltagsTipp': 'Wenn du Stress spürst: Halte kurz inne und atme 3 Mal tief durch.',
      'reflexionsFragen': [
        'Was sind deine typischen Stressauslöser?',
        'Wie reagierst du körperlich auf Stress?',
      ],
      'audioRefs': ['Ankommen', 'Sitzmeditation (kurz)', 'Body-Scan (kurz)', 'Achtsamkeit in Bewegung'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 4',
          'appwrite_id': '696bfd3d00077e7e2c0b',
        },
      ],
      'wochenAufgaben': [
        '1.	Regelmäßige formelle Praxis (Body-Scan, Körperarbeit oder Sitzmeditation).',
        '2.	Atembeobachtung im Alltag.',
        '3.	Abschnitt „Achtsamkeit am Arbeitsplatz“ lesen.',
        '4.	Stressreaktionen notieren.',
      ],
    },
    {
      'n': '5',
      't': 'Achtsamkeit und ihre Wirkungsweise',
      'teaser': 'Gedanken stehen heute im Mittelpunkt: Wie tragen sie zur Entstehung von Stress bei? Durch Achtsamkeit wird erfahrbar, dass zwischen Reiz und Reaktion ein Spielraum liegt, der neue Handlungsmöglichkeiten eröffnet.',
      'fokus': 'Zwischen Reiz und Reaktion liegt ein Raum',
      'zitat': 'Du bist nicht deine Gedanken.',
      'zitatAutor': 'Jon Kabat-Zinn',
      'alltagsTipp': 'Beobachte deine Gedanken wie Wolken am Himmel – lass sie ziehen.',
      'reflexionsFragen': [
        'Welche Gedankenmuster tauchen bei dir häufig auf?',
        'Kannst du einen Schritt zurücktreten und deine Gedanken beobachten?',
      ],
      'audioRefs': ['Ankommen', 'Sitzmeditation (mittel)', 'Body-Scan (kurz)', 'Achtsamkeit in Bewegung'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 5',
          'appwrite_id': '696bfd450038aba59bcf',
        },
      ],
      'wochenAufgaben': [
        '1.	Sitzmeditation üben, im Wechsel mit Body-Scan oder Körperarbeit.',
        '2.	Achtsamkeit in stressigen Situationen anwenden.',
        '3.	Kalender der „Schwierigen Kommunikation“ ausfüllen.',
      ],
    },
    {
      'n': '6',
      't': 'Schwierige Kommunikation',
      'teaser': 'Achtsamkeit wird nun auf zwischenmenschliche Situationen übertragen. Wir erforschen, wie wir in schwierigen Gesprächen reagieren, zuhören und sprechen – und welche Rolle innere Haltung und Präsenz dabei spielen.',
      'fokus': 'Präsenz im Kontakt',
      'zitat': 'Das kostbarste Geschenk, das wir einem anderen machen können, ist unsere Aufmerksamkeit.',
      'zitatAutor': 'Thich Nhat Hanh',
      'alltagsTipp': 'Höre heute in einem Gespräch nur zu, ohne sofort eine Antwort parat zu haben.',
      'reflexionsFragen': [
        'Wie verhältst du dich in schwierigen Gesprächen?',
        'Kannst du zuhören, ohne zu unterbrechen?',
      ],
      'audioRefs': ['Ankommen', 'Sitzmeditation (mittel)', 'Body-Scan (kurz)', 'Achtsamkeit in Bewegung'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 6',
          'appwrite_id': '696bfd4f0037e7e16a9f',
        },
      ],
      'wochenAufgaben': [
        '1. Sitzmeditation üben, im Wechsel mit Body-Scan oder Körperarbeit.',
        '2.	Reaktionen in zwischenmenschlichen Situationen beobachten.',
        '3.	Sinneseindrücke bewusst wahrnehmen.',
      ],
    },
    {
      'n': '7',
      't': 'Selbstfürsorge',
      'teaser': 'Dieser Termin lädt dazu ein, Selbstfürsorge als bewusste Haltung im Alltag zu betrachten. Wir erkunden, was uns nährt und was uns erschöpft, und wie Achtsamkeit helfen kann, stimmigere Entscheidungen zu treffen.',
      'fokus': 'Was nährt mich, was zehrt an mir?',
      'zitat': 'Sei gut zu dir selbst, damit du gut zu anderen sein kannst.',
      'zitatAutor': 'Unbekannt',
      'alltagsTipp': 'Tue heute bewusst etwas, das dir gut tut – nur für dich.',
      'reflexionsFragen': [
        'Was gibt dir Energie im Alltag?',
        'Wo verlierst du unnötig Kraft?',
      ],
      'audioRefs': ['Ankommen', 'Sitzmeditation (lang)', 'Body-Scan (kurz)', 'Achtsamkeit in Bewegung'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 7',
          'appwrite_id': '696bfd57000f4bb29d10',
        },
      ],
      'wochenAufgaben': [
        '1.	Übungen ohne Anleitung praktizieren.',
        '2.	Reflexion über das Kursende und die Fortführung der Praxis.',
        '3.	Unterscheidung zwischen Wahrnehmung und Interpretation üben.',
      ],
    },
    {
      'n': '8',
      't': 'Rückschau und Ausblick',
      'teaser': 'Zum Abschluss schauen wir auf den gemeinsamen Weg zurück und darauf, was sich verändert hat. Der Fokus liegt auf Integration: Wie kann die Praxis nach Kursende weitergetragen und im Alltag verankert werden?',
      'fokus': 'Der Weg geht weiter',
      'zitat': 'Der Weg ist das Ziel.',
      'zitatAutor': 'Konfuzius',
      'alltagsTipp': 'Erinnere dich heute an einen Moment aus dem Kurs, der dich besonders berührt hat.',
      'reflexionsFragen': [
        'Was nimmst du aus den 8 Wochen mit?',
        'Wie möchtest du Achtsamkeit weiter in dein Leben integrieren?',
      ],
      'audioRefs': ['Ankommen', 'Sitzmeditation (lang)', 'Body-Scan (kurz)', 'Achtsamkeit in Bewegung'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 8',
          'appwrite_id': '696bfd5f002394219efb',
        },
      ],
      'wochenAufgaben': [
        '1. Eigene Praxis dauerhaft im Alltag verankern.',
        '2. Rückblick auf die 8 Wochen.',
        '3. Dankbarkeitspraxis kultivieren.',
        '4. Stille Meditation praktizieren.',
      ],
    },
  ];

  static const Map<String, dynamic> tagDerAchtsamkeit = {
    'titel': 'Tag der Achtsamkeit',
    'beschreibung': 'Ein spezieller Tag für Kursteilnehmer und Ehemalige.',
    'pdfs': [
      {
        'title': 'Ablaufplan Praxistag',
        'appwrite_id': '696c0000000000000008', // Platzhalter ID
      },
    ],
  };

  /// Gibt alle Audios aus der zentralen Mediathek zurück
  static List<Map<String, String>> getAlleAudios() {
    return mediathekAudios;
  }

  static const List<Map<String, String>> zusatzUebungen = [];
}

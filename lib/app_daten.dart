/// Zentrale Datenquelle für die gesamte App
/// Diese Datei enthält alle Kursdaten, die sowohl im MBSR-Bereich
/// als auch im Gastbereich verwendet werden
class AppDaten {
  /// Fallback-Avatar, wenn für eine Woche kein `avatarImage` gesetzt ist.
  static const String defaultWeekAvatarAsset =
      'assets/images/avatar/mbsr_avatar_default.png';

  /// Willkommens-/Kopf-Illustration (Startseite nicht eingeloggt + Kursübersicht).
  static const String welcomeHelloAvatarAsset =
      'assets/images/avatar/mbsr_avatar_profil.png';

  /// Kurze Audio-Clips (ElevenLabs-Stimme), werden per Appwrite-ID geladen.
  static const Map<String, String> begruessung = {
    'title': 'Hallo und willkommen',
    'appwrite_id': '69c80484000673452f80',
    'duration': '0:30',
  };

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
      't': 'Achtsamkeit',
      'avatarImage': 'assets/images/avatar/mbsr_avatar_autopilot_w1.png',
      'teaser':
          'Ankommen und den Autopiloten bemerken. Der Körper wird dein erster Aufmerksamkeitsanker.',
      'einfuehrung':
          'Der Kurs beginnt mit einer grundlegenden Beobachtung: Einen Großteil des Tages verbringen wir im sogenannten Autopilot-Modus — wir handeln, ohne wirklich wahrzunehmen. In dieser Woche lernst du, diesen Automatismus zu bemerken und den Körper als Anker für die Aufmerksamkeit zu nutzen. Mit dem Body-Scan und der Rosinenübung erkundest du zwei zentrale Zugänge zur achtsamen Wahrnehmung. Zwischen den Kursterminen genügen kurze, regelmäßige Übungseinheiten — es geht nicht um Dauer, sondern um Kontinuität.',
      'infoClips': {
        'begruessung': {'appwrite_id': '', 'duration': '0:30'},
        'psychoedukation': {'appwrite_id': '', 'duration': '1:00'},
      },
      'fokus': 'Ankommen, Autopilot bemerken, Körper als Anker.',
      'zitat':
          'Du kannst die Wellen nicht stoppen, aber du kannst lernen zu surfen.',
      'zitatAutor': 'Jon Kabat-Zinn',
      'alltagsTipp':
          'Lege heute zwei kurze Stopps ein: je 3 bewusste Atemzüge, zum Beispiel vor dem Start in den Tag und vor einer Mahlzeit.',
      'reflexionsFragen': [
        'Wann warst du heute im Autopiloten unterwegs, ohne es sofort zu merken?',
        'Was hat dir geholfen, wieder in den Körperkontakt zurückzukehren?',
      ],
      'audioRefs': ['Ankommen', 'Body-Scan (kurz)'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 1',
          'appwrite_id': '696bfa6b0039f0497205',
        },
        {'title': 'Neun-Punkte-Übung', 'appwrite_id': '697d0fc80030febb4db5'},
      ],
      'wochenAufgaben': [
        'Die Audioanleitung zum Body-Scan findest du in der Mediathek. Kurze Einheiten an mehreren Tagen sind ein guter Einstieg.',
        'Nimm dir eine Mahlzeit in dieser Woche bewusst vor — ohne Bildschirm, ohne Lesen. Einfach schmecken.',
        'Die Neun-Punkte-Übung liegt in den Kursunterlagen bereit. Probiere sie aus und beobachte, was dir dabei auffällt.',
        'In den Kursunterlagen findest du die Geschichte vom Oberfluss und Unterfluss — sie gibt einen ersten Impuls zum Thema Achtsamkeit.',
      ],
      'readingSummary': '',
      'archiveEligible': false,
      'readingCards': <Map<String, String>>[],
    },
    {
      'n': '2',
      't': 'Wie wir die Welt wahrnehmen',
      'avatarImage': 'assets/images/avatar/mbsr_avatar_perception_w2.png',
      'teaser':
          'Wie Gewohnheiten und Bewertungen unsere Wahrnehmung formen — und was sich zeigt, wenn wir genauer hinschauen.',
      'einfuehrung':
          'Wir nehmen die Welt nicht so wahr, wie sie ist — sondern gefiltert durch Gewohnheiten, Erwartungen und Bewertungen. Diese Woche richtet den Blick darauf, wie schnell wir von der reinen Wahrnehmung zur Interpretation springen, oft ohne es zu bemerken. Du vertiefst die Körperarbeit aus Woche 1 und beginnst, angenehme Erfahrungen im Alltag bewusst wahrzunehmen. Der Kalender der angenehmen Erlebnisse hilft dir, Aufmerksamkeit für das zu entwickeln, was oft im Hintergrund bleibt.',
      'infoClips': {
        'begruessung': {'appwrite_id': '', 'duration': '0:30'},
        'psychoedukation': {'appwrite_id': '', 'duration': '1:00'},
      },
      'fokus': 'Wahrnehmung vs. Interpretation',
      'zitat':
          'Wir sehen die Dinge nicht, wie sie sind, wir sehen sie, wie wir sind.',
      'zitatAutor': 'Anaïs Nin',
      'alltagsTipp':
          'Achte heute beim Essen darauf, wie der erste Bissen wirklich schmeckt, bevor du ihn bewertest.',
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
        {
          'title': 'Kalender der angenehmen Erlebnisse',
          'appwrite_id': '697d0fc1003193371a6a',
        },
      ],
      'wochenAufgaben': [
        'Der Body-Scan steht dir weiterhin als Audioanleitung zur Verfügung — mehrmals pro Woche ist ein gutes Maß.',
        'Wähle eine alltägliche Tätigkeit und führe sie mit Anfängergeist aus, als würdest du sie zum ersten Mal tun — Zähneputzen, Duschen, der Weg zur Arbeit.',
        'Richte zwischendurch für einige Minuten die Aufmerksamkeit auf deinen Atem. Kein besonderer Ort nötig.',
        'Der Kalender der angenehmen Erlebnisse liegt in den Kursunterlagen — eine Gelegenheit, das Angenehme bewusster wahrzunehmen.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '3',
      't': 'Im Körper beheimatet sein',
      'avatarImage': 'assets/images/avatar/mbsr_avatar_yoga_w3.png',
      'teaser':
          'Den Körper in Bewegung spüren, eigene Grenzen wahrnehmen und angenehme Erfahrungen bewusster erleben.',
      'einfuehrung':
          'Achtsamkeit findet nicht nur im Sitzen statt. In dieser Woche erweitern wir die Praxis um achtsame Körperarbeit — sanfte Bewegungen, bei denen es nicht um Leistung geht, sondern darum, den Körper von innen heraus zu spüren. Dabei wirst du eigene Grenzen wahrnehmen und lernen, sie zu respektieren, statt sie zu übergehen. Gleichzeitig vertiefen wir die Arbeit mit angenehmen Erfahrungen. Der Kalender der unangenehmen Erlebnisse liegt bereits bei — er bereitet dich auf Woche 4 vor, in der wir uns dem Stress zuwenden.',
      'infoClips': {
        'begruessung': {'appwrite_id': '', 'duration': '0:30'},
        'psychoedukation': {'appwrite_id': '', 'duration': '1:00'},
      },
      'fokus': 'Grenzen spüren und respektieren',
      'zitat': 'Aufmerksamkeit ist der Weg zum Leben.',
      'zitatAutor': 'Buddha',
      'alltagsTipp':
          'Spüre beim Gehen ganz bewusst den Kontakt deiner Füße zum Boden.',
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
        {
          'title':
              'Kalender der unangenehmen Erlebnisse (Vorbereitung für Woche 4)',
          'appwrite_id': '697d0fba00014e013bd4',
        },
      ],
      'wochenAufgaben': [
        'Wechsle diese Woche zwischen Body-Scan und achtsamer Körperarbeit ab — beides findest du in der Mediathek.',
        'Beobachte zwischendurch im Alltag deinen Atem. Ein paar bewusste Atemzüge reichen.',
        'Der Kalender der unangenehmen Erlebnisse liegt in den Kursunterlagen bereit — er ist eine Vorbereitung auf das Thema der nächsten Woche.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '4',
      't': 'Stress in Körper und Geist',
      'avatarImage': 'assets/images/avatar/mbsr_avatar_stress_w4.png',
      'teaser':
          'Wie Stress entsteht — und warum unsere Bewertung dabei eine Schlüsselrolle spielt.',
      'einfuehrung':
          'Ab dieser Woche wird es persönlicher: Wir wenden uns dem Thema Stress zu — nicht abstrakt, sondern anhand deiner eigenen Erfahrungen aus dem Kalender der unangenehmen Erlebnisse. Du lernst das transaktionale Stressmodell kennen: Stress entsteht nicht durch Situationen allein, sondern durch unsere Bewertung dieser Situationen. Wir untersuchen, wie sich Stressreaktionen im Körper anfühlen, welche Gedankenmuster sie begleiten und wo Achtsamkeit einen Unterschied machen kann.',
      'infoClips': {
        'begruessung': {'appwrite_id': '', 'duration': '0:30'},
        'psychoedukation': {'appwrite_id': '', 'duration': '1:00'},
      },
      'fokus': 'Stressreaktion verstehen',
      'zitat':
          'Nicht die Dinge selbst beunruhigen die Menschen, sondern ihre Meinungen über die Dinge.',
      'zitatAutor': 'Epiktet',
      'alltagsTipp':
          'Wenn du Stress spürst: Halte kurz inne und atme 3 Mal tief durch.',
      'reflexionsFragen': [
        'Was sind deine typischen Stressauslöser?',
        'Wie reagierst du körperlich auf Stress?',
      ],
      'audioRefs': [
        'Ankommen',
        'Sitzmeditation (kurz)',
        'Body-Scan (kurz)',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 4',
          'appwrite_id': '696bfd3d00077e7e2c0b',
        },
        {
          'title': 'Automatische Stressreaktion',
          'appwrite_id': '697d0fad0011caa23f03',
        },
      ],
      'wochenAufgaben': [
        'Übe regelmäßig mit einer der Anleitungen aus der Mediathek — Body-Scan, Körperarbeit oder Sitzmeditation, je nachdem, was dich gerade anspricht.',
        'Beobachte zwischendurch deinen Atem im Alltag.',
        'In den Lesetexten findest du Impulse zum Thema Achtsamkeit am Arbeitsplatz.',
        'Wenn du magst, halte kurz fest, wann dir Stressreaktionen auffallen — im Körper, in Gedanken oder im Verhalten.',
      ],
      'readingSummary': '',
      'archiveEligible': false,
      'readingCards': <Map<String, String>>[],
    },
    {
      'n': '5',
      't': 'Achtsamkeit gegenüber stressverschärfenden Gedanken',
      'avatarImage': 'assets/images/avatar/mbsr_avatar_meditation_w5.png',
      'teaser':
          'Gedanken beobachten, ohne ihnen zu folgen. Den Raum zwischen Reiz und Reaktion erkunden.',
      'einfuehrung':
          'Gedanken sind keine Tatsachen — aber sie können sich so anfühlen. In dieser Woche erkundest du, wie bestimmte Denkmuster Stress nicht nur begleiten, sondern aktiv verschärfen. Mit der Sitzmeditation übst du, Gedanken wahrzunehmen, ohne dich von ihnen mitreißen zu lassen. Dabei wird erfahrbar, dass zwischen einem Reiz und unserer Reaktion ein Raum liegt. In diesem Raum liegt die Freiheit, anders zu antworten, als es der Autopilot vorsieht.',
      'infoClips': {
        'begruessung': {'appwrite_id': '', 'duration': '0:30'},
        'psychoedukation': {'appwrite_id': '', 'duration': '1:00'},
      },
      'fokus': 'Zwischen Reiz und Reaktion liegt ein Raum',
      'zitat': 'Du bist nicht deine Gedanken.',
      'zitatAutor': 'Jon Kabat-Zinn',
      'alltagsTipp':
          'Beobachte deine Gedanken wie Wolken am Himmel – lass sie ziehen.',
      'reflexionsFragen': [
        'Welche Gedankenmuster tauchen bei dir häufig auf?',
        'Kannst du einen Schritt zurücktreten und deine Gedanken beobachten?',
      ],
      'audioRefs': [
        'Ankommen',
        'Sitzmeditation (mittel)',
        'Body-Scan (kurz)',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 5',
          'appwrite_id': '696bfd450038aba59bcf',
        },
        {
          'title':
              'Kalender der schwierigen Kommunikation (Vorbereitung für Woche 6)',
          'appwrite_id': '697d0f9a0021e3f24219',
        },
      ],
      'wochenAufgaben': [
        'Die Sitzmeditation steht in der Mediathek bereit. Du kannst sie im Wechsel mit Body-Scan oder Körperarbeit nutzen.',
        'Beobachte in stressigen Momenten, welche Gedanken auftauchen — und was passiert, wenn du sie einfach wahrnimmst.',
        'Der Kalender der schwierigen Kommunikation liegt in den Kursunterlagen — er ist eine Vorbereitung auf das Thema der nächsten Woche.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '6',
      't': 'Achtsame Kommunikation',
      'avatarImage': 'assets/images/avatar/mbsr_avatar_listening_w6.png',
      'teaser':
          'Zuhören, ohne zu antworten. Sprechen, ohne zu reagieren. Achtsamkeit in der Begegnung.',
      'einfuehrung':
          'Achtsamkeit zeigt sich besonders deutlich in der Begegnung mit anderen. In dieser Woche übertragen wir die Praxis auf zwischenmenschliche Situationen: Wie reagierst du in schwierigen Gesprächen? Hörst du wirklich zu — oder formulierst du bereits deine Antwort? Der Kalender der schwierigen Kommunikation aus Woche 5 liefert dein persönliches Material. Wir erkunden, wie Präsenz und eine offene innere Haltung das Miteinander verändern können.',
      'infoClips': {
        'begruessung': {'appwrite_id': '', 'duration': '0:30'},
        'psychoedukation': {'appwrite_id': '', 'duration': '1:00'},
      },
      'fokus': 'Präsenz im Kontakt',
      'zitat':
          'Das kostbarste Geschenk, das wir einem anderen machen können, ist unsere Aufmerksamkeit.',
      'zitatAutor': 'Thich Nhat Hanh',
      'alltagsTipp':
          'Höre heute in einem Gespräch nur zu, ohne sofort eine Antwort parat zu haben.',
      'reflexionsFragen': [
        'Wie verhältst du dich in schwierigen Gesprächen?',
        'Kannst du zuhören, ohne zu unterbrechen?',
      ],
      'audioRefs': [
        'Ankommen',
        'Sitzmeditation (mittel)',
        'Body-Scan (kurz)',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 6',
          'appwrite_id': '696bfd4f0037e7e16a9f',
        },
      ],
      'wochenAufgaben': [
        'Setze deine Meditationspraxis fort — wähle aus der Mediathek, was dich anspricht.',
        'Beobachte in einem Gespräch pro Tag, wie du zuhörst und was dabei in dir passiert.',
        'Nimm dir zwischendurch einen Moment, um bewusst wahrzunehmen, was deine Sinne gerade aufnehmen.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '7',
      't': 'Selbstfürsorge',
      'avatarImage': 'assets/images/avatar/mbsr_avatar_selfcare_w7.png',
      'teaser':
          'Den Blick nach innen richten: Was nährt mich, was zehrt an mir? Selbstfürsorge als bewusste Haltung.',
      'einfuehrung':
          'In den bisherigen Wochen hast du gelernt, genauer hinzuschauen — auf den Körper, auf Gedanken, auf Stress, auf Kommunikation. Jetzt richtest du diesen Blick auf dich selbst: Was nährt dich, was zehrt an dir? Selbstfürsorge ist hier keine Wellness-Empfehlung, sondern eine Frage bewusster Lebensgestaltung. Du beginnst, die formelle Praxis auch ohne Audioanleitung zu üben — ein wichtiger Schritt Richtung Eigenständigkeit.',
      'infoClips': {
        'begruessung': {'appwrite_id': '', 'duration': '0:30'},
        'psychoedukation': {'appwrite_id': '', 'duration': '1:00'},
      },
      'fokus': 'Was nährt mich, was zehrt an mir?',
      'zitat': 'Sei gut zu dir selbst, damit du gut zu anderen sein kannst.',
      'zitatAutor': 'Unbekannt',
      'alltagsTipp': 'Tue heute bewusst etwas, das dir gut tut – nur für dich.',
      'reflexionsFragen': [
        'Was gibt dir Energie im Alltag?',
        'Wo verlierst du unnötig Kraft?',
        'Was nimmst du täglich auf (Medien, Gespräche, Termine) – und was davon nährt dich wirklich?',
      ],
      'audioRefs': [
        'Ankommen',
        'Sitzmeditation (lang)',
        'Body-Scan (kurz)',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 7',
          'appwrite_id': '696bfd57000f4bb29d10',
        },
      ],
      'wochenAufgaben': [
        'Probiere diese Woche, auch ohne Audioanleitung zu üben — in Stille, in deinem eigenen Rhythmus.',
        'Schau auf deine Woche: Was nährt dich, was zehrt an dir? Wo könntest du etwas Kleines verändern?',
        'Beobachte im Alltag, wann du wahrnimmst und wann du bereits interpretierst.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '8',
      't': 'Abschied und Neubeginn',
      'avatarImage': 'assets/images/avatar/mbsr_avatar_goon_w8.png',
      'teaser':
          'Rückblick und Ausblick. Den eigenen Weg mit Achtsamkeit weitergehen.',
      'einfuehrung':
          'Acht Wochen bewusstes Üben liegen hinter dir. In dieser letzten Kurswoche schauen wir zurück: Was hat sich verändert — in deiner Wahrnehmung, im Umgang mit Stress, im Alltag? Gleichzeitig blicken wir nach vorn. Das Kursende ist kein Abschluss, sondern der Beginn einer eigenständigen Praxis. Du erstellst einen persönlichen Praxisplan, der dir hilft, Achtsamkeit dauerhaft in deinen Alltag zu integrieren.',
      'infoClips': {
        'begruessung': {'appwrite_id': '', 'duration': '0:30'},
        'psychoedukation': {'appwrite_id': '', 'duration': '1:00'},
        'verabschiedung': {'appwrite_id': '', 'duration': '0:45'},
      },
      'fokus': 'Der Weg geht weiter',
      'zitat': 'Der Weg ist das Ziel.',
      'zitatAutor': 'Konfuzius',
      'alltagsTipp':
          'Erinnere dich heute an einen Moment aus dem Kurs, der dich besonders berührt hat.',
      'reflexionsFragen': [
        'Was nimmst du aus den 8 Wochen mit?',
        'Wie möchtest du Achtsamkeit weiter in dein Leben integrieren?',
      ],
      'audioRefs': [
        'Ankommen',
        'Sitzmeditation (lang)',
        'Body-Scan (kurz)',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 8',
          'appwrite_id': '696bfd5f002394219efb',
        },
      ],
      'wochenAufgaben': [
        'Alle Übungen aus dem Kurs stehen dir weiterhin in der Mediathek zur Verfügung — auch stille Meditation ohne Anleitung.',
        'Schau zurück: Was hat sich in den letzten acht Wochen für dich verändert?',
        'Erstelle dir einen persönlichen Praxisplan — wann, welche Übung, wie lange. Auch eine Ausweichoption für stressige Wochen ist hilfreich.',
        'Wenn du magst, nimm dir täglich einen Moment für Dankbarkeit — für etwas Konkretes, das dir an diesem Tag begegnet ist.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
  ];

  static const Map<String, dynamic> tagDerAchtsamkeit = {
    'titel': 'Tag der Achtsamkeit',
    'datum': '17. Mai 2026',
    'uhrzeit': '9:30–15:00 Uhr',
    'beschreibung':
        'Ein vertiefender Übungstag in Stille für Kursteilnehmer und Ehemalige. Wir üben im Wechsel Sitzmeditation, Body-Scan, achtsame Bewegung und Gehmeditation. Selbstfürsorge hat Vorrang: Du kannst jederzeit anpassen oder pausieren.',
    'pdfs': [
      {
        'title': 'Ablaufplan Praxistag (folgt)',
        'appwrite_id': '696c0000000000000008', // Wird nach Upload ersetzt
      },
    ],
  };

  /// Gibt alle Audios aus der zentralen Mediathek zurück
  static List<Map<String, String>> getAlleAudios() {
    return mediathekAudios;
  }

  static const List<Map<String, String>> zusatzUebungen = [];
}

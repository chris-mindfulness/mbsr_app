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
      't': 'Achtsamkeit',
      'teaser':
          'In Woche 1 geht es ums Ankommen im Kurs. Du übst, automatische Abläufe (Autopilot) zu bemerken und den Körper als Aufmerksamkeitsanker zu nutzen. Für die Zeit zwischen den Terminen sind kurze, regelmäßige Übungseinheiten ausreichend.',
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
        '1.	Body-Scan an mehreren Tagen mit der Audiodatei üben (kurze Einheiten sind ausreichend).',
        '2.	Mindestens eine Mahlzeit in dieser Woche achtsam einnehmen (ohne nebenbei zu scrollen oder zu lesen).',
        '3.	Die Neun-Punkte-Übung durchführen und kurz notieren, was dir aufgefallen ist.',
        '4.	Die Geschichte vom Oberfluss und Unterfluss lesen.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '2',
      't': 'Wie wir die Welt wahrnehmen',
      'teaser':
          'In diesem Termin vertiefen wir die Aufmerksamkeit für den Körper und erforschen, wie Wahrnehmung durch Bewertungen und Gewohnheiten geprägt ist. Durch praktische Übungen wird erfahrbar, wie schnell wir interpretieren – und was sich verändert, wenn wir offener wahrnehmen.',
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
        '1.	Body-Scan mit Audiodatei mehrmals pro Woche üben.',
        '2.	Eine alltägliche Tätigkeit mit Anfängergeist ausführen (z. B. Zähneputzen, Duschen, Geschirrspülen).',
        '3.	Möglichst täglich für einige Minuten die Aufmerksamkeit auf den Atem richten.',
        '4.	Den Kalender der angenehmen Erlebnisse nutzen.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '3',
      't': 'Im Körper beheimatet sein',
      'teaser':
          'Achtsame Bewegung eröffnet einen weiteren Zugang zum eigenen Erleben und zu persönlichen Grenzen. Gleichzeitig richten wir den Blick auf angenehme Erfahrungen im Alltag und darauf, wie sie bewusster wahrgenommen und verankert werden können. Der Kalender der unangenehmen Erlebnisse ist hier bereits hinterlegt, damit du ihn als Vorbereitung auf Woche 4 nutzen kannst.',
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
        '1.	Mehrmals pro Woche Body-Scan oder achtsame Körperarbeit üben.',
        '2.	Möglichst täglich den Atem im Alltag beobachten.',
        '3.	Den Kalender der unangenehmen Erlebnisse als Vorbereitung auf Woche 4 ausfüllen.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '4',
      't': 'Stress in Körper und Geist',
      'teaser':
          'Dieser Termin widmet sich unangenehmen Erfahrungen und der Frage, wie Stress entsteht. Wir untersuchen persönliche Stressmuster und nähern uns dem Zusammenhang von Wahrnehmung, Reaktion und Belastung.',
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
        '1.	Regelmäßige formelle Praxis (Body-Scan, Körperarbeit oder Sitzmeditation).',
        '2.	Atembeobachtung im Alltag.',
        '3.	Abschnitt „Achtsamkeit am Arbeitsplatz“ lesen.',
        '4.	Stressreaktionen notieren.',
      ],
      'readingSummary':
          'Hier findest du die Volltexte aus Sitzung 4 in weitgehend vollständiger Form. Ziel ist Nachlesen ohne Informationsverlust zwischen den Treffen.',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'wk4-gasthaus',
          'title': 'Das Gasthaus',
          'body': """Das menschliche Dasein ist ein Gasthaus.
Jeden Morgen ein neuer Gast.
Freude, Depression und Niedertracht,
auch ein kurzer Moment der Achtsamkeit kommt
als unverhoffter Besucher.
Begrüße und bewirte sie alle!
Selbst wenn es eine Schar von Sorgen ist,
die gewaltsam dein Haus seiner Möbel entledigt,
selbst dann behandle jeden Gast mit Respekt,
vielleicht bereitet er dich vor
auf ganz neue Freuden.
Die dunklen Gedanken der Scham, der Bosheit -
Begegne ihnen lachend an der Tür
und lade sie ein.
Sei dankbar für jeden, wer es auch sei,
denn alle wurden zu deiner Führung geschickt
aus einer anderen Welt.""",
          'source_ref': 'MBSR Kursheft - Sitzung 4, S. 31',
        },
        {
          'id': 'wk4-unangenehm',
          'title': 'Dem Unangenehmen zuwenden',
          'body':
              """Im Laufe der letzten Wochen werden Sie vielleicht in Situationen gekommen sein, in denen Sie eine Abneigung gespürt haben. Nicht nur im Berufsleben, sondern vielleicht auch im MBSR-Kurs ("Diese Übung mag ich nicht.", "Mein Knie tut mir weh, wieso tue ich mir das an?").

Wenden Sie sich bewusst unangenehmen oder unfreundlichen Gefühlen, Empfindungen und Gedanken zu, und registrieren Sie, wie Sie darauf reagieren - insbesondere körperlich.

Schauen Sie, ob Sie nach und nach die Symptome der Abneigung erkennen können - Wie fühlt sich Abneigung an? Wo und wie spüren Sie sie im Körper? Wie wirkt sie sich auf Ihr Denken aus?

Was sind Ihre persönlichen "Abneigungsmuster" (das typische Muster von körperlichen Empfindungen, durch die Sie erkennen, dass Abneigung da ist)?

Nachdem Sie Ihr Abneigungsmuster kennengelernt haben, schauen Sie, ob es Ihnen hilft, sich zu sagen "da ist Abneigung", wann immer Sie bemerken, dass dieses Gefühl aufkommt.

Notieren Sie regelmäßig Ihre Beobachtungen.""",
          'source_ref': 'MBSR Kursheft - Sitzung 4, S. 31-32',
        },
        {
          'id': 'wk4-zwei-pfeile',
          'title': 'Die zwei Pfeile',
          'body':
              """Wenn wir von einem Pfeil getroffen würden, würde natürlich jeder von uns physischen Schmerz und Unbehagen verspüren.

Aber bei den meisten von uns ist es, als würden sie nach dem ersten Pfeil von einem zweiten Pfeil getroffen - der Abneigung -, dem Leiden also, das durch Reaktionen wie Wut, Angst, Niedergeschlagenheit und so weiter verursacht wird und das wir dem Schmerz und Leiden des ersten Pfeiles hinzufügen.

In den meisten Fällen beschert uns dieser zweite Pfeil das größere Leiden. Die wichtige Botschaft dieses Bildes besteht darin, dass wir lernen können, uns vom Leiden des zweiten Pfeiles zu befreien.

Wieso? Weil wir ihn selbst auf uns abschießen!""",
          'source_ref': 'MBSR Kursheft - Sitzung 4, S. 32',
        },
        {
          'id': 'wk4-moegen-statt-wollen',
          'title': 'Mögen statt Wollen',
          'body':
              """Sobald Sie eine positive Erfahrung machen, entsteht der natürliche Wunsch, an ihr festzuhalten. Doch wenn Sie dies tun, befinden Sie sich nicht mehr im Flow dieser Erfahrung, sondern entfernen sich von ihr, indem sie versuchen, sie "einzufrieden" und zu besitzen. Und das ist keine gute Erfahrung mehr. Es ist wie beim Musikhören. Wenn Sie versuchen, eine großartige Stelle in Ihrem Kopf zu wiederholen, während die Musik weitergeht, dann verlieren Sie den Kontakt zu ihr und der Genuss schwindet. Deshalb kommt es auf die Kunst an, die gute Erfahrung zu mögen, ohne sie zu wollen.

Mögen heißt auch schätzen und genießen. Mit Wollen meine ich alles von Getriebenheit, Beharrlichkeit, innerem Zwang, Druck und Gier bis hin zu sozialer Bindung, Sehnsucht und Verlangen. In unserem limbischen System und im Hirnstamm werden das Mögen und das Wollen durch verschiedene miteinander verbundene Schaltkreise gesteuert. Das bedeutet, dass man Dinge mögen kann, ohne sie zu wollen. Zum Beispiel kann man sich nach einer ausgiebigen Mahlzeit ein Eis zum Dessert verkneifen, obgleich man durchaus Lust darauf hätte. Andere Dinge kann man wollen, ohne sie zu mögen. Ich habe schon Leute gelangweilt und teilnahmslos am Spielautomaten sitzen sehen. Immer und immer wieder haben sie ihn in Gang gesetzt, doch nicht einmal zwischenzeitliche Gewinne schienen sie zu interessieren.

Dass wir Annehmlichkeiten mögen, ist völlig normal und in Ordnung. Schwierig wird es erst dann, wenn wir Dinge wollen, die nicht gut für uns oder andere sind. Wenn wir zum Beispiel einen Drink zu viel trinken oder einen Streit auf Teufel komm raus gewinnen wollen. Schwierigkeiten entstehen auch dann, wenn wir Gutes wollen, aber mit unguten Mitteln zu erreichen versuchen. Wenn ich zum Beispiel zu schnell fahre (schlecht), um rechtzeitig zur Arbeit zu kommen (gut). Und ehrlich gesagt halte ich das Wollen an sich für eine problematische Erfahrung. Überlegen Sie, wie es sich anfühlt, ein starkes Verlangen zu haben oder unbedingt ein Ziel erreichen zu wollen. Etwas zu wollen hat wenig mit Inspiration, Sehnsucht, Leidenschaft oder Hingabe zu tun. Können wir lang-anhaltende Arbeit verrichten, ohne uns getrieben zu fühlen? Da das Wollen mit einem Defizit oder einem Mangel einhergeht, aktiviert es den reaktiven Modus unseres Gehirns, was uns unter Stress setzt. Es gibt ein Sprichwort: Mögen ohne Wollen ist der Himmel, Wollen ohne Mögen die Hölle.

Die Kunst besteht darin, die Erfahrung zu genießen, wenn sie durch einen hindurchgeht, ohne sich an sie zu klammern, und gute Ziele mit guten Mitteln anzustreben, ohne sich getrieben zu fühlen. Wenn Sie etwas Gutes in Ihrer Erfahrung bemerken, dann versuchen Sie dieses behutsam zu fördern und auszubauen, ohne es krampfhaft festhalten zu wollen. Unser Gehirn neigt dazu, nach neuen Objekten unseres Willens Ausschau zu halten. Doch indem wir wiederholt die Erfahrung in uns aufnehmen, etwas zu mögen, ohne es zu wollen, können wir dieser Neigung entgegenwirken.""",
          'source_ref': 'MBSR Kursheft - Sitzung 4, S. 33',
        },
        {
          'id': 'wk4-was-ist-stress',
          'title': 'Was ist Stress?',
          'body':
              """Obwohl jeder weiß, was gemeint ist, wenn man "gestresst" ist, ist der Begriff Stress komplexer und schwerer zu fassen. Aus evolutionärer Sicht ist Stress ein uralter, biologisch sinnvoller Mechanismus, der dem Menschen durch einen reflexhaften Angriffs- oder Fluchtmechanismus das Überleben sichert. Bei drohender Gefahr wird dem Menschen durch eine blitzschnelle Kräftemobilisierung des Organismus eine schnelle Anpassung an Belastungen und Herausforderungen ermöglicht.

Diese durch Stress ausgelöste körperliche Aktivierung ist nun nicht per se gesundheitsschädlich, sondern kann, wenn sie von regelmäßigen Phasen der Entspannung abgelöst wird, sogar als "Würze des Leben", betrachtet werden, wie Selye ein Pionier der Stressforschung dies getan hat. Der "steinzeitliche" Mechanismus Stress, der uns im positiven Fall reflexartiges und hellwaches Reagieren ermöglicht, wird für den heutigen Menschen erst dadurch zum Problem, dass er in einer modernen Gesellschaft durch eine Vielzahl von Reizen zwar unzählige Male am Tag ausgelöst wird, zugleich aber die durch die Stressreaktion produzierte Energie nicht mehr in Kampf oder Flucht verbraucht wird.

Mit dem Stressbegriff ist nun aber keineswegs nur die Stressreaktion gemeint, die sich in vielfältigen körperlichen Symptomen ebenso zeigt wie in Gedanken, in Gefühlen und im Verhalten. Genauso einseitig wäre es auch beim Stressbegriff nur an die Stressauslöser bzw. Stressoren zu denken.

Stress ist weder nur Reiz (Stressauslöser) noch nur Reaktion. Vielmehr stehen nach heute verbreitetem Verständnis, welches auf den Stressforscher Lazarus zurückgeht, beide Aspekte (Stressor und Stressreaktion) in einer Beziehung der wechselseitigen Beeinflussung (Transaktion) zueinander.

Nach dieser Auffassung gibt es keine Reize, die per se "objektiv" als Stressauslöser wirken. Dazu werden sie erst durch die individuelle Bewertung der Person, welche die Situation erlebt. Diese Bewertungen entscheiden darüber, ob wir eine Situation als irrelevant, als angenehm positiv oder als stressbezogen erleben.

Ebenso beeinflussen die Bewertungen maßgeblich die Art der Stressreaktion. Anders als zu Zeiten Selyes weiß man heute, dass die Stressreaktion nicht bei allen Menschen und in allen Belastungssituationen in gleicher stereotyper Weise abläuft. Sie kann je nach individueller Reaktionsspezifität und je nach Bewertung mit unterschiedlichen Emotionen verbunden sein.""",
          'source_ref': 'MBSR Kursheft - Sitzung 4, S. 34-35',
        },
        {
          'id': 'wk4-folgen-stress',
          'title': 'Folgen von Stress auf verschiedenen Ebenen',
          'body': """Physische Ebene
- Herzkrankheiten
- Verdauungsprobleme
- Rückenschmerzen
- Kopfschmerzen
- Hoher Blutdruck
- Ungleichgewicht auf hormoneller Ebene

Psychologische/gedankliche Ebene
- Burnout
- Depressive Symptomatik bis hin zu Depressionen
- Angst
- Familiäre Probleme
- Schlafprobleme
- Jobunzufriedenheit/Schulunzufriedenheit
- Schlechte Informationsverarbeitung

Verhaltensebene
- Abwesenheit, Verspätung
- Suchtverhalten
- Unfälle
- Gewalt
- Geringere Leistungsfähigkeit""",
          'source_ref': 'MBSR Kursheft - Sitzung 4, S. 35',
        },
        {
          'id': 'wk4-stresszyklus',
          'title': 'Abbildung: Folgen von Stress auf Körper und Geist',
          'body':
              """Vereinfachte Lesefassung des Stresszyklus aus der Abbildung:

Äußere Stressoren + innere Stressoren
-> Wahrnehmung und Beurteilung
-> Warnsystem / Kampf oder Flucht
-> Stressreaktion (Hypothalamus, Hypophyse, Nebennieren)
-> Aktivierung von Herz- und Gefäßsystem, Skelettmuskulatur, Nervensystem, Immunsystem

Mögliche Folgedynamiken:
- akute Übererregung (Puls und Blutdruck steigen)
- chronische Überreizung (z. B. Hypertonie, Herzrhythmusstörungen, Schlafstörungen, Kopf-/Rückenschmerzen, Ängste)
- maladaptive Verhaltensweisen (z. B. Arbeitswut, Hyperaktivität, Abhängigkeiten)
- fortgesetzte Belastung bis zu starker physischer und psychischer Erschöpfung""",
          'source_ref': 'MBSR Kursheft - Sitzung 4, S. 36 (Abbildung)',
        },
        {
          'id': 'wk4-arbeitsplatz',
          'title': 'Achtsamkeit am Arbeitsplatz / im Unialltag',
          'body':
              """Nimm dir jeden Morgen ein paar Minuten Zeit, um still zu sein und zu meditieren. Setze oder lege dich hin, um ganz bei dir zu sein. Blicke aus dem Fenster, höre den Geräuschen der Natur zu, mache einen kurzen Spaziergang.

Wenn du deinen Arbeitsweg beginnst, nimm dir eine Minute Zeit, um auf deinen Atem zu achten.

Auf dem Weg zur Arbeit nimm die Spannungen im Körper wahr (z. B. verkrampfte Hände, hochgezogene Schultern, angespannter Magen). Erlaube diesen Spannungen, sich zu lösen.

Entscheide dich dafür, das Autoradio nicht einzuschalten und mit dir selbst zu sein.

Wenn du zu einer roten Ampel kommst, nutze die Zeit, um deinen Atem wahrzunehmen, ebenso die Bäume, den Himmel oder deine Gedanken in diesem Moment.

Wenn du an deinem Arbeitsplatz angekommen bist, nimm dir einen Moment Zeit, um wirklich anzukommen. Werde dir bewusst, wo du bist und wohin du gehst.

Werde dir an deinem Arbeitsplatz immer wieder deiner körperlichen Wahrnehmungen bewusst und entlasse unnötige Anspannung.

Nutze die Pausen, um dich wirklich zu entspannen. Vielleicht machst du einen kurzen Spaziergang, anstatt Kaffee zu trinken oder zu rauchen.

Entscheide dich, jede Stunde einen "Stopp" von 1-X Minuten einzulegen, während dessen du dir deines Atems und deiner Körperwahrnehmungen bewusst wirst.

Verwende Anhaltspunkte in deiner Umgebung als Erinnerung für deine Zentrierung auf dich selbst (z. B. das Klingeln des Telefons, die rote Ampel).

Nimm dir auf dem Nachhauseweg einen Moment Zeit, um bewusst den Wechsel von der Arbeit zu deinem Zuhause zu vollziehen.

Wenn du zuhause angekommen bist, nimm dir einen Augenblick, um dich bewusst auf das Zuhause-Sein einzustimmen.""",
          'source_ref': 'MBSR Kursheft - Sitzung 4, S. 38-39',
        },
      ],
    },
    {
      'n': '5',
      't': 'Achtsamkeit gegenüber stressverschärfenden Gedanken',
      'teaser':
          'Gedanken stehen heute im Mittelpunkt: Wie tragen sie zur Entstehung von Stress bei? Durch Achtsamkeit wird erfahrbar, dass zwischen Reiz und Reaktion ein Spielraum liegt, der neue Handlungsmöglichkeiten eröffnet.',
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
        '1.	Sitzmeditation üben, im Wechsel mit Body-Scan oder Körperarbeit.',
        '2.	Achtsamkeit in stressigen Situationen anwenden.',
        '3.	Kalender der „Schwierigen Kommunikation“ zur Vorbereitung auf Woche 6 ausfüllen.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '6',
      't': 'Achtsame Kommunikation',
      'teaser':
          'Achtsamkeit wird nun auf zwischenmenschliche Situationen übertragen. Wir erforschen, wie wir in schwierigen Gesprächen reagieren, zuhören und sprechen – und welche Rolle innere Haltung und Präsenz dabei spielen.',
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
        '1. Sitzmeditation üben, im Wechsel mit Body-Scan oder Körperarbeit.',
        '2.	Reaktionen in zwischenmenschlichen Situationen beobachten.',
        '3.	Sinneseindrücke bewusst wahrnehmen.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '7',
      't': 'Selbstfürsorge',
      'teaser':
          'Dieser Termin lädt dazu ein, Selbstfürsorge als bewusste Haltung im Alltag zu betrachten. Wir erkunden, was uns nährt und was uns erschöpft, und wie Achtsamkeit helfen kann, stimmigere Entscheidungen zu treffen.',
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
        '1.	Übungen ohne Anleitung praktizieren.',
        '2.	Reflexion über das Kursende und die Fortführung der Praxis.',
        '3.	Unterscheidung zwischen Wahrnehmung und Interpretation üben.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
    {
      'n': '8',
      't': 'Abschied und Neubeginn',
      'teaser':
          'Zum Abschluss schauen wir auf den gemeinsamen Weg zurück und darauf, was sich verändert hat. Der Fokus liegt auf Integration: Wie kann die Praxis nach Kursende weitergetragen und im Alltag verankert werden?',
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
        '1. Eigene Praxis dauerhaft im Alltag verankern.',
        '2. Rückblick auf die 8 Wochen.',
        '3. Dankbarkeitspraxis kultivieren.',
        '4. Einen 4-Wochen-Praxisplan erstellen (Wann, welche Übung, Mindestdauer, Ausweichoption).',
        '5. Stille Meditation praktizieren.',
      ],
      'readingCards': <Map<String, String>>[],
      'readingSummary': '',
      'archiveEligible': false,
    },
  ];

  static const Map<String, dynamic> tagDerAchtsamkeit = {
    'titel': 'Tag der Achtsamkeit',
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

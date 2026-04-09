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
    'appwrite_id': '',
    'duration': '0:30',
  };

  /// Gemeinsame Mediathek-Beschreibung für alle drei Sitzmeditationen (Kurz/Mittel/Lang).
  /// Ergänzt den Basistext mit Kursinhalten, die absichtlich nicht in jeder Audioanleitung wiederholt werden.
  static const String sitzmeditationMediathekBeschreibung =
      'In der Sitzmeditation stabilisierst du deine Aufmerksamkeit auf einem primären Objekt '
      '(meist der Atembewegung). Wenn der Fokus abschweift – was ein natürlicher Prozess des '
      'Gehirns ist – wird dies wertfrei registriert und die Aufmerksamkeit aktiv zum Anker '
      'zurückgeführt.\n\n'
      'Phase ohne festes Objekt: In manchen Übungen gibt es eine Phase ohne bestimmtes '
      'Meditationsobjekt — im Kurs wird das auch als offenes Gewahrsein bezeichnet.\n\n'
      'Hinweise zur Praxis: Versuche, die Übung möglichst täglich durchzuführen. Geh mit '
      'Anfängergeist an die Übung heran — so, als wäre es das erste Mal. Bleib neugierig und '
      'geduldig und hab Vertrauen in die Übung.\n\n'
      'Nach der Übung kannst du für dich festhalten, was es für dich bedeutet, dir diese Zeit '
      'genommen zu haben.\n\n'
      'Bei Fragen melde dich gern bei mir.';

  /// Zentrale Mediathek-Daten (Quelle für alle Audios)
  static const List<Map<String, String>> mediathekAudios = [
    {
      'title': 'Ankommen (Laura)',
      'duration': '3 Min',
      'appwrite_id': '69d37c03003cf64043b3',
      'description':
          'Diese kurze Übung hilft dir, im aktuellen Moment anzukommen. Du nimmst erst wahr, wie es dir körperlich und geistig geht, und findest dann über die Atembewegung zurück in den Körper. Ideal als ruhiger Start in den Tag oder als bewusste Pause zwischendurch. Gesprochen von Laura.',
    },
    {
      'title': 'Ankommen (Chris)',
      'duration': '3 Min',
      'appwrite_id': '69d37c0d001f3b9eb949',
      'description':
          'Diese kurze Übung hilft dir, im Moment anzukommen und kurz innezuhalten. Du nimmst wahr, wie es dir gerade körperlich und geistig geht, und richtest die Aufmerksamkeit auf die Atembewegung im Körper. Ideal als kleine Pause im Alltag. Gesprochen von Chris.',
    },
    {
      'title': 'Body-Scan kompakt (Laura)',
      'duration': '10 Min',
      'appwrite_id': '69d7b44b000b2412d139',
      'description':
          'Ein kompakter Body-Scan für Tage mit wenig Zeit. Du wanderst achtsam durch den Körper, von den Füßen bis zum Kopf, und nimmst wahr, was gerade da ist, ohne etwas ändern zu müssen. Zum Abschluss weitest du die Aufmerksamkeit auf Atem, Raum und Geräusche. Gesprochen von Laura.',
    },
    {
      'title': 'Body-Scan kompakt (Chris)',
      'duration': '10 Min',
      'appwrite_id': '69d7b356002ff105c051',
      'description':
          'Ein kompakter Body-Scan für Tage mit wenig Zeit. Du wanderst achtsam durch den Körper, von den Füßen bis zum Kopf, und nimmst wahr, was gerade da ist, ohne etwas ändern zu müssen. Zum Abschluss weitest du die Aufmerksamkeit auf Atem, Raum und Geräusche. Gesprochen von Chris.',
    },
    {
      'title': 'Body-Scan standard',
      'duration': '20 Min',
      'appwrite_id': '696bff8a003533170ca4',
      'description':
          'In der Standard-Version durchwanderst du den Körper achtsam und in gutem Tempo. Du übst, Empfindungen wie Druck, Wärme, Kribbeln oder auch Nicht-Empfinden freundlich wahrzunehmen. Eine gute Übung, um dich wieder mit dir selbst zu verbinden.',
    },
    {
      'title': 'Body-Scan vertiefend',
      'duration': '35 Min',
      'appwrite_id': '696bff9b000d16345521',
      'description':
          'Die vertiefende Version ist die ausführliche Body-Scan-Praxis mit viel Raum zum Verweilen. Du gehst den Körper Bereich für Bereich durch, nimmst auch subtile Signale wahr und kommst bei Abschweifungen freundlich zurück. Ideal, wenn du dir bewusst mehr Zeit für tiefe Verkörperung und Präsenz nehmen möchtest.',
    },
    {
      'title': 'Sitzmeditation kurz',
      'duration': '10 Min',
      'appwrite_id': '696bffa2000a833c13ce',
      'description': sitzmeditationMediathekBeschreibung,
    },
    {
      'title': 'Sitzmeditation mittel',
      'duration': '15 Min',
      'appwrite_id': '696bffaa00090187914b',
      'description': sitzmeditationMediathekBeschreibung,
    },
    {
      'title': 'Sitzmeditation lang',
      'duration': '20 Min',
      'appwrite_id': '696bffb000325d0acc84',
      'description': sitzmeditationMediathekBeschreibung,
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
          'Die Metta-Meditation stärkt die liebevolle Güte gegenüber dir selbst und anderen. Besonders wertvoll für das Wohlbefinden.',
    },
    {
      'title': 'Tour der Sinne',
      'duration': '10 Min',
      'appwrite_id': '696bffd600298b5e9c51',
      'description':
          'Erforsche die Welt durch deine Sinne – Hören, Spüren, Riechen. Eine Einladung, die Welt ganz neu wahrzunehmen.',
    },
  ];

  /// Kurzmeditationen für den **Notfall-Koffer** (direktes Abspielen, Sonderstatus).
  ///
  /// Unabhängig von neuen Mediathek-Einträgen: hier nur explizit verknüpfen, was im
  /// Notfall-Koffer erscheinen soll (optional per [mediathek_title] auf [mediathekAudios]).
  ///
  /// Pro Eintrag mindestens [card_title] und [card_description] (Sheet-Anzeige).
  ///
  /// **Audio zuordnen** (eine Variante):
  /// - [mediathek_title]: Titel wie in [mediathekAudios] — nutzt dieselbe `appwrite_id`.
  /// - Oder direkt [title], [duration], [appwrite_id] (und optional [description]) für reine SOS-Dateien.
  ///
  /// Platzhalter: [upload_status] = `pending` bis die Datei in Appwrite liegt.
  ///
  /// [icon]: `timer` · `self_improvement` · `favorite_outline` · `waves` (Standard: `timer`).
  static const List<Map<String, String>> notfallKofferMeditationen = [
    {
      'mediathek_title': 'Ankommen (Laura)',
      'card_title': 'Kurzes Ankommen (ca. 3 Min)',
      'card_description':
          'Eine kurze Pause zum Sammeln — die geführte Übung startet sofort.',
      'icon': 'timer',
    },
    {
      'card_title': 'Zweite Kurzmeditation',
      'card_description':
          'Platzhalter — später hier zweite Übung eintragen ([mediathek_title] oder [appwrite_id]).',
      'icon': 'self_improvement',
      'upload_status': 'pending',
    },
    {
      'card_title': 'Dritte Kurzmeditation',
      'card_description':
          'Platzhalter — später hier dritte Übung eintragen ([mediathek_title] oder [appwrite_id]).',
      'icon': 'favorite_outline',
      'upload_status': 'pending',
    },
  ];

  /// Liefert die Audio-Map für [AudioService.play], oder leer bei Konfigurationsfehler.
  /// Bei `upload_status: pending` im Eintrag: Map nur mit `upload_status` (SnackBar in der UI).
  static Map<String, String> notfallPlaybackForEntry(Map<String, String> entry) {
    final pending = entry['upload_status'] == 'pending';
    final ref = entry['mediathek_title']?.trim();
    if (ref != null && ref.isNotEmpty) {
      for (final a in mediathekAudios) {
        if (a['title'] == ref) {
          return Map<String, String>.from(a);
        }
      }
      return pending ? {'upload_status': 'pending'} : <String, String>{};
    }
    final id = entry['appwrite_id']?.trim() ?? '';
    if (id.isNotEmpty) {
      return {
        'title': entry['title'] ?? entry['card_title'] ?? 'Übung',
        'duration': entry['duration'] ?? '',
        'appwrite_id': id,
        'description': entry['description'] ?? '',
        if (pending) 'upload_status': 'pending',
      };
    }
    if (pending) {
      return {'upload_status': 'pending'};
    }
    return {};
  }

  // Alle Wochen-Daten (formale Übungen über Mediathek; optional `audioRefs` nur noch für Datenpflege/Tests)
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
        'begruessung': {
          'appwrite_id': '',
          'duration': '0:30',
        },
        'psychoedukation': {
          'appwrite_id': '',
          'duration': '1:00',
        },
      },
      'fokus': 'Ankommen, Autopilot bemerken, Körper als Anker.',
      'zitat':
          'The present moment is the only moment available to us, and it is the door to all moments.',
      'zitatAutor': 'Thich Nhat Hanh',
      'alltagsTipp':
          'Lege heute zwei kurze Stopps ein: je 3 bewusste Atemzüge, zum Beispiel vor dem Start in den Tag und vor einer Mahlzeit.',
      'reflexionsFragen': [
        'Wann warst du heute im Autopiloten unterwegs, ohne es sofort zu merken?',
        'Was hat dir geholfen, wieder in den Körperkontakt zurückzukehren?',
      ],
      'audioRefs': ['Ankommen (Laura)', 'Body-Scan kompakt (Laura)'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 1',
          'appwrite_id': '69d6644e002937403f0a',
          'kind': 'kursunterlage',
        },
        {
          'title': 'Neun-Punkte-Übung',
          'appwrite_id': '697d0fc80030febb4db5',
          'kind': 'arbeitsblatt',
        },
      ],
      'wochenAufgaben': [
        'Body-Scan-Anleitungen findest du in der Mediathek in verschiedenen Längen. Kurze Einheiten an mehreren Tagen sind ein guter Einstieg.',
        'Nimm dir eine Mahlzeit in dieser Woche bewusst vor — ohne Bildschirm, ohne Lesen. Einfach schmecken.',
        'Die Neun-Punkte-Übung liegt in den Kursunterlagen bereit. Probiere sie aus und beobachte, was dir dabei auffällt.',
        'In den Kursunterlagen findest du die Geschichte vom Oberfluss und Unterfluss — sie gibt einen ersten Impuls zum Thema Achtsamkeit.',
      ],
      'readingSummary':
          'Kurze Impulse aus der Forschung — alltagsnah und mit ehrlicher Einordnung.',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'w1-goldberg-meta',
          'title': 'Was Studien zu Achtsamkeitsprogrammen zeigen',
          'body':
              'Die Forschung zu Programmen wie MBSR und MBCT ist inzwischen breit: In einer großen Bestandsaufnahme wurden 44 Übersichtsarbeiten mit insgesamt über 300 Einzelstudien und rund 30.000 Teilnehmenden ausgewertet. Danach können achtsamkeitsbasierte Programme Stress, depressive Symptome und Angst messbar lindern; in vielen Arbeiten sind sie mit etablierten Verfahren vergleichbar.\n\n'
              'Wichtig für ein faires Bild: Wenn man sie nicht mit einer Warteliste vergleicht, sondern mit anderen aktiven Programmen, wirken die Vorteile oft kleiner. Das macht die Praxis nicht wertlos — es erinnert daran, dass Achtsamkeit kein Wundermittel ist. Bei schwerer Erkrankung bleibt professionelle Hilfe der richtige Ort.',
        },
        {
          'id': 'w1-autopilot',
          'title': 'Geist abwesend — und trotzdem da?',
          'body':
              'In einer bekannten Studie wurden Menschen per Smartphone zu zufälligen Zeiten gefragt: Was tust du gerade? Wo ist dein Geist? Wie fühlst du dich? Ergebnis: In etwa 47 % der Wachzeit war die Aufmerksamkeit nicht bei der aktuellen Tätigkeit.\n\n'
              'Neuere Arbeiten zeigen: So pauschal stimmt das nicht; es kommt darauf an, wie genau man fragt, und nicht jedes Abschweifen ist schlecht. Entscheidend für diesen Kurs ist etwas anderes: Du kannst üben, früher zu merken, wohin der Geist gewandert ist — und zu entscheiden, ob du zurück zum Moment kehrst.',
        },
        {
          'id': 'w1-anfangsunruhe',
          'title': 'Wenn die erste Zeit unruhiger wirkt',
          'body':
              'Manche Menschen berichten: In den ersten Tagen der Meditation fühlt sich innen eher mehr an — mehr Unruhe, mehr Gedanken, mehr Spannung. Das kann bedeuten, dass du genauer hinhörst, nicht dass du es falsch machst. Sanft dranbleiben und kürzere Einheiten wählen hilft oft.\n\n'
              'Warum Wirkung oft erst später sichtbar wird, findest du in der Vertiefung unter „Gut zu wissen“.\n\n'
              'Wenn du dich dauerhaft stark überfordert oder krank fühlst, ist das kein Bereich zum Durchbeißen: Dann ist professionelle Unterstützung der richtige nächste Schritt.',
        },
        {
          'id': 'w1-formal-alltag',
          'title': 'Sitzen oder im Alltag üben?',
          'body':
              'Für Einsteigerinnen und Einsteiger können kurze formale Sitzübungen und achtsame Momente im Alltag vergleichbare Effekte zeigen — entscheidend ist, was du wirklich regelmäßig tun kannst. Auf dem Stuhl, beim Gehen, beim Spülen: Die beste Praxis ist die, die stattfindet.\n\n'
              'Kontinuität schlägt oft die perfekte Dauer.',
        },
        {
          'id': 'w1-fuenf-minuten',
          'title': 'Kurz üben — reicht das?',
          'body':
              'In Studien mit etwa fünf Minuten täglicher Praxis über mehrere Wochen fanden Forschende Verbesserungen bei Stress, Stimmung und Wohlbefinden. Die Arbeiten stammen überwiegend aus einem Forschungskontext; strengere Kontrollen und unabhängige Wiederholungen gibt es noch vergleichsweise wenige.\n\n'
              'Für den Alltag bleibt die Botschaft dennoch ermutigend: Schon wenige Minuten können einen Unterschied machen, wenn du sie einplanst und dir nicht das Gefühl gibst, es müsse immer „länger“ sein.',
        },
      ],
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
      'audioRefs': ['Ankommen (Laura)', 'Body-Scan kompakt (Laura)'],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 2',
          'appwrite_id': '69d6645e0033e35d88e3',
          'kind': 'kursunterlage',
        },
        {
          'title': 'Kalender der angenehmen Erlebnisse',
          'appwrite_id': '697d0fc1003193371a6a',
          'kind': 'arbeitsblatt',
        },
      ],
      'wochenAufgaben': [
        'Der Body-Scan bleibt zentral: In der Mediathek gibt es mehrere Längen — mehrmals pro Woche ist ein gutes Maß.',
        'Wähle eine alltägliche Tätigkeit und führe sie mit Anfängergeist aus, als würdest du sie zum ersten Mal tun — Zähneputzen, Duschen, der Weg zur Arbeit.',
        'Richte zwischendurch für einige Minuten die Aufmerksamkeit auf deinen Atem. Kein besonderer Ort nötig.',
        'Der Kalender der angenehmen Erlebnisse liegt in den Kursunterlagen — eine Gelegenheit, das Angenehme bewusster wahrzunehmen.',
      ],
      'readingSummary': '',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'w2-kino-gleichnis',
          'title': 'Zwei Arten, ganz bei etwas zu sein',
          'body':
              'Stell dir einen Film vor. Manchmal tauchst du so ein, dass du vergisst, überhaupt im Kino zu sitzen — alles ist Geschichte und Bild. Eine andere Qualität ist möglich: Du bist gefesselt vom Film, und doch ist im Hintergrund ein leises Gewahrsein da: Ich schaue zu.\n\n'
              'In der Achtsamkeitspraxis geht es oft um diese zweite Form: voll dabei und zugleich ein wenig Freiraum zum Beobachten. Das ist kein kühles Abwerten — sondern eine freundlichere Beziehung zu dem, was gerade passiert.',
        },
        {
          'id': 'w2-fa-om',
          'title': 'Fokus weit oder eng — beides ist Praxis',
          'body':
              'Zwei Grundformen der Übung begegnen dir in diesem Kurs: Bei der Aufmerksamkeit auf einen Anker — etwa den Atem — bleibt der Fokus wie ein Scheinwerfer auf einem Punkt. In offeneren Formen wird die Aufmerksamkeit weiter, eher wie eine weiche Flutlicht-Qualität: Was immer auftaucht, darf registriert werden.\n\n'
              'Beides zählt als Achtsamkeit. Mit der Zeit findest du heraus, welche Form dir wann guttut.',
        },
        {
          'id': 'w2-arbeitsgedaechtnis',
          'title': 'Aufmerksamkeit trainiert das Arbeitsgedächtnis',
          'body':
              'In einer großen Auswertung von über 50 Studien mit objektiven Tests zeigte sich: Achtsamkeitsprogramme verbessern das Arbeitsgedächtnis — also die Fähigkeit, Informationen im Kopf zu behalten und gleichzeitig damit zu arbeiten. Das ist die kognitive Domäne, in der die Ergebnisse am stabilsten sind.\n\n'
              'Der Effekt ist klein, aber konsistent. Und er verschwindet, wenn man gegen andere aktive Trainings vergleicht — Achtsamkeit ist also kein Gehirnjogging-Ersatz. Sie schärft etwas, das du ohnehin jeden Tag brauchst.',
        },
      ],
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
      'zitat':
          'Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor.',
      'zitatAutor': 'Thich Nhat Hanh',
      'alltagsTipp':
          'Spüre beim Gehen ganz bewusst den Kontakt deiner Füße zum Boden.',
      'reflexionsFragen': [
        'Wie gehst du mit deinen körperlichen Grenzen um?',
        'Welche angenehmen Momente hast du heute erlebt?',
      ],
      'audioRefs': [
        'Ankommen (Laura)',
        'Achtsamkeit in Bewegung',
        'Body-Scan standard',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 3',
          'appwrite_id': '69d6646600090d83a9fb',
          'kind': 'kursunterlage',
        },
        {
          'title':
              'Kalender der unangenehmen Erlebnisse (Vorbereitung für Woche 4)',
          'appwrite_id': '697d0fba00014e013bd4',
          'kind': 'arbeitsblatt',
        },
      ],
      'wochenAufgaben': [
        'Wechsle diese Woche zwischen Body-Scan und achtsamer Körperarbeit ab — beides findest du in der Mediathek.',
        'Beobachte zwischendurch im Alltag deinen Atem. Ein paar bewusste Atemzüge reichen.',
        'Der Kalender der unangenehmen Erlebnisse liegt in den Kursunterlagen bereit — er ist eine Vorbereitung auf das Thema der nächsten Woche.',
      ],
      'readingSummary': '',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'w3-atem-kontinuum',
          'title': 'Der Atem hat keinen Anfang und kein Ende',
          'body':
              'Wir denken den Atem oft als zwei getrennte Bewegungen: Einatmen, Ausatmen. Dazwischen — Pause. Tatsächlich gibt es keinen Punkt, an dem der Atem vollständig stillsteht. Die Einatmung geht fließend in die Ausatmung über, die Ausatmung in die nächste Einatmung. Wenn du genau hinschaust, ist der Atem eher eine fortlaufende Schleife als eine Linie mit Anfang und Ende.\n\n'
              'Das lässt sich nutzen: Statt die Aufmerksamkeit an einzelnen Momenten festzumachen — „jetzt Einatmen, jetzt Ausatmen“ — kannst du versuchen, die Übergänge mitzunehmen. Die Stelle, an der die Einatmung aufhört und die Ausatmung einsetzt. Die Stelle, an der die Ausatmung in eine kurze Stille mündet, bevor die nächste Einatmung beginnt. Diese Wendepunkte sind oft die Momente, in denen die Aufmerksamkeit abspringt — und genau deshalb sind sie wertvoll.',
        },
        {
          'id': 'w3-freundschaft-geist',
          'title': 'Freundschaft mit dem Geist statt Kampf',
          'body':
              'Viele starten mit dem Gefühl, „die Gedanken sollen endlich aufhören“. Der Kurs lädt zu einem anderen Verhältnis ein: Nicht gegen Ablenkung kämpfen, sondern bemerken, was da ist, und freundlich wieder zum Anker zurückgehen — oder die offene Haltung weiterführen.\n\n'
              'Leichtigkeit statt Anstrengung ist kein bequemer Trick, sondern oft der Weg, der länger tragfähig ist. Das passt zu Body-Scan und achtsamer Bewegung: Grenzen wahrnehmen statt sie zu überrennen.',
        },
        {
          'id': 'w3-essen',
          'title': 'Eine Mahlzeit — und wer alles daran beteiligt war',
          'body':
              'Eine einfache Übung für den Alltag: Halte vor dem Essen einen Moment inne. Nicht als Gebet, sondern als Wahrnehmung — wer hat dieses Essen angebaut, transportiert, zubereitet? Die Mahlzeit wird zum Anlass, Verbundenheit zu spüren, die sonst unsichtbar bleibt.\n\n'
              'Feste Zeitpunkte wie Mahlzeiten eignen sich gut als Anker für kurze achtsame Momente. Kein Extra-Zeitaufwand, keine Ausrüstung — nur die Bereitschaft, dreißig Sekunden wirklich da zu sein.',
        },
      ],
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
        'Ankommen (Laura)',
        'Sitzmeditation kurz',
        'Body-Scan standard',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 4',
          'appwrite_id': '69d6646c0029b95501da',
          'kind': 'kursunterlage',
        },
        {
          'title': 'Automatische Stressreaktion',
          'appwrite_id': '697d0fad0011caa23f03',
          'kind': 'arbeitsblatt',
        },
      ],
      'wochenAufgaben': [
        'Übe regelmäßig mit einer der Anleitungen aus der Mediathek — Body-Scan, Körperarbeit oder Sitzmeditation, je nachdem, was dich gerade anspricht.',
        'Beobachte zwischendurch deinen Atem im Alltag.',
        'In den Lesetexten findest du Impulse zum Thema Achtsamkeit am Arbeitsplatz.',
        'Wenn du magst, halte kurz fest, wann dir Stressreaktionen auffallen — im Körper, in Gedanken oder im Verhalten.',
      ],
      'readingSummary': '',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'w4-stresszeitskalen',
          'title': 'Stress ist nicht gleich Stress',
          'body':
              'Stressforscher unterscheiden Zeiträume: Sekunden oder Minuten (akuter Stress), belastende Ereignisse, alltägliche kleine Reibungen und dauerhafte Belastung über Wochen oder Jahre. Der Körper reagiert darauf unterschiedlich: Kurz und klar kann Stress mobilisieren; dauerhaft belastet er Nervensystem, Stimmung und Gesundheit.\n\n'
              'Für die Praxis heißt das: Manchmal brauchst du eine schnelle Regulation, manchmal eine tägliche Routine, manchmal soziale oder strukturelle Unterstützung. Ein Werkzeug ersetzt nicht das andere.',
        },
        {
          'id': 'w4-stress-gedaechtnis',
          'title': 'Stress und Lernen — ein feiner Unterschied',
          'body':
              'In einer neueren Zusammenschau zeigt sich: Leichter Stress kann kurzfristig Wachheit und Fokus unterstützen. Länger anhaltender, hoher Stress hingegen kann das Lernen und Erinnern erschweren — während emotional geprägte Erfahrungen intensiver wahrgenommen werden.\n\n'
              'Praktisch: In sehr stressigen Phasen ist weniger „Theorie im Kopf“ und mehr spürende Übung oft hilfreicher. Genau dafür gibt es Atem, Body-Scan und Bewegung.',
        },
        {
          'id': 'w4-grundversorgung',
          'title': 'Meditation als Grundversorgung, nicht als Extra',
          'body':
              'Aus der Hirnforschung kommt ein überraschendes Bild: Der angereicherte Laborkäfig mit Spielzeug und Platz ist nicht luxuriös — der Standardkäfig ist deprivierend. Übertragen auf uns: Meditation ist möglicherweise kein Wellness-Bonus, sondern stellt etwas wieder her, das unser Nervensystem braucht und im Alltag zu kurz kommt.\n\n'
              'Das heißt nicht, dass es ohne Übung geht. Meditation ist Grundversorgung und bewusste Kultivierung zugleich — beides.',
        },
      ],
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
        'Ankommen (Laura)',
        'Sitzmeditation mittel',
        'Body-Scan standard',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 5',
          'appwrite_id': '69d66473002cd88bf619',
          'kind': 'kursunterlage',
        },
        {
          'title':
              'Kalender der schwierigen Kommunikation (Vorbereitung für Woche 6)',
          'appwrite_id': '697d0f9a0021e3f24219',
          'kind': 'arbeitsblatt',
        },
      ],
      'wochenAufgaben': [
        'Die Sitzmeditation steht in der Mediathek bereit. Du kannst sie im Wechsel mit Body-Scan oder Körperarbeit nutzen.',
        'Beobachte in stressigen Momenten, welche Gedanken auftauchen — und was passiert, wenn du sie einfach wahrnimmst.',
        'Der Kalender der schwierigen Kommunikation liegt in den Kursunterlagen — er ist eine Vorbereitung auf das Thema der nächsten Woche.',
      ],
      'readingSummary': '',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'w5-tun-sein',
          'title': 'Vom Tun zum Sein — ohne Kampf gegen Gedanken',
          'body':
              'In offeneren Übungsformen geht es nicht darum, Gedanken zu stoppen. Wenn du merkst, dass du planst oder grübelst, reicht oft: freundlich bemerken — „Ah, der Geist ist beim Planen“ — und die Haltung weiterführen. Das Gehirn produziert Gedanken; sie alle unterdrücken zu wollen, macht die Praxis oft härter als nötig.\n\n'
              'So wird der Raum zwischen Reiz und Reaktion erfahrbar: nicht als Leistung, sondern als kleine Pause vor der nächsten Entscheidung.',
        },
        {
          'id': 'w5-gefuehle-beobachten',
          'title': 'Gefühle ansehen, bis sie sich leicht verschieben',
          'body':
              'Ein einfacher Impuls bei unangenehmen Gefühlen: weder wegdrücken noch dramatisieren, sondern neugierig bleiben. Manchmal verändert sich die Qualität ein wenig, wenn du wirklich da bleibst — ohne Bewertung, ohne Eile.\n\n'
              'Das ist keine Anweisung, alles allein auszuhalten. Wenn etwas zu viel wird, ist Pause, Bewegung oder Hilfe der richtige Weg.',
        },
        {
          'id': 'w5-decentering',
          'title': 'Abstand gewinnen, ohne kalt zu werden',
          'body':
              'In der Forschung taucht ein Begriff auf, der gut beschreibt, was in der Praxis passiert: Decentering. Gemeint ist die Fähigkeit, Gedanken und Gefühle zu beobachten, ohne sich mit ihnen zu verschmelzen. Du denkst nicht weniger — aber du erkennst: Das ist ein Gedanke, nicht die Wirklichkeit. Erinnerst du dich an das Kino-Gleichnis aus Woche 2? Decentering ist genau diese zweite Art zu schauen — gefesselt und doch gewahr, dass es ein Film ist.\n\n'
              'Studien zeigen, dass dieser Perspektivwechsel ein Schlüsselmechanismus sein kann, über den Achtsamkeitsprogramme wirken — etwa bei der Vorbeugung von Rückfällen in Depression.',
        },
        {
          'id': 'w5-stickiness',
          'title': 'Emotionale Klebrigkeit — wenn alte Erfahrungen mitreagieren',
          'body':
              'Manchmal reagierst du stärker, als die Situation eigentlich verlangt. Ein kleiner Kommentar trifft dich wie ein großer Vorwurf. Davidson nennt das „Stickiness“ — emotionale Klebrigkeit. Erfahrungen aus früheren Situationen kleben an dem, was gerade passiert, und trüben die Wahrnehmung.\n\n'
              'Achtsamkeit trainiert nicht, dass nichts mehr weh tut. Sie verändert, wie schnell du es bemerkst: Ah, da klebt etwas, das nicht hierhin gehört. Jede Übung, in der du das übst, reduziert die Klebrigkeit — nicht sofort, aber messbar über die Zeit.',
        },
        {
          'id': 'w5-stimulus-response',
          'title': 'Kurz raus aus Reiz und Reaktion',
          'body':
              'Jeden Tag kurz aus dem Kreislauf von Anforderung und Antwort heraustreten — nicht weil die aktive Welt schlecht ist, sondern weil du dich nur so selbst kennenlernen kannst. Wer regelmäßig innehält, reagiert danach oft klarer und weniger automatisch.\n\n'
              'Kein großer Rückzug nötig. Ein paar Minuten Stille, ein bewusster Atemzug vor einer Entscheidung — das reicht, um das Verhältnis von Signal und Rauschen im Kopf zu verbessern.',
        },
      ],
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
        'Ankommen (Laura)',
        'Sitzmeditation mittel',
        'Body-Scan standard',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 6',
          'appwrite_id': '69d664790037259099cd',
          'kind': 'kursunterlage',
        },
      ],
      'wochenAufgaben': [
        'Setze deine Meditationspraxis fort — wähle aus der Mediathek, was dich anspricht.',
        'Beobachte in einem Gespräch pro Tag, wie du zuhörst und was dabei in dir passiert.',
        'Nimm dir zwischendurch einen Moment, um bewusst wahrzunehmen, was deine Sinne gerade aufnehmen.',
      ],
      'readingSummary': '',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'w6-mitgefuehl',
          'title': 'Mitgefühl und Verhalten',
          'body':
              'In Studien zu kurzen Mitgefühls-Trainings zeigten sich messbare Veränderungen: In einem Verhaltensspiel verteilten Teilnehmende nach nur zwei Wochen Übung Geld großzügiger an Benachteiligte — nicht weil sie netter sein wollten, sondern weil sich ihre spontane Reaktion verschoben hatte. Das sind Laborbefunde, kein Automatismus im Alltag.\n\n'
              'Sie zeigen aber: Die „weichen“ Übungen haben eine nachvollziehbare Wirkung auf Innenwelt und Handeln — nicht nur auf den Fragebogen.',
        },
        {
          'id': 'w6-flourishing',
          'title': 'Wenn du aufblühst, wirkt das weiter',
          'body':
              'Innere Veränderung bleibt selten unsichtbar. Wenn du regelmäßig übst, berichten Teilnehmende häufig, dass sich ihr Umfeld mitverändert — nicht weil sie andere „reparieren“, sondern weil sie selbst anders reagieren: ruhiger, präsenter, weniger automatisch.\n\n'
              'Das ist kein Zaubermechanismus, sondern einfache Sozialpsychologie: Wer weniger im Autopiloten kommuniziert, verändert den Ton im Kontakt. Das gilt im Gespräch, im Beruf, in der Familie.',
        },
        {
          'id': 'w6-prosozial-luberto',
          'title': 'Prosoziales Verhalten messbar verändert?',
          'body':
              'Eine Meta-Analyse zu Meditation und prosozialem Verhalten fand über viele Studien hinweg kleine bis mittlere Effekte — sowohl in Fragebögen als auch in beobachtbaren Verhaltensmaßen (zum Beispiel Stuhl weitergeben, Spenden). Die stärksten Hinweise gibt es, wenn die Praxis ausdrücklich Mitgefühl oder liebevolle Güte trainiert — nicht bei jeder reinen Achtsamkeitsübung.\n\n'
              'Das passt zu dieser Woche: Kommunikation lebt auch von innerer Haltung.',
        },
      ],
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
      'zitat':
          'If your compassion does not include yourself, it is incomplete.',
      'zitatAutor': 'Jack Kornfield',
      'alltagsTipp': 'Tue heute bewusst etwas, das dir gut tut – nur für dich.',
      'reflexionsFragen': [
        'Was gibt dir Energie im Alltag?',
        'Wo verlierst du unnötig Kraft?',
        'Was nimmst du täglich auf (Medien, Gespräche, Termine) – und was davon nährt dich wirklich?',
      ],
      'audioRefs': [
        'Ankommen (Laura)',
        'Sitzmeditation lang',
        'Body-Scan standard',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 7',
          'appwrite_id': '69d664800021876d79b3',
          'kind': 'kursunterlage',
        },
      ],
      'wochenAufgaben': [
        'Probiere diese Woche, auch ohne Audioanleitung zu üben — in Stille, in deinem eigenen Rhythmus.',
        'Schau auf deine Woche: Was nährt dich, was zehrt an dir? Wo könntest du etwas Kleines verändern? Impulse zur Umgebungsgestaltung findest du in der Vertiefung unter „Gut zu wissen“.',
        'Beobachte im Alltag, wann du wahrnimmst und wann du bereits interpretierst.',
      ],
      'readingSummary': '',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'w7-freundlichkeit',
          'title': 'Freundlichkeit braucht Übung — wie Sprache',
          'body':
              'Qualitäten wie Güte oder Mitgefühl sind keine Luxus-Extras, die nur „spirituellen“ Menschen vorbehalten sind. Sie entwickeln sich in Beziehung und Übung — ähnlich wie Sprache: angeboren in der Anlage, aber ohne lebendigen Austausch verkümmert sie.\n\n'
              'Selbstfürsorge meint hier: diese Anlagen bewusst nähren, statt sie nur zu beanspruchen.',
        },
        {
          'id': 'w7-digitale-hygiene',
          'title': 'Achtsamkeit mit dem Smartphone',
          'body':
              'Viele Menschen greifen täglich dutzende Male zum Handy — oft unbewusst. Digitale Hygiene heißt nicht „alles weg“, sondern bewusste Grenzen: etwa handy-freie Zonen, feste Zeiten offline oder das Gerät sichtbar liegen lassen und trotzdem nicht greifen — als kleine Willensübung.\n\n'
              'Das Prinzip ist dasselbe wie in der Meditation: Nicht den Impuls bekämpfen, sondern ihn bemerken und bewusst entscheiden, ob du ihm folgst.',
        },
        {
          'id': 'w7-schlaf-mythos',
          'title': 'Meditation ersetzt keinen Schlaf',
          'body':
              'Eine häufige Frage: Kann Meditation Schlaf ersetzen? Die Antwort ist klar: Nein. Richard Davidson, einer der erfahrensten Meditationsforscher, berichtet, dass er deutlich länger schlief und sich spürbar besser fühlte, nachdem er den Wecker abgeschafft hatte — trotz Jahrzehnten täglicher Praxis.\n\n'
              'Meditation wirkt am besten, wenn du wach bist. Schläfrigkeit in der Übung ist kein Zeichen von Entspannung, sondern von Schlafmangel. Der beste Zeitpunkt zum Üben ist der, an dem du am klarsten bist.',
        },
      ],
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
      'zitat':
          'Am Ende dieses Kurses ist nicht das Ende der Praxis – es ist der Anfang.',
      'zitatAutor': 'Jon Kabat-Zinn',
      'alltagsTipp':
          'Erinnere dich heute an einen Moment aus dem Kurs, der dich besonders berührt hat.',
      'reflexionsFragen': [
        'Was nimmst du aus den 8 Wochen mit?',
        'Wie möchtest du Achtsamkeit weiter in dein Leben integrieren?',
      ],
      'audioRefs': [
        'Ankommen (Laura)',
        'Sitzmeditation lang',
        'Body-Scan standard',
        'Achtsamkeit in Bewegung',
      ],
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 8',
          'appwrite_id': '69d664860034bc621f93',
          'kind': 'kursunterlage',
        },
      ],
      'wochenAufgaben': [
        'Alle Übungen aus dem Kurs stehen dir weiterhin in der Mediathek zur Verfügung — auch stille Meditation ohne Anleitung.',
        'Schau zurück: Was hat sich in den letzten acht Wochen für dich verändert? In der Vertiefung unter „Gut zu wissen“ findest du einen Impuls dazu, wie Übung das Selbstbild prägen kann.',
        'Erstelle dir einen persönlichen Praxisplan — wann, welche Übung, wie lange. Auch eine Ausweichoption für stressige Wochen ist hilfreich. Impulse, wie du deine Umgebung praxisfreundlich gestaltest, findest du in der Vertiefung unter „Gut zu wissen“.',
        'Wenn du magst, nimm dir täglich einen Moment für Dankbarkeit — für etwas Konkretes, das dir an diesem Tag begegnet ist.',
      ],
      'readingSummary': '',
      'archiveEligible': true,
      'readingCards': [
        {
          'id': 'w8-vier-saeulen',
          'title': 'Vier Säulen des Wohlergehens',
          'body':
              'Der Neurowissenschaftler Richard Davidson ordnet Wohlbefinden in vier Bereiche: Gewahrsein (Awareness), Verbindung (Connection), Einsicht in innere Geschichten (Insight) und Sinn im Alltag (Purpose). Beim Rückblick auf den Kurs kannst du fragen: Wo habe ich Aufmerksamkeit geübt? Wo Verbindung? Wo Klarheit über meine Erzählungen? Wo etwas Sinnvolles im Kleinen?\n\n'
              'Nicht jede Übung passt in eine Schublade — aber das Modell zeigt, wie breit der Kurs dich begleitet hat.',
        },
        {
          'id': 'w8-konsistenz',
          'title': 'Dranbleiben schlägt Perfektion',
          'body':
              'Erfahrene Übende betonen selten die längste Session — sondern dass sie überhaupt wiederkommen. Ein paar Minuten heute und morgen nützen mehr als der Plan, „bald einmal eine Stunde“. Nach dem Kurs gilt: Dein Rhythmus darf sich an dein Leben anpassen; Strenge ist selten der beste Motivator.\n\n'
              'Die Mediathek und dein persönlicher Plan bleiben deine Verbündeten.',
        },
        {
          'id': 'w8-nicht-meditieren',
          'title': 'Unabgelenktes Nicht-Meditieren',
          'body':
              'Ein Zielbild aus der Meditationstradition klingt paradox: Die reifste Form der Praxis ist unabgelenktes Nicht-Meditieren — vollständig wach, vollständig gewahr, aber ohne Technik und ohne Anstrengung. Kein Objekt, kein Ziel, nur Dasein.\n\n'
              'Für den Alltag nach dem Kurs heißt das: Meditation muss nicht immer eine formelle Übung sein. Manchmal reicht es, ganz da zu sein — beim Spaziergang, beim Warten, beim Zuhören.',
        },
        {
          'id': 'w8-deklarativ-prozedural',
          'title': 'Wissen und Üben — beides zählt',
          'body':
              'Es gibt zwei Arten zu lernen: Wissen über etwas (deklarativ) und Können durch Tun (prozedural). Beide werden von unterschiedlichen Netzwerken im Gehirn getragen. Der Kurs bedient bewusst beide Seiten: Die Lesetexte liefern Orientierung, die tägliche Praxis verankert sie im Körper.\n\n'
              'Keines von beiden reicht allein. Wer nur liest, versteht — wer nur übt, spürt. Zusammen entsteht etwas Drittes: ein Verständnis, das über Worte hinausgeht.',
        },
        {
          'id': 'w8-verbundenheit',
          'title': 'Nichts davon gehört dir allein',
          'body':
              'Eine Übung aus der buddhistischen Tradition lädt dazu ein, bei einem Gegenstand — einer Blume, einer Mahlzeit, einem Atemzug — zu fragen: Was steckt darin, das nicht dieser Gegenstand selbst ist? In einer Blume stecken Boden, Regen, Sonnenlicht, die Arbeit eines Gärtners. Entfernt man eines dieser Elemente, gibt es die Blume nicht mehr.\n\n'
              'Das lässt sich auf die eigene Praxis übertragen. Die acht Wochen, die hinter dir liegen, sind nicht allein dein Verdienst. Die Gruppe hat dich getragen. Der Raum hat dich gehalten. Vielleicht hat jemand zu Hause dafür gesorgt, dass du die Zeit hattest. Die Forschenden, deren Arbeit in den Lesetexten steckt, haben Jahrzehnte investiert. Jon Kabat-Zinn hat MBSR in den Achtzigerjahren entwickelt, inspiriert von Traditionen, die Jahrtausende alt sind.\n\n'
              'Deine Praxis besteht aus lauter Nicht-Du-Elementen — und genau das macht sie stabil. Sie hängt nicht von einer einzigen Person oder einer perfekten Woche ab.',
        },
      ],
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
        'kind': 'kursunterlage',
      },
    ],
  };

  /// PDF-Kategorie: Sammelmappe / Wochen-PDF.
  static const String pdfKindKursunterlage = 'kursunterlage';

  /// PDF-Kategorie: einzelnes Übungs- oder Arbeitsblatt (max. eines pro Woche).
  static const String pdfKindArbeitsblatt = 'arbeitsblatt';

  /// Normalisiert Roh-Einträge aus [wochenDaten] zu einheitlichen String-Maps.
  static List<Map<String, String>> pdfMapsFromRaw(List<dynamic>? raw) {
    if (raw == null) return [];
    return raw
        .whereType<Map>()
        .map((m) => m.map((k, v) => MapEntry('$k', '${v ?? ''}')))
        .toList();
  }

  static String pdfKindOf(Map<String, String> pdf) {
    final k = pdf['kind']?.trim();
    if (k == pdfKindArbeitsblatt) return pdfKindArbeitsblatt;
    return pdfKindKursunterlage;
  }

  /// Gibt alle Audios aus der zentralen Mediathek zurück
  static List<Map<String, String>> getAlleAudios() {
    return mediathekAudios;
  }

  static const List<Map<String, String>> gutZuWissenKarten = [
    {
      'id': 'gzw-wirkung-zeit',
      'title': 'Wenn Wirkung auf sich warten lässt',
      'body':
          'Am Anfang fühlt sich Übung häufig unspektakulär an. Manche Tage wirken sogar unruhiger als vorher. Das ist kein Zeichen von Scheitern. Bei vielen Lern- und Veränderungsprozessen bleibt Fortschritt zunächst unter der Wahrnehmungsschwelle.\n\n'
          'Kleine, wiederholte Schritte können sich mit der Zeit summieren. Sichtbare Effekte entstehen oft erst nach einer Phase, in der „noch nichts passiert“ zu sein scheint. Dranbleiben ist in dieser Phase keine Härte gegen sich selbst, sondern eine realistische Strategie.\n\n'
          'Bei achtsamkeitsbasierten Programmen zeigt sich häufig ein moderater Zusammenhang zwischen regelmäßiger Übung und positiven Effekten. Veränderung verläuft dabei selten linear. Für heute reicht eine einfache Frage: Welche kleinste Übung ist realistisch, auch wenn sie sich noch nicht wirksam anfühlt?',
    },
    {
      'id': 'gzw-identitaet-praxis',
      'title': 'Übung prägt Selbstbild',
      'body':
          'Nachhaltige Veränderung entsteht oft stabiler, wenn sie nicht nur auf Ziele, sondern auch auf Selbstbild bezogen ist. Die Frage ist dann nicht nur: Was will ich erreichen?, sondern auch: Wie möchte ich mit mir umgehen?\n\n'
          'Jede kurze Praxis kann als kleiner Beleg gelten: Ich übe, auch wenn es nicht perfekt ist. Solche Erfahrungen stärken Selbstwirksamkeit. Das kann helfen, die Praxis nach dem Kurs in den Alltag zu integrieren.\n\n'
          'Forschung zu Selbstwirksamkeit und Motivation, die am Selbstbild ansetzt, zeigt, dass wiederholte Handlungserfahrung Verhalten und Selbstkonzept gegenseitig stabilisieren kann. Hilfreich ist ein schlichter Leitsatz, zum Beispiel: Ich bin jemand, der freundlich und regelmäßig übt.',
    },
    {
      'id': 'gzw-umgebung',
      'title': 'Umgebung als stiller Mittrainer',
      'body':
          'Willenskraft schwankt. Umgebung wirkt oft verlässlicher. Wenn die Bedingungen günstig sind, wird Übung wahrscheinlicher: ein fester Platz, klare Zeitfenster, weniger digitale Ablenkung.\n\n'
          'Es geht nicht um Perfektion. Schon kleine Anpassungen können Friktion senken: Was soll leicht werden? Was darf etwas schwerer werden? So entsteht eine alltagstaugliche Struktur für die Zeit nach dem Kurs.\n\n'
          'Verhaltenspsychologische Forschung zeigt konsistent, dass Kontextreize und Friktion beeinflussen, wie wahrscheinlich ein Verhalten tatsächlich ausgeführt wird. Für den Alltag reicht oft ein kleiner Schritt: Welche eine Veränderung in deiner Umgebung macht die nächste Übung heute leichter?',
    },
    {
      'id': 'gzw-cues-autopilot',
      'title': 'Der Autopilot hat Auslöser',
      'body':
          'Viele Handlungen im Alltag werden nicht durch bewusste Entscheidungen ausgelöst, sondern durch Kontextreize: eine bestimmte Uhrzeit, ein Ort, der Griff zum Handy nach dem Aufwachen. In der Verhaltenspsychologie heißen diese Auslöser Cues. In Woche 1 des Kurses hast du den Autopiloten kennengelernt: bemerken, was gerade geschieht. Cues sind die Außenperspektive auf denselben Mechanismus.\n\n'
          'Das eröffnet zwei Hebel: Achtsamkeit hilft, den Moment des Auslösers zu bemerken. Wer den Auslöser kennt, kann bewusst entscheiden, ob er ihm folgt, statt erst hinterher zu merken, was passiert ist.\n\n'
          'Wähle eine Gewohnheit, die du verändern möchtest, und beobachte drei Tage lang nur den Auslöser: Was passiert unmittelbar vorher?',
    },
    {
      'id': 'gzw-einstiegsschwelle',
      'title': 'Hinsitzen ist der schwerste Schritt',
      'body':
          'Die größte Hürde bei der täglichen Praxis ist selten die Übung selbst, sondern der Moment davor: sich hinsetzen, die App öffnen, den Entschluss fassen. Danach läuft es oft leichter. Verhaltensforschung zeigt: Je kleiner die Einstiegshürde, desto wahrscheinlicher wird das Verhalten wirklich ausgeführt.\n\n'
          'Für die Meditationspraxis heißt das: Nicht die Dauer ist zuerst entscheidend, sondern dass der Anfang leicht genug ist. Wer sich vornimmt, nur hinzusitzen und drei Atemzüge zu nehmen, sitzt oft länger als geplant. Wer sich dreißig Minuten vornimmt, schiebt den Beginn häufiger auf.\n\n'
          'Was wäre der kleinste denkbare Einstieg in deine heutige Übung?',
    },
    {
      'id': 'gzw-habit-stacking',
      'title': 'Eine Gewohnheit an die andere knüpfen',
      'body':
          'Eine bewährte Technik für neue Routinen: Die neue Handlung direkt an eine bestehende koppeln. Statt eines allgemeinen Vorsatzes hilft oft eine konkrete Verknüpfung: Nach dem Kaffeekochen setze ich mich drei Minuten hin. Die bestehende Gewohnheit wird zum Auslöser für die neue.\n\n'
          'Das Prinzip nutzt, was das Gehirn ohnehin tut: Handlungsketten bilden. Statt gegen die Automatik zu arbeiten, baust du die gewünschte Übung in eine bestehende Kette ein. Studien zeigen, dass solche konkreten Wenn-dann-Pläne die Wahrscheinlichkeit erhöhen, ein Vorhaben tatsächlich umzusetzen.\n\n'
          'Welche feste Alltagsroutine eignet sich bei dir als Anker für eine kurze Übung?',
    },
    {
      'id': 'gzw-rueckkopplungsschleife',
      'title': 'Sich schlecht fühlen, weil man sich schlecht fühlt',
      'body':
          'Manchmal entsteht das eigentliche Problem nicht durch ein Gefühl, sondern durch die Bewertung dieses Gefühls. Du bist unruhig in der Meditation und ärgerst dich dann über die Unruhe. Du merkst, dass du abgeschweift bist, und bewertest dich dafür. So entsteht eine Schleife: Das Gefühl wird zum Anlass für ein zweites, oft unangenehmeres Gefühl.\n\n'
          'Metakognitive Forschung zeigt, dass genau diese Schleife belastende Zustände aufrechterhalten kann. Der erste Schritt heraus ist oft einfach: Die Unruhe darf da sein, ohne dass sie sofort ein Problem sein muss.\n\n'
          'Wenn du das nächste Mal in der Übung merkst, dass du dich bewertest: Was passiert, wenn du die Bewertung einfach stehen lässt?',
    },
    {
      'id': 'gzw-verantwortung-schuld',
      'title': 'Verantwortung ist nicht Schuld',
      'body':
          'Zwei Begriffe, die oft vermischt werden: Schuld fragt rückwärts, wer etwas verursacht hat. Verantwortung fragt vorwärts, was ich jetzt damit tue. In stressigen Momenten verschwimmt dieser Unterschied leicht. Wer Verantwortung übernehmen will, rutscht schnell in Selbstvorwurf, obwohl beides nicht dasselbe ist.\n\n'
          'Forschung zur Kontrollüberzeugung legt nahe, dass Menschen Stress besser bewältigen, wenn sie Verantwortung für ihr Handeln übernehmen können, ohne sich dabei pauschal schuldig zu machen. Schuld fixiert auf das, was war. Verantwortung öffnet den Blick auf das, was jetzt möglich ist.\n\n'
          'In welcher aktuellen Situation verwechselst du vielleicht Verantwortung mit Schuld?',
    },
    {
      'id': 'gzw-abschluss-anerkennung',
      'title': 'Kurz anerkennen, was gerade war',
      'body':
          'Nach einer Übung passiert oft eines von zwei Dingen: Du springst direkt in den nächsten Tagesordnungspunkt oder du bewertest, ob die Übung gut genug war. Beides überspringt einen Moment, der für das Lernen wichtig ist. Unmittelbar nach einer Handlung entscheidet sich, wie stark die neue Verknüpfung wird.\n\n'
          'Gemeint ist kein Selbstlob und kein Urteil über die Qualität der Übung. Gemeint ist ein kurzes Innehalten: Ich habe mir diese Zeit genommen. Das reicht. Verhaltensforschung zeigt, dass so ein kurzer Moment der Anerkennung dazu beitragen kann, dass das Verhalten am nächsten Tag wahrscheinlicher wird.\n\n'
          'Was nimmst du in den drei Sekunden nach dem Ende einer Übung wahr, bevor der Alltag wieder einsetzt?',
    },
  ];

  static const List<Map<String, String>> zusatzUebungen = [];
}

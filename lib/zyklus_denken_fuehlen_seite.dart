import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class ZyklusDenkenFuehlenSeite extends StatefulWidget {
  const ZyklusDenkenFuehlenSeite({super.key});

  @override
  State<ZyklusDenkenFuehlenSeite> createState() =>
      _ZyklusDenkenFuehlenSeiteState();
}

class _ZyklusDenkenFuehlenSeiteState extends State<ZyklusDenkenFuehlenSeite> {
  static const String _reflectionStorageKey = 'modell_zyklus_reflection_v1';
  static const List<String> _steps = [
    'Situation',
    'Gefühl',
    'Gedanke',
    'Gefühl',
    'Gedanke',
  ];

  final TextEditingController _reflectionController = TextEditingController();
  Timer? _cycleTimer;
  Timer? _breathTimer;
  int _activeStep = 0;
  int _breathCount = 0;
  bool _running = false;
  String _statusText =
      'Der Zyklus startet, wenn du auf "Start Zyklus" klickst.';
  String _breathStatus = 'Bereit für den ersten Atemzug';
  bool _reflectionLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadReflectionDraft();
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _breathTimer?.cancel();
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          'Der Zyklus von Denken und Fühlen',
          style: AppStyles.headingStyle.copyWith(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppStyles.softBrown,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DecorativeBlobs(
        child: ListView(
          padding: AppStyles.listPadding,
          children: [
            _buildIntroCard(),
            AppStyles.spacingLBox,
            _buildCycleCard(),
            AppStyles.spacingMBox,
            _buildEvidenceHintCard(),
            AppStyles.spacingMBox,
            _buildExampleCard(),
            AppStyles.spacingMBox,
            _buildPracticeCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: AppStyles.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppStyles.accentOrange.withValues(alpha: 0.5),
          width: 1.4,
        ),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.model_training_outlined,
                color: AppStyles.accentOrange,
                size: 28,
              ),
              AppStyles.spacingMHorizontal,
              Expanded(
                child: Text(
                  'Bei Stress passiert oft automatisch: Gefühl -> Gedanke -> neues Gefühl. '
                  'Das ist normal. Hier übst du, den Kreislauf früher zu bemerken.',
                  style: AppStyles.bodyStyle.copyWith(
                    color: AppStyles.textDark,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCycleCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: Padding(
        padding: AppStyles.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Das Muster in kurz',
              style: AppStyles.subTitleStyle.copyWith(
                fontWeight: AppStyles.fontWeightSemiBold,
              ),
            ),
            AppStyles.spacingSBox,
            Text(
              'Situation -> Gefühl -> Gedanke -> Gefühl ...',
              style: AppStyles.smallTextStyle.copyWith(
                color: AppStyles.textMuted,
                height: 1.4,
              ),
            ),
            AppStyles.spacingSBox,
            Text(
              'Hinweis: Das ist eine Veranschaulichung. Du simulierst den Ablauf, um ihn im Alltag schneller zu erkennen.',
              style: AppStyles.smallTextStyle.copyWith(
                color: AppStyles.textMuted,
                height: 1.4,
              ),
            ),
            AppStyles.spacingMBox,
            Wrap(
              spacing: AppStyles.spacingS,
              runSpacing: AppStyles.spacingS,
              children: [
                for (var i = 0; i < _steps.length; i++) ...[
                  _CycleChip(
                    text: '${i + 1}. ${_steps[i]}',
                    active: _running && _activeStep == i,
                  ),
                  if (i < _steps.length - 1) const _ArrowChip(),
                ],
              ],
            ),
            AppStyles.spacingMBox,
            Text(
              _statusText,
              style: AppStyles.smallTextStyle.copyWith(
                color: AppStyles.textDark,
                height: 1.45,
              ),
            ),
            AppStyles.spacingMBox,
            Wrap(
              spacing: AppStyles.spacingS,
              runSpacing: AppStyles.spacingS,
              children: [
                FilledButton(
                  onPressed: _running ? null : _startCycle,
                  child: const Text('Simulation starten'),
                ),
                FilledButton.tonal(
                  onPressed: _running ? _noticeCycle : null,
                  child: const Text('Stopp: Hier bemerke ich es'),
                ),
                OutlinedButton(
                  onPressed: _resetCycle,
                  child: const Text('Zurücksetzen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceHintCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: Padding(
        padding: AppStyles.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warum das helfen kann',
              style: AppStyles.subTitleStyle.copyWith(
                fontWeight: AppStyles.fontWeightSemiBold,
              ),
            ),
            AppStyles.spacingSBox,
            Text(
              'Forschung zeigt: Achtsamkeitsübungen können Grübeln senken und helfen, '
              'Gedanken mehr als Gedanken zu sehen (weniger Verstrickung). '
              'Schon kurze Übungen im Alltag können spürbar entlasten.',
              style: AppStyles.bodyStyle.copyWith(
                color: AppStyles.textDark,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: Padding(
        padding: AppStyles.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beispiel',
              style: AppStyles.subTitleStyle.copyWith(
                fontWeight: AppStyles.fontWeightSemiBold,
              ),
            ),
            AppStyles.spacingSBox,
            Text(
              'Negative Bewertung bei der Arbeit -> Frustration -> '
              '"Ich bin nicht gut genug" -> Scham -> '
              '"Warum passiert mir das immer?"',
              style: AppStyles.bodyStyle.copyWith(
                color: AppStyles.textDark,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: Padding(
        padding: AppStyles.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kurzübung',
              style: AppStyles.subTitleStyle.copyWith(
                fontWeight: AppStyles.fontWeightSemiBold,
              ),
            ),
            AppStyles.spacingSBox,
            Text(
              '1) Pause\n'
              '2) Drei ruhige Atemzüge\n'
              '3) Benennen: "Da ist ein Gefühl, da ist ein Gedanke."\n\n'
              'So kannst du es im Alltag nutzen: Sobald du Grübeln bemerkst, '
              'kurz stoppen, atmen, benennen, dann bewusst weitergehen.',
              style: AppStyles.bodyStyle.copyWith(
                color: AppStyles.textDark,
                height: 1.55,
              ),
            ),
            AppStyles.spacingMBox,
            Container(
              width: double.infinity,
              padding: AppStyles.cardPaddingSmall,
              decoration: BoxDecoration(
                color: AppStyles.successGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppStyles.successGreen.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _breathStatus,
                    style: AppStyles.smallTextStyle.copyWith(
                      color: AppStyles.textDark,
                      fontWeight: AppStyles.fontWeightSemiBold,
                    ),
                  ),
                  AppStyles.spacingSBox,
                  FilledButton.tonal(
                    onPressed: _running || _breathCount >= 3 ? null : _runBreathStep,
                    child: Text(
                      _breathCount >= 3
                          ? 'Fertig'
                          : _breathCount == 0
                          ? 'Atemzug starten'
                          : 'Nächster Atemzug',
                    ),
                  ),
                ],
              ),
            ),
            if (_breathCount >= 3) ...[
              AppStyles.spacingMBox,
              Container(
                width: double.infinity,
                padding: AppStyles.cardPaddingSmall,
                decoration: BoxDecoration(
                  color: AppStyles.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppStyles.successGreen.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppStyles.successGreen,
                      size: 20,
                    ),
                    AppStyles.spacingSBox,
                    Expanded(
                      child: Text(
                        'Gut gemacht. Du hast den Zyklus unterbrochen. '
                        'Notiere jetzt in einem Satz, was du gerade bemerkst.',
                        style: AppStyles.smallTextStyle.copyWith(
                          color: AppStyles.textDark,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            AppStyles.spacingMBox,
            TextField(
              controller: _reflectionController,
              onChanged: (_) => _saveReflectionDraft(),
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Deinen letzten Zyklus nachzeichnen',
                hintText: 'Situation -> Gefühl -> Gedanke -> ...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                helperText: _reflectionLoaded
                    ? 'Wird lokal auf diesem Gerät gespeichert.'
                    : 'Lade gespeicherten Entwurf...',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startCycle() {
    _cycleTimer?.cancel();
    _breathTimer?.cancel();
    setState(() {
      _running = true;
      _activeStep = 0;
      _breathCount = 0;
      _breathStatus = 'Bereit für den ersten Atemzug';
      _statusText =
          'Die Simulation läuft. Schau nur zu: Was passiert als Nächstes?';
    });

    _cycleTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      if (!mounted) return;
      setState(() {
        _activeStep = (_activeStep + 1) % _steps.length;
      });
    });
  }

  void _noticeCycle() {
    _cycleTimer?.cancel();
    setState(() {
      _running = false;
      _statusText =
          'Gut. In echten Situationen wäre das der Moment für Pause und Atem.';
    });
  }

  void _resetCycle() {
    _cycleTimer?.cancel();
    _breathTimer?.cancel();
    setState(() {
      _running = false;
      _activeStep = 0;
      _breathCount = 0;
      _statusText =
          'Die Simulation startet, wenn du auf "Simulation starten" klickst.';
      _breathStatus = 'Bereit für den ersten Atemzug';
    });
  }

  void _runBreathStep() {
    if (_breathCount >= 3) return;

    final next = _breathCount + 1;
    setState(() {
      _breathStatus = 'Atemzug $next von 3 läuft... ruhig ein, langsam aus.';
    });

    _breathTimer?.cancel();
    _breathTimer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() {
        _breathCount = next;
        if (_breathCount < 3) {
          _breathStatus =
              'Gut. Atemzug ${_breathCount + 1} von 3 ist bereit.';
        } else {
          _breathStatus =
              'Drei Atemzüge abgeschlossen. Benenne jetzt Gefühl und Gedanken.';
        }
      });
    });
  }

  Future<void> _loadReflectionDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_reflectionStorageKey) ?? '';
    if (!mounted) return;
    setState(() {
      _reflectionController.text = saved;
      _reflectionLoaded = true;
    });
  }

  Future<void> _saveReflectionDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reflectionStorageKey, _reflectionController.text);
  }
}

class _CycleChip extends StatelessWidget {
  final String text;
  final bool active;

  const _CycleChip({required this.text, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? AppStyles.accentOrange.withValues(alpha: 0.22)
            : AppStyles.accentOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active
              ? AppStyles.accentOrange.withValues(alpha: 0.8)
              : AppStyles.accentOrange.withValues(alpha: 0.35),
          width: active ? 1.4 : 1,
        ),
      ),
      child: Text(
        text,
        style: AppStyles.smallTextStyle.copyWith(
          color: AppStyles.textDark,
          fontWeight: AppStyles.fontWeightSemiBold,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _ArrowChip extends StatelessWidget {
  const _ArrowChip();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Text(
        '→',
        style: AppStyles.bodyStyle.copyWith(
          color: AppStyles.textMuted,
          fontWeight: AppStyles.fontWeightSemiBold,
        ),
      ),
    );
  }
}

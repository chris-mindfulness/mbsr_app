/// Berechnet eine sichere Zielposition für relative Seek-Aktionen.
///
/// Regeln:
/// - nie kleiner als `0`
/// - bei bekannter Dauer nie größer als die Gesamtdauer
/// - bei unbekannter Dauer nur Untergrenze absichern
Duration resolveSeekTarget({
  required Duration current,
  required Duration offset,
  Duration? knownDuration,
}) {
  var target = current + offset;

  if (target < Duration.zero) {
    target = Duration.zero;
  }

  if (knownDuration != null &&
      knownDuration > Duration.zero &&
      target > knownDuration) {
    target = knownDuration;
  }

  return target;
}

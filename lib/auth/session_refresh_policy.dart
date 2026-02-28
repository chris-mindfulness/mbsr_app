/// Entscheidungshilfe für Session-Checks beim App-Start/Refresh.
///
/// Diese Logik ist absichtlich klein und rein funktional gehalten, damit
/// kritische Refresh-Fälle stabil per Unit-Test abgesichert werden können.
enum SessionRefreshDecision { useCachedUser, setLoggedOut, keepCurrentState }

SessionRefreshDecision resolveSessionRefreshDecision({
  required int? errorCode,
  required bool hasCachedUser,
}) {
  if (errorCode != 401) {
    return SessionRefreshDecision.keepCurrentState;
  }

  return hasCachedUser
      ? SessionRefreshDecision.useCachedUser
      : SessionRefreshDecision.setLoggedOut;
}

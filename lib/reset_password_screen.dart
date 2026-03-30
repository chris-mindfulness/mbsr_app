import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'auth/auth_route_refresh.dart';
import 'core/app_styles.dart';
import 'routing/app_router.dart';
import 'services/auth_service.dart';
import 'web_utils.dart';

/// Liest [userId] und [secret] aus der Appwrite-Redirect-URL (Query-Parameter).
class PasswordRecoveryParams {
  final String userId;
  final String secret;

  const PasswordRecoveryParams({
    required this.userId,
    required this.secret,
  });

  static PasswordRecoveryParams? fromCurrentUri() {
    final u = Uri.base;
    final merged = <String, String>{...u.queryParameters};

    final fragment = u.fragment;
    if (fragment.contains('?')) {
      final q = fragment.substring(fragment.indexOf('?') + 1);
      merged.addAll(Uri.splitQueryString(q));
    }

    String? pick(String a, String b) {
      final x = merged[a] ?? merged[b];
      if (x == null || x.isEmpty) return null;
      return x;
    }

    final userId = pick('userId', 'userid');
    final secret = pick('secret', 'Secret');
    if (userId == null || secret == null) return null;
    return PasswordRecoveryParams(userId: userId, secret: secret);
  }
}

/// Abschluss des Passwort-Resets (Link aus der E-Mail).
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _passwordVisible = false;
  bool _confirmVisible = false;
  bool _isLoading = false;
  bool _success = false;

  PasswordRecoveryParams? _params;

  @override
  void initState() {
    super.initState();
    _params = PasswordRecoveryParams.fromCurrentUri();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte gib ein neues Passwort ein.';
    }
    if (value.length < 8) {
      return 'Das Passwort sollte mindestens 8 Zeichen haben.';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value != _passwordController.text) {
      return 'Die Passwörter stimmen nicht überein.';
    }
    return _validatePassword(value);
  }

  String _toUiErrorMessage(Object error) {
    if (error is AuthException) return error.message;
    final raw = error.toString();
    if (raw.contains('XMLHttpRequest error') || raw.contains('Failed to fetch')) {
      return 'Verbindungsfehler. Bitte prüfe Internet und Appwrite.';
    }
    return 'Das neue Passwort konnte nicht gespeichert werden.';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final p = _params;
    if (p == null) return;

    setState(() => _isLoading = true);
    try {
      await AuthService().completePasswordRecovery(
        userId: p.userId,
        secret: p.secret,
        password: _passwordController.text,
      );
      if (mounted) setState(() => _success = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_toUiErrorMessage(e)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToLogin() {
    setRoute(AppRouter.login);
    AuthRouteRefresh.instance.bump();
  }

  @override
  Widget build(BuildContext context) {
    if (_success) {
      return Scaffold(
        backgroundColor: AppStyles.bgColor,
        appBar: AppBar(
          title: Text(
            'Passwort geändert',
            style: AppStyles.headingStyle.copyWith(fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: AppStyles.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppStyles.spacingXL),
              Icon(
                Icons.check_circle_outline,
                size: 72,
                color: AppStyles.sageGreen,
              ),
              SizedBox(height: AppStyles.spacingL),
              Text(
                'Dein Passwort wurde aktualisiert.',
                style: AppStyles.titleStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppStyles.spacingM),
              Text(
                'Du kannst dich jetzt mit der neuen Anmeldung einloggen.',
                style: AppStyles.bodyStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppStyles.spacingXL),
              ElevatedButton(
                onPressed: _goToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: AppStyles.spacingL - AppStyles.spacingS,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Zur Anmeldung',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final params = _params;
    if (params == null) {
      return Scaffold(
        backgroundColor: AppStyles.bgColor,
        appBar: AppBar(
          title: Text(
            'Passwort zurücksetzen',
            style: AppStyles.headingStyle.copyWith(fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: AppStyles.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppStyles.spacingXL),
              Icon(
                Icons.link_off_outlined,
                size: 64,
                color: AppStyles.primaryOrange.withValues(alpha: 0.7),
              ),
              SizedBox(height: AppStyles.spacingL),
              Text(
                'Dieser Link ist ungültig oder abgelaufen.',
                style: AppStyles.titleStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppStyles.spacingM),
              Text(
                kIsWeb
                    ? 'Bitte fordere unter „Passwort vergessen?“ eine neue E-Mail an und nutze den Link daraus.'
                    : 'Bitte öffne den Link aus der E-Mail in der Kurs-App im Browser.',
                style: AppStyles.bodyStyle,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _goToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: AppStyles.spacingL - AppStyles.spacingS,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Zur Anmeldung',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: AppStyles.spacingL),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          'Neues Passwort',
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
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              _goToLogin();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppStyles.spacingM),
              Icon(
                Icons.vpn_key_outlined,
                size: 64,
                color: AppStyles.primaryOrange,
              ),
              SizedBox(height: AppStyles.spacingL),
              Text(
                'Wähle ein neues Passwort',
                style: AppStyles.titleStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppStyles.spacingS),
              Text(
                'Der Link aus der E-Mail ist nur begrenzt gültig.',
                style: AppStyles.bodyStyle.copyWith(
                  color: AppStyles.softBrown.withValues(alpha: 0.75),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppStyles.spacingXL),
              _buildPasswordField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                label: 'Neues Passwort',
                visible: _passwordVisible,
                onToggleVisible: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
                validator: _validatePassword,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _confirmFocus.requestFocus(),
              ),
              SizedBox(height: AppStyles.spacingL - AppStyles.spacingS),
              _buildPasswordField(
                controller: _confirmController,
                focusNode: _confirmFocus,
                label: 'Passwort wiederholen',
                visible: _confirmVisible,
                onToggleVisible: () =>
                    setState(() => _confirmVisible = !_confirmVisible),
                validator: _validateConfirm,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              SizedBox(height: AppStyles.spacingXL),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: AppStyles.spacingL - AppStyles.spacingS,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Passwort speichern',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool visible,
    required VoidCallback onToggleVisible,
    required String? Function(String?) validator,
    void Function(String)? onSubmitted,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !visible,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      textInputAction: textInputAction,
      style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          Icons.lock_outlined,
          color: AppStyles.softBrown.withValues(alpha: 0.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            visible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onToggleVisible,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppStyles.spacingL,
          vertical: AppStyles.spacingL - AppStyles.spacingS,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppStyles.primaryOrange, width: 1.5),
        ),
      ),
    );
  }
}

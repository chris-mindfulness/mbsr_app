import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../legal_dialogs.dart';
import '../core/app_styles.dart';
import '../widgets/ambient_background.dart';
import '../widgets/branding_header.dart';

/// Landing Page mit Auswahl zwischen Stressprävention und MBSR Kursbereich
class MBSRHomePage extends StatelessWidget {
  const MBSRHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: AmbientBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppStyles.spacingXL + AppStyles.spacingS,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                const BrandingHeader(),
                SizedBox(height: AppStyles.spacingXL),
                Text(
                  'Willkommen bei deinem Training',
                  textAlign: TextAlign.center,
                  style: AppStyles.titleStyle.copyWith(fontSize: 22),
                ),
                AppStyles.spacingMBox,
                Text(
                  'Melde dich mit deinen persönlichen Zugangsdaten an.',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyStyle.copyWith(
                    fontSize: 15,
                    color: AppStyles.softBrown.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: AppStyles.spacingXL + AppStyles.spacingM),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.brandTeal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: AppStyles.spacingL + AppStyles.spacingXS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Zum Kursbereich',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: AppStyles.spacingXL - AppStyles.spacingS,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => LegalDialogs.showImpressum(context),
                          child: Text(
                            'Impressum',
                            style: AppStyles.bodyStyle.copyWith(
                              fontSize: 12,
                              color:
                                  AppStyles.softBrown.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                AppStyles.spacingM - AppStyles.spacingS,
                          ),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color:
                                  AppStyles.softBrown.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => LegalDialogs.showDatenschutz(context),
                          child: Text(
                            'Datenschutz',
                            style: AppStyles.bodyStyle.copyWith(
                              fontSize: 12,
                              color:
                                  AppStyles.softBrown.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

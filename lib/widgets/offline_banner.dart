import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

/// Einheitlicher Offline-Banner für Seiten mit Netzabhängigkeit.
class ConnectivityOfflineBanner extends StatelessWidget {
  final String message;
  final double horizontalMargin;
  final double verticalMargin;
  final double fontSize;

  const ConnectivityOfflineBanner({
    super.key,
    required this.message,
    this.horizontalMargin = 16,
    this.verticalMargin = 8,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityService.onlineStream,
      initialData: ConnectivityService.isOnline,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        if (isOnline) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 18, color: Colors.orange.shade800),
              const SizedBox(width: 8),
              Text(
                message,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange.shade900,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

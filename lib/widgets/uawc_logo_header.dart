import 'package:flutter/material.dart';
import '../config/app_config.dart';

class UawcLogoHeader extends StatelessWidget {
  const UawcLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/uawc_logo.png', height: 105),
        const SizedBox(height: 12),
        const Text(
          AppConfig.appName,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text(
          AppConfig.programName,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

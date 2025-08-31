import 'package:flutter/material.dart';
import 'package:lali/core/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppConfig.privacyUrl.isNotEmpty) {
      // Open external URL and show a simple page with instruction to go back
      final uri = Uri.parse(AppConfig.privacyUrl);
      // ignore: deprecated_member_use
      launchUrl(uri, mode: LaunchMode.externalApplication);
      return Scaffold(
        appBar: AppBar(title: const Text('Privacy Policy')),
        body: const Center(child: Text('Opening privacy policy...')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'This is a placeholder Privacy Policy. Replace with your actual policy.\n\n'
            'We collect analytics to improve the app, and use Firebase services. '
            'Users can request data export or deletion from Settings.',
          ),
        ),
      ),
    );
  }
}

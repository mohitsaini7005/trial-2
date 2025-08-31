import 'package:flutter/material.dart';
import 'package:lali/core/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppConfig.termsUrl.isNotEmpty) {
      final uri = Uri.parse(AppConfig.termsUrl);
      // ignore: deprecated_member_use
      launchUrl(uri, mode: LaunchMode.externalApplication);
      return Scaffold(
        appBar: AppBar(title: const Text('Terms of Service')),
        body: const Center(child: Text('Opening terms of service...')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'This is a placeholder Terms of Service. Replace with your actual terms.\n\n'
            'Use of this app is subject to your acceptance of these terms.',
          ),
        ),
      ),
    );
  }
}

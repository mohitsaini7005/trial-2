import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lali/core/services/region_prefs.dart';
import 'package:lali/data/seed/india_seed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lali/core/services/consent_prefs.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:lali/core/config/app_config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _country = 'IN';
  bool _analytics = true;
  bool _crash = true;

  final _locales = const [
    Locale('en', 'IN'),
    Locale('hi'),
    Locale('bn'),
    Locale('ta'),
    Locale('te'),
    Locale('mr'),
    Locale('kn'),
    Locale('en'),
  ];

  @override
  void initState() {
    super.initState();
    RegionPrefs.getCountry().then((value) => setState(() => _country = value));
    _loadConsent();
  }

  Future<void> _loadConsent() async {
    final a = await ConsentPrefs.getAnalytics();
    final c = await ConsentPrefs.getCrash();
    if (!mounted) return;
    setState(() {
      _analytics = a;
      _crash = c;
    });
  }

  void _pickLanguage() async {
    final rootContext = context;
    await showModalBottomSheet(
      context: rootContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('select_language'.tr(), style: Theme.of(rootContext).textTheme.titleMedium),
              ),
              ..._locales.map((loc) => ListTile(
                    leading: Icon(sheetContext.locale == loc ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                    title: Text(_localeLabel(loc)),
                    onTap: () async {
                      // Start locale change, then close the sheet immediately to avoid context after await
                      final change = sheetContext.setLocale(loc);
                      Navigator.pop(rootContext);
                      await change;
                      if (!mounted) return;
                      // Analytics + Crashlytics breadcrumbs
                      await FirebaseAnalytics.instance.logEvent(name: 'language_changed', parameters: {
                        'language': loc.languageCode,
                        'country': loc.countryCode ?? '',
                      });
                      FirebaseCrashlytics.instance.log('Language changed to ${loc.languageCode}_${loc.countryCode ?? ''}');
                      setState(() {});
                    },
                  )),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  String _localeLabel(Locale loc) {
    if (loc.languageCode == 'en' && loc.countryCode == 'IN') return 'English (India)';
    switch (loc.languageCode) {
      case 'hi':
        return 'हिन्दी';
      case 'bn':
        return 'বাংলা';
      case 'ta':
        return 'தமிழ்';
      case 'te':
        return 'తెలుగు';
      case 'mr':
        return 'मराठी';
      case 'kn':
        return 'ಕನ್ನಡ';
      default:
        return 'English';
    }
  }

  Future<void> _pickRegion() async {
    final rootContext = context;
    await showModalBottomSheet(
      context: rootContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('select_region'.tr(), style: Theme.of(rootContext).textTheme.titleMedium),
              ),
              ListTile(
                leading: Icon(_country == 'IN' ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                title: Text('india'.tr()),
                onTap: () async {
                  // Close the sheet first to avoid using context after await
                  Navigator.pop(rootContext);
                  await RegionPrefs.setCountry('IN');
                  if (!mounted) return;
                  // Analytics + Crashlytics breadcrumbs
                  await FirebaseAnalytics.instance.logEvent(name: 'region_changed', parameters: {
                    'country': 'IN',
                  });
                  FirebaseCrashlytics.instance.log('Region changed to IN');
                  setState(() => _country = 'IN');
                },
              ),
              ListTile(
                leading: Icon(_country == 'GLOBAL' ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                title: Text('global'.tr()),
                onTap: () async {
                  // Close the sheet first to avoid using context after await
                  Navigator.pop(rootContext);
                  await RegionPrefs.setCountry('GLOBAL');
                  if (!mounted) return;
                  // Analytics + Crashlytics breadcrumbs
                  await FirebaseAnalytics.instance.logEvent(name: 'region_changed', parameters: {
                    'country': 'GLOBAL',
                  });
                  FirebaseCrashlytics.instance.log('Region changed to GLOBAL');
                  setState(() => _country = 'GLOBAL');
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.language)),
              title: Text('language'.tr()),
              subtitle: Text(_localeLabel(context.locale)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickLanguage,
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.public)),
              title: Text('region'.tr()),
              subtitle: Text(_country == 'IN' ? 'india'.tr() : 'global'.tr()),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickRegion,
            ),
          ),
          // Temporary: Seed India content
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.cloud_upload)),
              title: const Text('Seed India content'),
              subtitle: const Text('One-time import to Firestore'),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                await SeedIndia.run();
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('Seed complete')),
                );
              },
            ),
          ),
          // Legal & Compliance
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const CircleAvatar(child: Icon(Icons.analytics_outlined)),
                  title: const Text('Analytics'),
                  subtitle: const Text('Help us improve via anonymous usage data'),
                  value: _analytics,
                  onChanged: (v) async {
                    setState(() => _analytics = v);
                    await ConsentPrefs.setAnalytics(v);
                    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(v);
                  },
                ),
                const Divider(height: 0),
                SwitchListTile(
                  secondary: const CircleAvatar(child: Icon(Icons.report_gmailerrorred_outlined)),
                  title: const Text('Crash reporting'),
                  subtitle: const Text('Send crash reports to fix issues faster'),
                  value: _crash,
                  onChanged: (v) async {
                    setState(() => _crash = v);
                    await ConsentPrefs.setCrash(v);
                    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(v);
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.privacy_tip_outlined)),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pushNamed('/privacy'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.description_outlined)),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pushNamed('/terms'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.mail_outline)),
                  title: const Text('Data request (export/delete)'),
                  subtitle: const Text('Email support with your request'),
                  onTap: () {
                    // Opens mail client
                    // Use centralized support email
                    const email = AppConfig.supportEmail;
                    final uri = Uri(
                      scheme: 'mailto',
                      path: email,
                      query: Uri.encodeFull('subject=Data Request&body=Please specify export or deletion.'),
                    );
                    // ignore: deprecated_member_use
                    launchUrl(uri);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

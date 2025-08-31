import 'package:shared_preferences/shared_preferences.dart';

class ConsentPrefs {
  static const _kAnalytics = 'consent_analytics';
  static const _kCrash = 'consent_crash';

  static Future<bool> getAnalytics() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kAnalytics) ?? true; // default opt-in for MVP; change if needed
  }

  static Future<bool> getCrash() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kCrash) ?? true;
  }

  static Future<void> setAnalytics(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kAnalytics, v);
  }

  static Future<void> setCrash(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kCrash, v);
  }
}

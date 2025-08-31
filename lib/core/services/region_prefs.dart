import 'package:shared_preferences/shared_preferences.dart';

class RegionPrefs {
  static const _keyCountry = 'country_code';

  static Future<String> getCountry() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_keyCountry) ?? 'IN';
  }

  static Future<void> setCountry(String code) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_keyCountry, code);
  }
}

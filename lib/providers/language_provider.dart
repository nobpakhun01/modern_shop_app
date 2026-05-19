import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  String _languageCode = 'th';

  String get languageCode {
    return _languageCode;
  }

  bool get isThai {
    return _languageCode == 'th';
  }

  bool get isEnglish {
    return _languageCode == 'en';
  }

  LanguageProvider() {
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString(_languageKey) ?? 'th';
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _languageCode = languageCode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);

    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    if (_languageCode == 'th') {
      await changeLanguage('en');
    } else {
      await changeLanguage('th');
    }
  }
}

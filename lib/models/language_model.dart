import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

class LanguageModel {
  final String name;
  final String code;
  final String countryCode;

  LanguageModel({
    required this.name,
    required this.code,
    required this.countryCode,
  });

  Widget get flag {
    try {
      return Flag.fromString(
        countryCode,
        height: 30,
        width: 40,
        fit: BoxFit.contain,
        replacement: Icon(Icons.flag, size: 30, color: Colors.white),
      );
    } catch (e) {
      return Container(
        height: 30,
        width: 40,
        color: Colors.grey,
        child: Icon(Icons.flag, size: 30, color: Colors.white),
      );
    }
  }





  static List<LanguageModel> getAllLanguages() {
    return [
      LanguageModel(
        name: "Français",
        code: "fr",
        countryCode: "FR",
      ),
      LanguageModel(
        name: "English (US)",
        code: "en_US",
        countryCode: "US",
      ),
      LanguageModel(
        name: "हिंदी",
        code: "hi",
        countryCode: "IN",
      ),
      LanguageModel(
        name: "Español",
        code: "es",
        countryCode: "ES",
      ),
      LanguageModel(
        name: "中文",
        code: "zh",
        countryCode: "CN",
      ),
      LanguageModel(
        name: "Português",
        code: "pt",
        countryCode: "PT",
      ),
      LanguageModel(
        name: "Русский",
        code: "ru",
        countryCode: "RU",
      ),
      LanguageModel(
        name: "Bahasa Indonesia",
        code: "in",
        countryCode: "ID",
      ),
      LanguageModel(
        name: "Filipino",
        code: "fil",
        countryCode: "PH",
      ),
      LanguageModel(
        name: "বাংলা",
        code: "bn",
        countryCode: "BD",
      ),
      LanguageModel(
        name: "Português (BR)",
        code: "pt_BR",
        countryCode: "BR",
      ),
      LanguageModel(
        name: "Afrikaans",
        code: "af",
        countryCode: "ZA",
      ),
      LanguageModel(
        name: "Deutsch",
        code: "de",
        countryCode: "DE",
      ),
      LanguageModel(
        name: "English (CA)",
        code: "en_CA",
        countryCode: "CA",
      ),
      LanguageModel(
        name: "English (UK)",
        code: "en_GB",
        countryCode: "GB",
      ),
      LanguageModel(
        name: "한국어",
        code: "ko",
        countryCode: "KR",
      ),
      LanguageModel(
        name: "Nederlands",
        code: "nl",
        countryCode: "NL",
      ),
    ];
  }

  Locale toLocale() {
    final parts = code.split('_');
    return parts.length > 1
        ? Locale(parts[0], parts[1])
        : Locale(code);
  }
}

import 'package:flutter/material.dart';

class LocalizationUtils {
  // static String getString(BuildContext context, String Function(AppLocalizations) accessor,
  //     {String defaultValue = ''}) {
  //   final localizations = AppLocalizations.of(context);
  //   return (localizations != null) ? accessor(localizations) : defaultValue;
  // }

  static String getDefaultName(BuildContext context) {
    if (isKorean(context)) {
      return "제목없음";
    } else {
      return "Untitled";
    }
  }

  static bool isKorean(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return locale.startsWith('ko');
  }

  static bool isEnglish(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return locale.startsWith('en');
  }
}

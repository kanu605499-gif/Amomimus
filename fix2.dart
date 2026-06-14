import 'dart:io';

void main() async {
  final file = File('lib/screens/welcome_form_screen.dart');
  String content = await file.readAsString();

  // Remove AboutPage
  final aboutPageRegex = RegExp(r'class AboutPage extends StatelessWidget \{.*?\n\}', dotAll: true);
  content = content.replaceAll(aboutPageRegex, '');
  
  // Replace language_manager import with preference_handler, and add about_screen/strings
  content = content.replaceFirst(
    "import '../language/language_manager.dart';",
    "import '../database/preference_handler.dart';\nimport 'package:amomimus/screens/about_screen.dart';\nimport 'package:amomimus/i18n/strings.g.dart';"
  );

  // Replace lang.getString('x') / context.read/watch
  final getStringRegex = RegExp(r"context\.watch<LanguageManager>\(\)\.getString\('([^']+)'\)");
  content = content.replaceAllMapped(getStringRegex, (match) {
    return 't.${match.group(1)}';
  });

  final getStringReadRegex = RegExp(r"context\.read<LanguageManager>\(\)\.getString\('([^']+)'\)");
  content = content.replaceAllMapped(getStringReadRegex, (match) {
    return 't.${match.group(1)}';
  });
  
  final getStringLangRegex = RegExp(r"lang\.getString\('([^']+)'\)");
  content = content.replaceAllMapped(getStringLangRegex, (match) {
    return 't.${match.group(1)}';
  });

  // Fix currentLanguageCode check
  content = content.replaceFirst(
    "final lang = context.read<LanguageManager>();\n    return lang.currentLanguageCode == 'EN'",
    "final String currentLang = LocaleSettings.currentLocale.languageTag;\n    return currentLang.startsWith('en')"
  );

  // Fix _pickDate
  content = content.replaceFirst(
    "Future<void> _pickDate(BuildContext context) async {\n    final lang = context.read<LanguageManager>();",
    "Future<void> _pickDate(BuildContext context) async {\n    final t = Translations.of(context);"
  );

  // Dropdown replacement
  content = content.replaceFirst(
    "value: context.watch<LanguageManager>().dropdownValue,",
    """value: () {
                            switch (LocaleSettings.currentLocale) {
                              case AppLocale.en: return 'English';
                              case AppLocale.ja: return '忍者';
                              case AppLocale.tm: return 'Tamriel';
                              case AppLocale.de: return 'Deutsch';
                              case AppLocale.th: return 'ภาษาไทย';
                              default: return 'Bahasa';
                            }
                          }(),"""
  );

  content = content.replaceFirst(
    "context.read<LanguageManager>().setLanguageFromDropdown(newValue);",
    """setState(() {
                                if (newValue == 'Bahasa') {
                                  LocaleSettings.setLocale(AppLocale.id);
                                  PreferenceHandler.setLanguage('id');
                                } else if (newValue == 'English') {
                                  LocaleSettings.setLocale(AppLocale.en);
                                  PreferenceHandler.setLanguage('en');
                                } else if (newValue == 'Deutsch') {
                                  LocaleSettings.setLocale(AppLocale.de);
                                  PreferenceHandler.setLanguage('de');
                                } else if (newValue == 'ภาษาไทย') {
                                  LocaleSettings.setLocale(AppLocale.th);
                                  PreferenceHandler.setLanguage('th');
                                } else if (newValue == '忍者') {
                                  LocaleSettings.setLocale(AppLocale.ja);
                                  PreferenceHandler.setLanguage('ja');
                                } else if (newValue == 'Tamriel') {
                                  LocaleSettings.setLocale(AppLocale.tm);
                                  PreferenceHandler.setLanguage('tm');
                                }
                              });"""
  );

  content = content.replaceFirst(
    "items: <String>['Bahasa', 'English', '忍者', 'Tamriel']",
    "items: <String>['Bahasa', 'Deutsch', 'English', 'ภาษาไทย', '忍者', 'Tamriel']"
  );
  
  // Add final t = Translations.of(context); inside build
  content = content.replaceFirst(
    "Widget build(BuildContext context) {", 
    "Widget build(BuildContext context) {\n    final t = Translations.of(context);"
  );
  
  await file.writeAsString(content);
  print('Fixed successfully');
}

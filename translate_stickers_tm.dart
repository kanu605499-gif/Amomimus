import 'dart:convert';
import 'dart:io';

void main() async {
  final translations = {
    'id.i18n.json': {
      'my_favorited_stickers': 'Stiker Favoritku',
      'no_favorited_stickers': 'Belum ada stiker favorit',
    },
    'en.i18n.json': {
      'my_favorited_stickers': 'My Favorited Stickers',
      'no_favorited_stickers': 'No favorited stickers',
    },
    'ja.i18n.json': {
      'my_favorited_stickers': 'お気に入りのステッカー',
      'no_favorited_stickers': 'お気に入りのステッカーはありません',
    },
    'th.i18n.json': {
      'my_favorited_stickers': 'สติกเกอร์ที่ฉันชื่นชอบ',
      'no_favorited_stickers': 'ไม่มีสติกเกอร์ที่ชื่นชอบ',
    },
    'de.i18n.json': {
      'my_favorited_stickers': 'Meine Lieblingssticker',
      'no_favorited_stickers': 'Keine Lieblingssticker',
    },
    'tm.i18n.json': {
      'my_favorited_stickers': 'My Treasured Runes',
      'no_favorited_stickers': 'Your satchel holds no treasured Runes.',
      // OVERWRITE PREVIOUS TAMIL MISTAKES WITH TAMRIEL LORE
      'send_email': 'Send Missive',
      'visit_instagram': 'Gaze upon Visage',
      'developer_role': 'Architect',
      'bug_report_success': 'Your report to the Guards has been sent.',
      'bug_report_fail_limit': 'The Guards ignore you. Weekly limit reached (3/week).',
      'bug_report_describe': 'Describe the anomaly in the realm.',
      'bug_report_wait': 'Tarry',
      'bug_category_ui': 'Illusion Glitch',
      'bug_category_crash': 'Realm Crash / Freeze',
      'bug_category_feature': 'Spell Fizzled',
      'bug_category_other': 'Other Chaos',
    },
  };

  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json') && !f.path.contains('_'));

  for (var file in files) {
    final name = file.path.split(Platform.pathSeparator).last;
    if (translations.containsKey(name)) {
      final content = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(content);
      
      jsonMap.addAll(translations[name]!);
      
      await file.writeAsString(json.encode(jsonMap));
      print('Updated translations in $name');
    }
  }
}

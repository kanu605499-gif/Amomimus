import 'dart:convert';
import 'dart:io';

void main() async {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (var file in files) {
    final content = await file.readAsString();
    final Map<String, dynamic> jsonMap = json.decode(content);

    // Only add if not exists
    if (!jsonMap.containsKey('my_favorited_stickers')) {
      // Determine language from filename
      final name = file.path.split(Platform.pathSeparator).last;
      if (name.contains('id.i18n.json')) {
        jsonMap['my_favorited_stickers'] = 'Stiker Favoritku';
        jsonMap['no_favorited_stickers'] = 'Kamu belum menandai stiker favorit apa pun.';
      } else if (name.contains('de.i18n.json')) {
        jsonMap['my_favorited_stickers'] = 'Meine Lieblingssticker';
        jsonMap['no_favorited_stickers'] = 'Du hast noch keine Sticker favorisiert.';
      } else if (name.contains('ja.i18n.json')) {
        jsonMap['my_favorited_stickers'] = 'お気に入りステッカー';
        jsonMap['no_favorited_stickers'] = 'お気に入りのステッカーはまだありません。';
      } else if (name.contains('th.i18n.json')) {
        jsonMap['my_favorited_stickers'] = 'สติกเกอร์ที่ฉันชื่นชอบ';
        jsonMap['no_favorited_stickers'] = 'คุณยังไม่มีสติกเกอร์ที่ชื่นชอบเลย';
      } else if (name.contains('tm.i18n.json')) {
        jsonMap['my_favorited_stickers'] = 'Halaýan stikerlerim';
        jsonMap['no_favorited_stickers'] = 'Entäk halaýan stikeriňiz ýok.';
      } else {
        // default english
        jsonMap['my_favorited_stickers'] = 'My Favorited Stickers';
        jsonMap['no_favorited_stickers'] = 'You haven\'t favorited any stickers yet.';
      }

      await file.writeAsString(json.encode(jsonMap));
      print('Added favorited sticker keys to ${file.path}');
    }
  }
}

import 'dart:io';
import 'dart:convert';

void main() async {
  final keys = {
    'id.i18n.json': {
      'my_favorited_stickers': 'Stiker Favorit',
      'no_favorited_stickers': 'Anda belum memiliki stiker favorit.',
      'send_email': 'Kirim Email',
      'visit_instagram': 'Kunjungi Instagram',
      'developer_role': 'Developer'
    },
    'de.i18n.json': {
      'my_favorited_stickers': 'Favorisierte Sticker',
      'no_favorited_stickers': 'Du hast noch keine favorisierten Sticker.',
      'send_email': 'E-Mail senden',
      'visit_instagram': 'Instagram besuchen',
      'developer_role': 'Entwickler'
    },
    'ja.i18n.json': {
      'my_favorited_stickers': 'お気に入りステッカー',
      'no_favorited_stickers': 'お気に入りのステッカーはまだありません。',
      'send_email': 'メールを送信',
      'visit_instagram': 'Instagramを見る',
      'developer_role': '開発者'
    },
    'th.i18n.json': {
      'my_favorited_stickers': 'สติกเกอร์ที่ชอบ',
      'no_favorited_stickers': 'คุณยังไม่มีสติกเกอร์ที่ชอบ',
      'send_email': 'ส่งอีเมล',
      'visit_instagram': 'ไปที่ Instagram',
      'developer_role': 'นักพัฒนา'
    },
    'tm.i18n.json': {
      'my_favorited_stickers': 'Cherished Seals',
      'no_favorited_stickers': 'Thou hast no cherished seals yet.',
      'send_email': 'Scribe Missive',
      'visit_instagram': 'Behold Vision',
      'developer_role': 'Architect'
    },
    'en.i18n.json': {
      'my_favorited_stickers': 'Favorited Stickers',
      'no_favorited_stickers': 'You have no favorited stickers yet.',
      'send_email': 'Send Email',
      'visit_instagram': 'Visit Instagram',
      'developer_role': 'Developer'
    }
  };

  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json') && !f.path.contains('_'));

  for (var file in files) {
    final name = file.path.split(Platform.pathSeparator).last;
    if (keys.containsKey(name)) {
      String content = await file.readAsString(encoding: utf8);
      // Remove trailing whitespace and the last closing brace
      content = content.trim();
      if (content.endsWith('}')) {
        content = content.substring(0, content.length - 1);
        
        // Append the new keys
        final newKeys = keys[name]!;
        StringBuffer sb = StringBuffer();
        sb.write(content);
        if (!content.endsWith(',')) {
          sb.write(',');
        }
        sb.writeln();
        
        int count = 0;
        for (var entry in newKeys.entries) {
          sb.write('  "${entry.key}": "${entry.value}"');
          count++;
          if (count < newKeys.length) {
            sb.write(',');
          }
          sb.writeln();
        }
        sb.writeln('}');
        
        await file.writeAsString(sb.toString(), encoding: utf8);
        print('Updated $name');
      }
    }
  }
}

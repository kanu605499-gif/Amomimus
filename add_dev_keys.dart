import 'dart:convert';
import 'dart:io';

void main() async {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (var file in files) {
    final content = await file.readAsString();
    final Map<String, dynamic> jsonMap = json.decode(content);

    if (!jsonMap.containsKey('send_email')) {
      final name = file.path.split(Platform.pathSeparator).last;
      if (name.contains('id.i18n.json')) {
        jsonMap['send_email'] = 'Kirim Email';
        jsonMap['visit_instagram'] = 'Kunjungi Instagram';
        jsonMap['developer_role'] = 'Developer';
      } else if (name.contains('de.i18n.json')) {
        jsonMap['send_email'] = 'E-Mail senden';
        jsonMap['visit_instagram'] = 'Instagram besuchen';
        jsonMap['developer_role'] = 'Entwickler';
      } else if (name.contains('ja.i18n.json')) {
        jsonMap['send_email'] = 'メールを送信';
        jsonMap['visit_instagram'] = 'Instagramを見る';
        jsonMap['developer_role'] = '開発者';
      } else if (name.contains('th.i18n.json')) {
        jsonMap['send_email'] = 'ส่งอีเมล';
        jsonMap['visit_instagram'] = 'ไปที่ Instagram';
        jsonMap['developer_role'] = 'นักพัฒนา';
      } else if (name.contains('tm.i18n.json')) {
        jsonMap['send_email'] = 'Scribe Missive';
        jsonMap['visit_instagram'] = 'Behold Vision';
        jsonMap['developer_role'] = 'Architect';
      } else {
        jsonMap['send_email'] = 'Send Email';
        jsonMap['visit_instagram'] = 'Visit Instagram';
        jsonMap['developer_role'] = 'Developer';
      }

      await file.writeAsString(json.encode(jsonMap));
      print('Added developer keys to ${file.path}');
    }
  }
}

import 'dart:convert';
import 'dart:io';

void main() async {
  final files = ['en', 'id', 'ja', 'th', 'tm', 'de'].map((e) => 'lib/i18n/$e.i18n.json');
  final map = {
    'en': 'sent you a message',
    'id': 'mengirimimu pesan',
    'ja': 'メッセージを送信しました',
    'th': 'ส่งข้อความถึงคุณ',
    'tm': 'sent a message to your rot',
    'de': 'hat dir eine Nachricht gesendet'
  };

  for (final file in files) {
    final f = File(file);
    if (f.existsSync()) {
      final lang = file.split('/').last.split('.').first;
      final content = await f.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      json['notif_chat'] = map[lang];
      await f.writeAsString(jsonEncode(json));
      print('Updated $file');
    }
  }
}

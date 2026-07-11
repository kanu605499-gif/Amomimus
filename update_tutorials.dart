import 'dart:convert';
import 'dart:io';

void main() async {
  final Map<String, Map<String, String>> updates = {
    'en': {
      'tutorial_2_desc': 'Long tap on the comment you want to reply to. There is no reply button, but long-tapping will trigger the reply and send a notification to the user.',
      'tutorial_5_desc': 'You can change the theme color by tapping the \'Amomimus\' typefont from the feed screen or the island chat inside the roomchat.'
    },
    'id': {
      'tutorial_2_desc': 'Tekan lama pada komentar yang ingin kamu balas. Tidak ada tombol balas, tetapi menekan lama akan memicu balasan dan mengirimkan notifikasi kepada pengguna tersebut.',
      'tutorial_5_desc': 'Kamu bisa mengubah warna tema dengan menekan tulisan \'Amomimus\' dari layar feed atau island chat di dalam roomchat.'
    },
    'th': {
      'tutorial_2_desc': 'แตะค้างที่ความคิดเห็นที่คุณต้องการตอบกลับ ไม่มีปุ่มตอบกลับ แต่การแตะค้างจะเรียกใช้การตอบกลับและส่งการแจ้งเตือนไปยังผู้ใช้',
      'tutorial_5_desc': 'คุณสามารถเปลี่ยนสีธีมได้โดยแตะที่แบบอักษร \'Amomimus\' จากหน้าฟีดหรือเกาะแชทในห้องแชท'
    },
    'ja': {
      'tutorial_2_desc': '返信したいコメントを長押しします。返信ボタンはありませんが、長押しすると返信がトリガーされ、ユーザーに通知が送信されます。',
      'tutorial_5_desc': 'フィード画面またはルームチャット内のアイランドチャットから「Amomimus」の文字をタップすることで、テーマカラーを変更できます。'
    },
    'de': {
      'tutorial_2_desc': 'Tippe lange auf den Kommentar, auf den du antworten möchtest. Es gibt keinen Antwort-Button, aber durch langes Tippen wird die Antwort ausgelöst und eine Benachrichtigung an den Benutzer gesendet.',
      'tutorial_5_desc': 'Du kannst die Themenfarbe ändern, indem du auf die Schriftart \'Amomimus\' auf dem Feed-Bildschirm oder im Insel-Chat innerhalb des Roomchats tippst.'
    },
    'tm': {
      'tutorial_2_desc': 'Long tap on the comment you want to reply to. There is no reply button, but long-tapping will trigger the reply and send a notification to the user.',
      'tutorial_5_desc': 'You can change the theme color by tapping the \'Amomimus\' typefont from the feed screen or the island chat inside the roomchat.'
    }
  };

  for (final entry in updates.entries) {
    final lang = entry.key;
    final file = File('lib/i18n/$lang.i18n.json');
    
    if (file.existsSync()) {
      var content = await file.readAsString();
      final Map<String, dynamic> jsonMap = jsonDecode(content);
      
      jsonMap['tutorial_2_desc'] = entry.value['tutorial_2_desc'];
      jsonMap['tutorial_5_desc'] = entry.value['tutorial_5_desc'];
      
      final encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(jsonMap));
      print('Updated $lang.i18n.json');
    } else {
      print('File not found: lib/i18n/$lang.i18n.json');
    }
  }
}

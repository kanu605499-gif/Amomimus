import 'dart:convert';
import 'dart:io';

void main() async {
  final feedMsgs = {
    "en": "Whoops! It seems our server is being a bit shy to your phone right now. Don't worry, your post is saved securely and we'll publish it ASAP when our server synchronized!",
    "id": "Waduh! Sepertinya server kita lagi malu-malu nih sama HP kamu. Jangan khawatir, postinganmu udah aman tersimpan dan bakal langsung diterbitkan pas server kita tersinkronisasi!",
    "ja": "おっと！今、私たちのサーバーがあなたのスマホに対して少し照れているようです。ご心配なく。投稿は安全に保存されており、サーバーが同期され次第、すぐに公開します！",
    "de": "Hoppla! Es scheint, dass unser Server im Moment ein wenig schüchtern gegenüber Ihrem Telefon ist. Keine Sorge, Ihr Beitrag ist sicher gespeichert und wir werden ihn so schnell wie möglich veröffentlichen, wenn unser Server synchronisiert ist!",
    "oe": "Hoppla! Es scheint, dass unser Server im Moment ein wenig schüchtern gegenüber Ihrem Telefon ist. Keine Sorge, Ihr Beitrag ist sicher gespeichert und wir werden ihn so schnell wie möglich veröffentlichen, wenn unser Server synchronisiert ist!",
    "th": "อุ๊ย! ดูเหมือนเซิร์ฟเวอร์ของเราจะเขินโทรศัพท์ของคุณนิดหน่อย ไม่ต้องกังวล โพสต์ของคุณถูกบันทึกไว้อย่างปลอดภัยแล้ว และเราจะเผยแพร่ให้เร็วที่สุดเมื่อเซิร์ฟเวอร์ซิงโครไนซ์แล้ว!",
    "tm": "Whoops! It seems our server is being a bit shy to your phone right now. Don't worry, your post is saved securely and we'll publish it ASAP when our server synchronized!"
  };

  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('i18n.json') && !f.path.contains('\$target'));

  for (var file in files) {
    final lang = file.path.split(Platform.pathSeparator).last.split('.').first;
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;
    
    data["delayed_sync_feed_msg"] = feedMsgs[lang] ?? feedMsgs["en"];
    data["delayed_sync_feed_title"] = lang == "id" ? "Postingan Tertunda" : "Delayed Post";
    
    await file.writeAsString(jsonEncode(data));
    print('Updated ${file.path}');
  }
}

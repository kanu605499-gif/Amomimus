import 'dart:io';
import 'dart:convert';

void main() async {
  final updates = {
    'en.i18n.json': 'Account successfully created. A verification link has been sent to your E-mail. Please check your email in spam category, to verify your account.',
    'id.i18n.json': 'Akun berhasil dibuat. Tautan verifikasi telah dikirim ke E-mail Anda. Silakan periksa email Anda di kategori spam, untuk memverifikasi akun Anda.',
    'ja.i18n.json': 'アカウントが正常に作成されました。確認リンクがメールに送信されました。アカウントを確認するには、迷惑メール（スパム）フォルダもご確認ください。',
    'th.i18n.json': 'สร้างบัญชีสำเร็จแล้ว ส่งลิงก์ยืนยันไปยังอีเมลของคุณแล้ว โปรดตรวจสอบอีเมลของคุณในหมวดหมู่สแปมเพื่อยืนยันบัญชีของคุณ',
    'de.i18n.json': 'Konto erfolgreich erstellt. Ein Bestätigungslink wurde an Ihre E-Mail gesendet. Bitte überprüfen Sie Ihre E-Mails im Spam-Ordner, um Ihr Konto zu verifizieren.',
    '[tamriel].i18n.json': 'Vessel forged. A binding scroll has been sent to your missives. Please check your forbidden missives (spam category), to bind your vessel.',
  };

  final dir = Directory('e:/Kanu Flutter/Amomimus/lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (final file in files) {
    final fileName = file.uri.pathSegments.last;
    if (updates.containsKey(fileName)) {
      String content = await file.readAsString();
      Map<String, dynamic> jsonMap = jsonDecode(content);
      if (jsonMap.containsKey('email_verification_sent_body')) {
        jsonMap['email_verification_sent_body'] = updates[fileName];
        // Pretty print json
        final encoder = JsonEncoder.withIndent('  ');
        await file.writeAsString(encoder.convert(jsonMap));
        print('Updated $fileName');
      }
    }
  }
}

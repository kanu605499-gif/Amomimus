import 'dart:convert';
import 'dart:io';

void main() async {
  final roomChatResetted = {
    "en": "You got a new message",
    "id": "Ada pesan baru",
    "ja": "新しいメッセージがあります",
    "de": "Sie haben eine neue Nachricht",
    "oe": "Sie haben eine neue Nachricht",
    "th": "คุณมีข้อความใหม่",
    "tm": "You got a new message"
  };

  final resendConfirmTitle = {
    "en": "Resend Confirmation",
    "id": "Konfirmasi Kirim Ulang",
    "ja": "再送信の確認",
    "de": "Bestätigung erneut senden",
    "oe": "Bestätigung erneut senden",
    "th": "ยืนยันการส่งอีกครั้ง",
    "tm": "Resend Confirmation"
  };

  final resendConfirmDesc = {
    "en": "Is your resend order correct? Messages will be sent sequentially.",
    "id": "Apakah urutan resend Anda sudah sesuai? Pesan akan dikirim secara sekuensial.",
    "ja": "再送信の順序は正しいですか？メッセージは順番に送信されます。",
    "de": "Ist Ihre Sendereihenfolge korrekt? Nachrichten werden nacheinander gesendet.",
    "oe": "Ist Ihre Sendereihenfolge korrekt? Nachrichten werden nacheinander gesendet.",
    "th": "ลำดับการส่งซ้ำของคุณถูกต้องหรือไม่? ข้อความจะถูกส่งตามลำดับ",
    "tm": "Is your resend order correct? Messages will be sent sequentially."
  };

  final deleteConfirmDesc = {
    "en": "Are you sure you want to delete this message?",
    "id": "Apakah Anda yakin ingin menghapus pesan ini?",
    "ja": "このメッセージを削除してもよろしいですか？",
    "de": "Möchten Sie diese Nachricht wirklich löschen?",
    "oe": "Möchten Sie diese Nachricht wirklich löschen?",
    "th": "แน่ใจหรือไม่ว่าต้องการลบข้อความนี้?",
    "tm": "Are you sure you want to delete this message?"
  };

  final cheatDetectedWarning = {
    "en": "You are suspected of manually changing your phone's system time. The chat room has been reset for security.",
    "id": "Anda terindikasi melakukan perubahan manual terhadap sistem jam HP Anda. Room chat telah di-reset untuk keamanan.",
    "ja": "携帯電話のシステム時間を手動で変更した疑いがあります。セキュリティのため、チャットルームはリセットされました。",
    "de": "Es wird vermutet, dass Sie die Systemzeit Ihres Telefons manuell geändert haben. Der Chatroom wurde aus Sicherheitsgründen zurückgesetzt.",
    "oe": "Es wird vermutet, dass Sie die Systemzeit Ihres Telefons manuell geändert haben. Der Chatroom wurde aus Sicherheitsgründen zurückgesetzt.",
    "th": "คุณถูกสงสัยว่าเปลี่ยนเวลาของระบบโทรศัพท์ด้วยตนเอง ห้องสนทนาถูกรีเซ็ตเพื่อความปลอดภัย",
    "tm": "You are suspected of manually changing your phone's system time. The chat room has been reset for security."
  };

  final cheatPartnerWarning = {
    "en": "Your partner is suspected of changing their system time.",
    "id": "Partner Anda terindikasi melakukan perubahan waktu sistem.",
    "ja": "パートナーがシステム時間を変更した疑いがあります。",
    "de": "Es wird vermutet, dass Ihr Partner seine Systemzeit geändert hat.",
    "oe": "Es wird vermutet, dass Ihr Partner seine Systemzeit geändert hat.",
    "th": "คู่สนทนาของคุณถูกสงสัยว่าเปลี่ยนเวลาของระบบ",
    "tm": "Your partner is suspected of changing their system time."
  };

  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('i18n.json') && !f.path.contains('\$target'));

  for (var file in files) {
    final lang = file.path.split(Platform.pathSeparator).last.split('.').first;
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;
    
    data["room_chat_resetted"] = roomChatResetted[lang] ?? roomChatResetted["en"];
    data["resend_confirm_title"] = resendConfirmTitle[lang] ?? resendConfirmTitle["en"];
    data["resend_confirm_desc"] = resendConfirmDesc[lang] ?? resendConfirmDesc["en"];
    data["delete_confirm_desc"] = deleteConfirmDesc[lang] ?? deleteConfirmDesc["en"];
    data["cheat_detected_warning"] = cheatDetectedWarning[lang] ?? cheatDetectedWarning["en"];
    data["cheat_partner_warning"] = cheatPartnerWarning[lang] ?? cheatPartnerWarning["en"];
    
    await file.writeAsString(jsonEncode(data));
    print('Updated \${file.path}');
  }
}

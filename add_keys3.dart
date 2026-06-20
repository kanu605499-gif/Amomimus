import 'dart:convert';
import 'dart:io';

void main() async {
  final resend = {
    "en": "Resend",
    "id": "Kirim Ulang",
    "ja": "再送信",
    "de": "Erneut senden",
    "oe": "Erneut senden",
    "th": "ส่งใหม่",
    "tm": "Resend"
  };

  final deleteSelected = {
    "en": "Delete Selected",
    "id": "Hapus Pilihan",
    "ja": "選択を削除",
    "de": "Auswahl löschen",
    "oe": "Auswahl löschen",
    "th": "ลบที่เลือก",
    "tm": "Delete Selected"
  };

  final failedToSend = {
    "en": "Failed to send",
    "id": "Gagal terkirim",
    "ja": "送信に失敗しました",
    "de": "Senden fehlgeschlagen",
    "oe": "Senden fehlgeschlagen",
    "th": "ส่งไม่สำเร็จ",
    "tm": "Failed to send"
  };

  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('i18n.json') && !f.path.contains('\$target'));

  for (var file in files) {
    final lang = file.path.split(Platform.pathSeparator).last.split('.').first;
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;
    
    data["resend"] = resend[lang] ?? resend["en"];
    data["delete_selected"] = deleteSelected[lang] ?? deleteSelected["en"];
    data["failed_to_send"] = failedToSend[lang] ?? failedToSend["en"];
    
    await file.writeAsString(jsonEncode(data));
    print('Updated ${file.path}');
  }
}

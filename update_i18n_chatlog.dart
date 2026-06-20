import 'dart:convert';
import 'dart:io';

void main() async {
  final Map<String, Map<String, String>> translations = {
    'en.i18n.json': {
      "chat_log_title": "Chat Log",
      "chat_log_empty": "No chat log yet.",
      "chat_log_system": "System",
      "chat_log_room_created": "Chat started",
      "chat_log_room_expired": "Countdown reset: Chat room cleared",
      "chat_log_delete_room": "{actor} deleted this chat room",
      "chat_log_pin": "{actor} pinned a message to Memories",
      "chat_log_unpin": "{actor} unpinned a message from Memories",
      "chat_log_erase": "{actor} permanently erased a message from Memories"
    },
    'id.i18n.json': {
      "chat_log_title": "Chat Log",
      "chat_log_empty": "Belum ada log chat.",
      "chat_log_system": "Sistem",
      "chat_log_room_created": "Obrolan dimulai",
      "chat_log_room_expired": "Countdown reset: Ruang obrolan telah dibersihkan",
      "chat_log_delete_room": "{actor} menghapus ruang obrolan ini",
      "chat_log_pin": "{actor} menyematkan pesan ke Memories",
      "chat_log_unpin": "{actor} melepas sematan pesan dari Memories",
      "chat_log_erase": "{actor} menghapus pesan dari Memories secara permanen"
    },
    'ja.i18n.json': {
      "chat_log_title": "Chat Log",
      "chat_log_empty": "チャットログはまだありません。",
      "chat_log_system": "システム",
      "chat_log_room_created": "チャットが開始されました",
      "chat_log_room_expired": "カウントダウンリセット：チャットルームがクリアされました",
      "chat_log_delete_room": "{actor}がこのチャットルームを削除しました",
      "chat_log_pin": "{actor}がメッセージをMemoriesにピン留めしました",
      "chat_log_unpin": "{actor}がMemoriesからメッセージのピン留めを解除しました",
      "chat_log_erase": "{actor}がMemoriesからメッセージを完全に消去しました"
    },
    'de.i18n.json': {
      "chat_log_title": "Chat Log",
      "chat_log_empty": "Noch kein Chat-Protokoll.",
      "chat_log_system": "System",
      "chat_log_room_created": "Chat gestartet",
      "chat_log_room_expired": "Countdown zurückgesetzt: Chatraum geleert",
      "chat_log_delete_room": "{actor} hat diesen Chatraum gelöscht",
      "chat_log_pin": "{actor} hat eine Nachricht an Memories angeheftet",
      "chat_log_unpin": "{actor} hat eine Nachricht von Memories losgelöst",
      "chat_log_erase": "{actor} hat eine Nachricht dauerhaft aus Memories gelöscht"
    },
    'th.i18n.json': {
      "chat_log_title": "Chat Log",
      "chat_log_empty": "ยังไม่มีบันทึกการแชท",
      "chat_log_system": "ระบบ",
      "chat_log_room_created": "เริ่มแชท",
      "chat_log_room_expired": "รีเซ็ตการนับถอยหลัง: ล้างห้องแชทแล้ว",
      "chat_log_delete_room": "{actor} ลบห้องแชทนี้",
      "chat_log_pin": "{actor} ปักหมุดข้อความไปยัง Memories",
      "chat_log_unpin": "{actor} เลิกปักหมุดข้อความจาก Memories",
      "chat_log_erase": "{actor} ลบข้อความออกจาก Memories อย่างถาวร"
    },
    'tm.i18n.json': {
      "chat_log_title": "Chat Log",
      "chat_log_empty": "Heniz çat logy ýok.",
      "chat_log_system": "Ulgam",
      "chat_log_room_created": "Çat başlady",
      "chat_log_room_expired": "Hasaplaýjy nol edildi: Çat otagy arassalandy",
      "chat_log_delete_room": "{actor} bu çat otagyny pozdy",
      "chat_log_pin": "{actor} habary Memories-e berkidi",
      "chat_log_unpin": "{actor} habary Memories-den aýyrdy",
      "chat_log_erase": "{actor} habary Memories-den hemişelik pozdy"
    }
  };

  for (final entry in translations.entries) {
    final file = File('lib/i18n/${entry.key}');
    if (file.existsSync()) {
      final content = await file.readAsString();
      final Map<String, dynamic> json = jsonDecode(content);
      
      json.addAll(entry.value);
      
      await file.writeAsString(jsonEncode(json));
    }
  }
  print('done');
}

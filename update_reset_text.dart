import 'dart:convert';
import 'dart:io';

void main() async {
  final Map<String, String> translations = {
    'en': 'The Roomchat Has Been Reset',
    'id': 'Roomchat Telah Di-reset',
    'ja': 'ルームチャットがリセットされました',
    'de': 'Der Roomchat wurde zurückgesetzt',
    'th': 'ห้องแชทถูกรีเซ็ตแล้ว',
    'tm': 'The Roomchat Has Been Reset',
    'oe': 'The Roomchat Has Been Reset',
  };

  final dir = Directory('lib/i18n');
  if (!dir.existsSync()) {
    print('Directory not found');
    return;
  }

  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (final file in files) {
    // Extract lang code from filename (e.g. en.i18n.json -> en, id.i18n.json -> id)
    final filename = file.uri.pathSegments.last;
    String langCode = filename.split('.').first;
    if (langCode == '[tamriel]') langCode = 'tm'; // Handle special case
    
    var content = await file.readAsString();
    final Map<String, dynamic> jsonMap = jsonDecode(content);
    
    // Default to English if language not specifically translated
    final text = translations[langCode] ?? 'The Roomchat Has Been Reset';
    
    jsonMap['room_chat_resetted'] = text;
    
    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(jsonMap));
    print('Updated $filename with: $text');
  }
}

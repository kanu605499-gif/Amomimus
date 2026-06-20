import 'dart:convert';
import 'dart:io';

void main() async {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (var file in files) {
    final content = await file.readAsString();
    final Map<String, dynamic> jsonMap = json.decode(content);

    // Only add if not exists
    if (!jsonMap.containsKey('copy')) {
      // Determine language from filename
      final name = file.path.split(Platform.pathSeparator).last;
      if (name.contains('id.json')) {
        jsonMap['copy'] = 'Salin';
        jsonMap['copied_to_clipboard'] = 'Disalin ke papan klip';
      } else if (name.contains('de.json')) {
        jsonMap['copy'] = 'Kopieren';
        jsonMap['copied_to_clipboard'] = 'In die Zwischenablage kopiert';
      } else if (name.contains('ja.json')) {
        jsonMap['copy'] = 'コピー';
        jsonMap['copied_to_clipboard'] = 'クリップボードにコピーしました';
      } else if (name.contains('ko.json')) {
        jsonMap['copy'] = '복사';
        jsonMap['copied_to_clipboard'] = '클립보드에 복사됨';
      } else if (name.contains('th.json')) {
        jsonMap['copy'] = 'คัดลอก';
        jsonMap['copied_to_clipboard'] = 'คัดลอกไปยังคลิปบอร์ดแล้ว';
      } else if (name.contains('zh.json')) {
        jsonMap['copy'] = '复制';
        jsonMap['copied_to_clipboard'] = '已复制到剪贴板';
      } else {
        // default english
        jsonMap['copy'] = 'Copy';
        jsonMap['copied_to_clipboard'] = 'Copied to clipboard';
      }

      await file.writeAsString(json.encode(jsonMap));
      print('Added copy keys to ${file.path}');
    }
  }
}

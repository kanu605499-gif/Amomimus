import 'dart:io';
import 'dart:convert';

void main() {
  final files = [
    'lib/i18n/ja.i18n.json',
    'lib/i18n/th.i18n.json'
  ];

  for (var path in files) {
    try {
      final text = File(path).readAsStringSync();
      final bytes = latin1.encode(text);
      final fixedText = utf8.decode(bytes);
      File(path).writeAsStringSync(fixedText);
      print('Fixed ' + path);
    } catch (e) {
      print('Failed to fix ' + path + ': ' + e.toString());
    }
  }
}

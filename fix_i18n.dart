import 'dart:convert';
import 'dart:io';

void main() async {
  final files = ['en.i18n.json', 'id.i18n.json', 'de.i18n.json', 'ja.i18n.json', 'th.i18n.json', 'tm.i18n.json'];
  
  for (final filename in files) {
    final file = File('lib/i18n/$filename');
    if (file.existsSync()) {
      var content = await file.readAsString();
      
      // Remove all dollar signs before {actor}
      content = content.replaceAll(RegExp(r'\$+\{actor\}'), '{actor}');
      
      // Now it's guaranteed to be just {actor}. Replace it with ${actor} so slang detects it
      // Note: we want the literal string "${actor}" in JSON, so we use '\${actor}' in dart
      content = content.replaceAll('{actor}', '\${actor}');
      
      await file.writeAsString(content);
      print('Fixed $filename');
    }
  }
}

import 'dart:io';
import 'dart:convert';

void main() {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().where((f) => f.path.endsWith('.i18n.json'));

  for (var file in files) {
    if (file is File) {
      String content = file.readAsStringSync(encoding: utf8);
      if (content.contains('â€”')) {
        content = content.replaceAll('â€”', '—'); // replace with em-dash
        file.writeAsStringSync(content, encoding: utf8);
        print('Fixed encoding in \${file.path}');
      }
    }
  }
}

import 'dart:io';

void main() {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
  for (final file in files) {
    var data = file.readAsStringSync();
    data = data.replaceAll('{count}', r'\');
    data = data.replaceAll('{tier}', r'\');
    data = data.replaceAll('{duration}', r'\');
    data = data.replaceAll('{actor}', r'\');
    file.writeAsStringSync(data);
  }
}

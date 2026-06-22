import 'dart:io';

void main() {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
  for (final file in files) {
    var data = file.readAsStringSync();
    data = data.replaceAll('{count}', r'${count}');
    data = data.replaceAll('{tier}', r'${tier}');
    data = data.replaceAll('{duration}', r'${duration}');
    data = data.replaceAll('{actor}', r'${actor}');
    file.writeAsStringSync(data);
  }
  print('Fixed JSON strings successfully.');
}

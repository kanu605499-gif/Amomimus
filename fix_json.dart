import 'dart:io';

void main() {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
  for (final file in files) {
    var data = file.readAsStringSync();
    data = data.replaceAll(r'\${count}', r'${count}');
    data = data.replaceAll(r'\${tier}', r'${tier}');
    data = data.replaceAll(r'\${duration}', r'${duration}');
    data = data.replaceAll(r'\${actor}', r'${actor}');
    file.writeAsStringSync(data);
  }
}

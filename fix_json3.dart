import 'dart:io';

void main() {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
  for (final file in files) {
    var data = file.readAsStringSync();
    data = data.replaceAll(r'$${actor}', r'${actor}');
    file.writeAsStringSync(data);
  }
  print('Fixed JSON actor successfully.');
}

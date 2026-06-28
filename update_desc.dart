import 'dart:convert';
import 'dart:io';

void main() {
  final files = {
    'id.i18n.json': 'Anda belum memilih',
    'en.i18n.json': 'You haven\'t selected an',
    'th.i18n.json': '?????????????????',
    'ja.i18n.json': '??????????:',
    'de.i18n.json': 'Sie haben noch keinen ausgewählt:',
    'tm.i18n.json': 'You haven\'t selected an'
  };

  final baseDir = 'lib/i18n';

  files.forEach((filename, newText) {
    final file = File('\/\');
    if (file.existsSync()) {
      final jsonString = file.readAsStringSync();
      final Map<String, dynamic> data = jsonDecode(jsonString);
      
      data['incomplete_selection_desc_1'] = newText;
      
      final encoder = JsonEncoder.withIndent('    ');
      file.writeAsStringSync(encoder.convert(data));
      print('Updated \');
    }
  });
}

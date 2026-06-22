import 'dart:convert';
import 'dart:io';

void main() async {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (final file in files) {
    if (file.path.contains('en.i18n.json') || file.path.contains('id.i18n.json')) {
      continue;
    }

    print('Processing ${file.path}');
    String content = await file.readAsString();
    Map<String, dynamic> jsonMap = json.decode(content);

    // Update bio_bailout_confirm to include ${duration}
    if (jsonMap.containsKey('bio_bailout_confirm')) {
      String currentText = jsonMap['bio_bailout_confirm'];
      if (!currentText.contains('\${duration}')) {
        jsonMap['bio_bailout_confirm'] = '\${duration} - ' + currentText;
      }
    }

    // Add bio_first_time_confirm if missing
    if (!jsonMap.containsKey('bio_first_time_confirm')) {
      jsonMap['bio_first_time_confirm'] = '\${duration} - Please confirm your bio.';
    }

    String newContent = json.encode(jsonMap);
    await file.writeAsString(newContent);
    print('Updated ${file.path}');
  }
}

import 'dart:io';

void main() async {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (final file in files) {
    if (file.path.contains('en.i18n.json') || file.path.contains('id.i18n.json')) {
      continue;
    }

    String content = await file.readAsString();
    
    // Fix the broken ${count
    content = content.replaceAll(
      '\${count,"bio_first_time_confirm":"\${duration} - Please confirm your bio."}',
      '\${count}'
    );
    content = content.replaceAll(
      '\${tier,"bio_first_time_confirm":"\${duration} - Please confirm your bio."}',
      '\${tier}'
    );

    // Make sure we remove any other accidental additions
    content = content.replaceAll(',"bio_first_time_confirm":"\${duration} - Please confirm your bio."}', '}');

    // Add it properly to the very end of the file
    if (!content.contains('"bio_first_time_confirm"')) {
        int lastBrace = content.lastIndexOf('}');
        if (lastBrace != -1) {
            content = content.substring(0, lastBrace) + ',"bio_first_time_confirm":"\${duration} - Please confirm your bio."}';
        }
    }

    await file.writeAsString(content);
  }
}

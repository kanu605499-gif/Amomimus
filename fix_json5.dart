import 'dart:io';

void main() async {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (final file in files) {
    if (file.path.contains('en.i18n.json') || file.path.contains('id.i18n.json')) {
      continue;
    }

    String content = await file.readAsString();
    
    if (content.contains('"bio_bailout_confirm":"') && !content.contains('\${duration}')) {
        content = content.replaceAll(
          '"bio_bailout_confirm":"',
          '"bio_bailout_confirm":"\${duration} - '
        );
    }
    
    if (!content.contains('"bio_first_time_confirm"')) {
        content = content.replaceFirst('}', ',"bio_first_time_confirm":"\${duration} - Please confirm your bio."}');
    }

    await file.writeAsString(content);
  }
}

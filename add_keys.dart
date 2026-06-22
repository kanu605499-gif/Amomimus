import 'dart:convert';
import 'dart:io';

void main() async {
  final switchEmailMsgs = {
    "en": "Switch Email",
    "id": "Ganti Email",
    "ja": "メールを切り替え",
    "de": "E-Mail wechseln",
    "oe": "E-Mail wechseln",
    "th": "สลับอีเมล",
    "tm": "Change Scroll"
  };

  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('i18n.json') && !f.path.contains('\$target'));

  for (var file in files) {
    final lang = file.path.split(Platform.pathSeparator).last.split('.').first;
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;
    
    data["switch_email"] = switchEmailMsgs[lang] ?? switchEmailMsgs["en"];
    
    // We also use an encoder with indentation for pretty-printing
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(data));
    print('Updated ${file.path}');
  }
}

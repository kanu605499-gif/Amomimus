import 'dart:convert';
import 'dart:io';

void main() async {
  final englishTitles = {
    'tutorial_1_title': 'How to Chat',
    'tutorial_2_title': 'How to Reply Comments',
    'tutorial_3_title': 'Redeem & Use Coins',
    'tutorial_4_title': 'Countdown System',
    'tutorial_5_title': 'Changing Theme Colors',
    'tutorial_6_title': 'Block & Unblock Actions',
    'tutorial_7_title': 'Ghost & Noise Indicators'
  };

  final dir = Directory('lib/i18n');
  if (!dir.existsSync()) {
    print('Directory not found');
    return;
  }

  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  for (final file in files) {
    if (file.path.endsWith('en.i18n.json')) continue; // Skip EN as it's the source
    
    var content = await file.readAsString();
    final Map<String, dynamic> jsonMap = jsonDecode(content);
    
    for (final entry in englishTitles.entries) {
      if (jsonMap.containsKey(entry.key) || true) {
        jsonMap[entry.key] = entry.value;
      }
    }
    
    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(jsonMap));
    print('Updated ${file.path}');
  }
}

import 'dart:convert';
import 'dart:io';

void main() async {
  final Map<String, String> translations = {
    'en': 'Reloading Some Whispers...',
    'id': 'Memuat Ulang Beberapa Bisikan...',
    'de': 'Einige Flüstern Werden Neu Geladen...',
    'ja': 'いくつかのささやきを再読み込み中...',
    'th': 'กำลังโหลดเสียงกระซิบใหม่...',
    'tm': 'Käbir Pyşyrdylary Täzeden Ýüklenýär...'
  };

  for (final entry in translations.entries) {
    final lang = entry.key;
    final text = entry.value;
    final file = File('lib/i18n/$lang.i18n.json');
    
    if (file.existsSync()) {
      var content = await file.readAsString();
      final Map<String, dynamic> jsonMap = jsonDecode(content);
      jsonMap['reloading_whispers'] = text;
      
      await file.writeAsString(jsonEncode(jsonMap));
      print('Updated $lang to Title Case');
    }
  }
}

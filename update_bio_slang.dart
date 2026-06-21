import 'dart:convert';
import 'dart:io';

void main() {
  final keys = {
    'en': {
      'bio_duration_3': '3D',
      'bio_duration_5': '5D',
      'bio_duration_7': '7D',
      'bio_duration_15': '15D',
      'bio_duration_30': '30D',
      'bio_bailout': 'Bailout (1 Try Only)',
      'bio_not_enough_coins': 'Not enough coins.',
      'bio_locked': 'Locked',
      'bio_bailout_used': 'Bailout used.'
    },
    'id': {
      'bio_duration_3': '3H',
      'bio_duration_5': '5H',
      'bio_duration_7': '7H',
      'bio_duration_15': '15H',
      'bio_duration_30': '30H',
      'bio_bailout': 'Bailout (1x Coba)',
      'bio_not_enough_coins': 'Koin tidak cukup.',
      'bio_locked': 'Terkunci',
      'bio_bailout_used': 'Bailout terpakai.'
    },
    'th': {
      'bio_duration_3': '3ว',
      'bio_duration_5': '5ว',
      'bio_duration_7': '7ว',
      'bio_duration_15': '15ว',
      'bio_duration_30': '30ว',
      'bio_bailout': 'Bailout (1 ครั้งเท่านั้น)',
      'bio_not_enough_coins': 'เหรียญไม่พอ',
      'bio_locked': 'ล็อค',
      'bio_bailout_used': 'ใช้ Bailout แล้ว'
    },
    'tm': {
      'bio_duration_3': '3R',
      'bio_duration_5': '5R',
      'bio_duration_7': '7R',
      'bio_duration_15': '15R',
      'bio_duration_30': '30R',
      'bio_bailout': 'Bailout (1 Attempt)',
      'bio_not_enough_coins': 'Not enough Septims.',
      'bio_locked': 'Bound',
      'bio_bailout_used': 'Bailout exhausted.'
    },
    'ja': {
      'bio_duration_3': '3日',
      'bio_duration_5': '5日',
      'bio_duration_7': '7日',
      'bio_duration_15': '15日',
      'bio_duration_30': '30日',
      'bio_bailout': '脱出 (1回のみ)',
      'bio_not_enough_coins': 'コインが足りません',
      'bio_locked': 'ロック中',
      'bio_bailout_used': '脱出済み'
    },
    'de': {
      'bio_duration_3': '3T',
      'bio_duration_5': '5T',
      'bio_duration_7': '7T',
      'bio_duration_15': '15T',
      'bio_duration_30': '30T',
      'bio_bailout': 'Bailout (Nur 1 Versuch)',
      'bio_not_enough_coins': 'Nicht genug Münzen.',
      'bio_locked': 'Gesperrt',
      'bio_bailout_used': 'Bailout verbraucht.'
    }
  };

  final dir = Directory('e:/Kanu Flutter/Amomimus/lib/i18n');
  
  for (final lang in keys.keys) {
    final file = File('${dir.path}/$lang.i18n.json');
    if (file.existsSync()) {
      final jsonString = file.readAsStringSync();
      final Map<String, dynamic> data = jsonDecode(jsonString);
      
      final langKeys = keys[lang]!;
      for (final key in langKeys.keys) {
        data[key] = langKeys[key];
      }
      
      file.writeAsStringSync(jsonEncode(data));
      print('Updated $lang.i18n.json');
    }
  }
}

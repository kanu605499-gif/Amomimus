import 'dart:convert';
import 'dart:io';

void main() async {
  final Map<String, Map<String, String>> updates = {
    'en': {
      'tutorial_3_desc': 'Get free coins by sliding your Bio section in your profile. Coins can be used to buy premium sticker packs or to Bypass the waiting time when changing character/bio.'
    },
    'id': {
      'tutorial_3_desc': 'Ambil koin gratis dengan menggeser (slide) kolom Bio di profilmu. Koin bisa dipakai untuk beli stiker pack premium atau melakukan Bypass (memotong waktu tunggu saat ganti karakter/bio).'
    },
    'th': {
      'tutorial_3_desc': 'รับเหรียญฟรีโดยการเลื่อนส่วนประวัติในโปรไฟล์ของคุณ เหรียญสามารถใช้ซื้อสติกเกอร์พรีเมียมหรือเพื่อลดเวลารอเมื่อเปลี่ยนตัวละคร/ประวัติ'
    },
    'ja': {
      'tutorial_3_desc': 'プロフィールの自己紹介（Bio）セクションをスライドして無料コインをゲット。コインはプレミアムステッカーパックの購入や、キャラクター/自己紹介変更時の待機時間を短縮（バイパス）するために使用できます。'
    },
    'de': {
      'tutorial_3_desc': 'Holen Sie sich kostenlose Münzen, indem Sie Ihren Bio-Bereich in Ihrem Profil wischen. Münzen können verwendet werden, um Premium-Sticker-Pakete zu kaufen oder die Wartezeit beim Wechseln von Charakter/Bio zu umgehen.'
    },
    '[tamriel]': {
      'tutorial_3_desc': 'Get free coins by sliding your Bio section in your profile. Coins can be used to buy premium sticker packs or to Bypass the waiting time when changing character/bio.'
    }
  };

  for (final entry in updates.entries) {
    final lang = entry.key;
    final file = File('lib/i18n/$lang.i18n.json');
    
    if (file.existsSync()) {
      var content = await file.readAsString();
      final Map<String, dynamic> jsonMap = jsonDecode(content);
      
      jsonMap['tutorial_3_desc'] = entry.value['tutorial_3_desc'];
      
      final encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(jsonMap));
      print('Updated $lang.i18n.json');
    } else {
      print('File not found: lib/i18n/$lang.i18n.json');
    }
  }
}

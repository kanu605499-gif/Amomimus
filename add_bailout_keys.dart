import 'dart:convert';
import 'dart:io';

void main() async {
  final Map<String, Map<String, String>> translations = {
    'en.i18n.json': {
      "bio_bailout_warning": "You have pressed the one-time bailout option to edit your bio. Please press continue to proceed with the bailout process using 500 coins.",
      "bio_bailout_confirm": "Please confirm your bailout by pressing the paper plane button."
    },
    'id.i18n.json': {
      "bio_bailout_warning": "Anda telah menekan opsi one time bailout untuk mengedit bio anda, silahkan tekan lanjut untuk melanjutkan proses bailout menggunakan 500 coins.",
      "bio_bailout_confirm": "Silahkan konfirmasi bailout anda dengan menekan tombol pesawat kertas."
    },
    'th.i18n.json': {
      "bio_bailout_warning": "คุณได้กดตัวเลือก bailout แบบครั้งเดียวเพื่อแก้ไขประวัติของคุณ โปรดกดดำเนินการต่อเพื่อเข้าสู่กระบวนการ bailout โดยใช้ 500 coins",
      "bio_bailout_confirm": "โปรดยืนยัน bailout ของคุณโดยกดปุ่มเครื่องบินกระดาษ"
    },
    'tm.i18n.json': {
      "bio_bailout_warning": "Siz bioňyzy üýtgetmek üçin bir gezeklik bailout opsiýasyna basdyňyz. 500 teňňe ulanyp bailout prosesini dowam etdirmek üçin dowam et düwmesine basyň.",
      "bio_bailout_confirm": "Kagyz uçary düwmesine basyp bailoutyňyzy tassyklaň."
    },
    'ja.i18n.json': {
      "bio_bailout_warning": "あなたはプロファイルを編集するために1回限りのベイルアウトオプションを押しました。500コインを使用してベイルアウトプロセスを続行するには、続行を押してください。",
      "bio_bailout_confirm": "紙飛行機のボタンを押して、ベイルアウトを確認してください。"
    },
    'de.i18n.json': {
      "bio_bailout_warning": "Sie haben die einmalige Bailout-Option gedrückt, um Ihre Bio zu bearbeiten. Bitte drücken Sie auf Weiter, um den Bailout-Vorgang mit 500 Münzen fortzusetzen.",
      "bio_bailout_confirm": "Bitte bestätigen Sie Ihren Bailout, indem Sie auf die Papierflugzeug-Taste drücken."
    }
  };

  for (final entry in translations.entries) {
    final file = File('lib/i18n/${entry.key}');
    if (file.existsSync()) {
      final content = await file.readAsString();
      final Map<String, dynamic> json = jsonDecode(content);
      
      json.addAll(entry.value);
      
      await file.writeAsString(jsonEncode(json));
    }
  }
  print('done');
}

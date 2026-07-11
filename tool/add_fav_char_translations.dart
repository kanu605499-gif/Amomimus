import 'dart:convert';
import 'dart:io';

void main() async {
  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json') && !f.path.contains('_missing') && !f.path.contains('_unused')).toList();

  final Map<String, Map<String, dynamic>> translations = {
    'en': {
      'fav_char_prompt_title': "Security Verification",
      'fav_char_prompt_desc': "Please set your Favorite Character. If you leave your Favorite Character blank, you won't be able to reset your password or recover your account in the future.",
      'fav_char_hint': "Your favorite character (e.g. Iron Man)",
      'save_button': "Save"
    },
    'id': {
      'fav_char_prompt_title': "Verifikasi Keamanan",
      'fav_char_prompt_desc': "Silakan atur Karakter Favorit Anda. Jika Anda membiarkan Karakter Favorit kosong, Anda tidak akan bisa mereset kata sandi atau memulihkan akun Anda di masa mendatang.",
      'fav_char_hint': "Karakter favorit (misal: Iron Man)",
      'save_button': "Simpan"
    },
    'ja': {
      'fav_char_prompt_title': "セキュリティ確認",
      'fav_char_prompt_desc': "好きなキャラクターを設定してください。空白のままにすると、将来パスワードのリセットやアカウントの復元ができなくなります。",
      'fav_char_hint': "好きなキャラクター (例: ドラえもん)",
      'save_button': "保存"
    },
    'de': {
      'fav_char_prompt_title': "Sicherheitsüberprüfung",
      'fav_char_prompt_desc': "Bitte legen Sie Ihren Lieblingscharakter fest. Wenn Sie dieses Feld leer lassen, können Sie Ihr Passwort in Zukunft nicht mehr zurücksetzen oder Ihr Konto wiederherstellen.",
      'fav_char_hint': "Dein Lieblingscharakter (z.B. Batman)",
      'save_button': "Speichern"
    },
    'th': {
      'fav_char_prompt_title': "การยืนยันความปลอดภัย",
      'fav_char_prompt_desc': "โปรดตั้งค่าตัวละครที่คุณชื่นชอบ หากคุณปล่อยว่างไว้ คุณจะไม่สามารถรีเซ็ตรหัสผ่านหรือกู้คืนบัญชีของคุณได้ในอนาคต",
      'fav_char_hint': "ตัวละครที่คุณชื่นชอบ (เช่น Iron Man)",
      'save_button': "บันทึก"
    },
    '[tamriel]': {
      'fav_char_prompt_title': "Bind Your Identity",
      'fav_char_prompt_desc': "Speak the name of a legendary hero. If you leave this blank, the divines cannot help you recover your soul or reset your memory in the future.",
      'fav_char_hint': "Name of a hero (e.g. Talos)",
      'save_button': "Bind"
    }
  };

  for (var file in files) {
    String langCode = file.path.split(Platform.pathSeparator).last.replaceAll('.i18n.json', '');
    if (translations.containsKey(langCode)) {
      String content = await file.readAsString();
      Map<String, dynamic> jsonMap = jsonDecode(content);
      
      jsonMap.addAll(translations[langCode]!);
      
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String newContent = encoder.convert(jsonMap);
      await file.writeAsString(newContent);
      print('Updated \$langCode');
    }
  }
}

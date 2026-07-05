import 'dart:convert';
import 'dart:io';

void main() async {
  final translations = {
    'id.i18n.json': {
      'send_email': 'Kirim Email',
      'visit_instagram': 'Kunjungi Instagram',
      'developer_role': 'Developer',
      'bug_report_success': 'Laporan bug berhasil dikirim.',
      'bug_report_fail_limit': 'Gagal mengirim. Batas mingguan Anda (3/minggu) sudah tercapai.',
      'bug_report_describe': 'Jelaskan bug atau masalah yang Anda temui.',
      'bug_report_wait': 'Tunggu',
      'bug_category_ui': 'UI / Masalah Visual',
      'bug_category_crash': 'Aplikasi Crash / Freeze',
      'bug_category_feature': 'Fitur Tidak Berfungsi',
      'bug_category_other': 'Lainnya',
    },
    'en.i18n.json': {
      'send_email': 'Send Email',
      'visit_instagram': 'Visit Instagram',
      'developer_role': 'Developer',
      'bug_report_success': 'Bug report submitted successfully.',
      'bug_report_fail_limit': 'Failed to submit. You may have reached your weekly limit (3/week).',
      'bug_report_describe': 'Describe the glitch or issue you encountered.',
      'bug_report_wait': 'Wait',
      'bug_category_ui': 'UI / Visual Glitch',
      'bug_category_crash': 'App Crash / Freeze',
      'bug_category_feature': 'Feature Not Working',
      'bug_category_other': 'Other',
    },
    'ja.i18n.json': {
      'send_email': 'メールを送信',
      'visit_instagram': 'Instagramを見る',
      'developer_role': '開発者',
      'bug_report_success': 'バグレポートが正常に送信されました。',
      'bug_report_fail_limit': '送信に失敗しました。週間上限（3回/週）に達している可能性があります。',
      'bug_report_describe': '発生したバグや問題について説明してください。',
      'bug_report_wait': '待機',
      'bug_category_ui': 'UI / 表示のバグ',
      'bug_category_crash': 'アプリのクラッシュ / フリーズ',
      'bug_category_feature': '機能が動作しない',
      'bug_category_other': 'その他',
    },
    'th.i18n.json': {
      'send_email': 'ส่งอีเมล',
      'visit_instagram': 'ไปที่ Instagram',
      'developer_role': 'นักพัฒนา',
      'bug_report_success': 'ส่งรายงานข้อผิดพลาดสำเร็จ',
      'bug_report_fail_limit': 'ส่งไม่สำเร็จ คุณอาจถึงขีดจำกัดรายสัปดาห์ (3 ครั้ง/สัปดาห์) แล้ว',
      'bug_report_describe': 'อธิบายข้อผิดพลาดหรือปัญหาที่คุณพบ',
      'bug_report_wait': 'รอ',
      'bug_category_ui': 'ปัญหา UI / การแสดงผล',
      'bug_category_crash': 'แอปขัดข้อง / ค้าง',
      'bug_category_feature': 'ฟีเจอร์ไม่ทำงาน',
      'bug_category_other': 'อื่นๆ',
    },
    'de.i18n.json': {
      'send_email': 'E-Mail senden',
      'visit_instagram': 'Instagram besuchen',
      'developer_role': 'Entwickler',
      'bug_report_success': 'Fehlerbericht erfolgreich gesendet.',
      'bug_report_fail_limit': 'Senden fehlgeschlagen. Sie haben möglicherweise Ihr wöchentliches Limit (3/Woche) erreicht.',
      'bug_report_describe': 'Beschreiben Sie den Fehler oder das Problem, das Sie haben.',
      'bug_report_wait': 'Warten',
      'bug_category_ui': 'UI / Anzeigefehler',
      'bug_category_crash': 'App-Absturz / Einfrieren',
      'bug_category_feature': 'Funktion funktioniert nicht',
      'bug_category_other': 'Andere',
    },
    'tm.i18n.json': {
      'send_email': 'Minsal Anuppu',
      'visit_instagram': 'Instagram Paarungal',
      'developer_role': 'Uruvaakunar',
      'bug_report_success': 'Pizhai arikkai vetrikaramaga anuppapattathu.',
      'bug_report_fail_limit': 'Anuppa mudiyavillai. Vaara varambai (3/vaaram) athingam.',
      'bug_report_describe': 'Neengal kanda pizhai allathu pirachanaiyai vivarikkavum.',
      'bug_report_wait': 'Kaathiru',
      'bug_category_ui': 'UI / Thotra Pizhai',
      'bug_category_crash': 'App Crash / Uraithal',
      'bug_category_feature': 'Seyalpadatha Vasanthi',
      'bug_category_other': 'Pira',
    },
  };

  final dir = Directory('lib/i18n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json') && !f.path.contains('_'));

  for (var file in files) {
    final name = file.path.split(Platform.pathSeparator).last;
    if (translations.containsKey(name)) {
      final content = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(content);
      
      jsonMap.addAll(translations[name]!);
      
      await file.writeAsString(json.encode(jsonMap));
      print('Updated translations in $name');
    }
  }
}

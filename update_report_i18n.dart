import 'dart:convert';
import 'dart:io';

void main() {
  final enFile = File('lib/i18n/en.i18n.json');
  final idFile = File('lib/i18n/id.i18n.json');

  final enMap = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
  final idMap = jsonDecode(idFile.readAsStringSync()) as Map<String, dynamic>;

  enMap['report_limit_daily'] = 'Daily global limit reached. Applying locally.';
  enMap['report_limit_category'] = 'Global token for this category exhausted. Applying locally.';
  enMap['report_limit_weekly_hate_speech'] = 'Weekly hate speech limit reached. Applying locally.';
  enMap['report_limit_global'] = 'Global limit reached. Applying locally.';

  idMap['report_limit_daily'] = 'Limit global harian tercapai. Diterapkan secara lokal.';
  idMap['report_limit_category'] = 'Token global untuk kategori ini habis. Diterapkan secara lokal.';
  idMap['report_limit_weekly_hate_speech'] = 'Limit hate speech mingguan tercapai. Diterapkan secara lokal.';
  idMap['report_limit_global'] = 'Limit global tercapai. Diterapkan secara lokal.';

  enFile.writeAsStringSync(jsonEncode(enMap));
  idFile.writeAsStringSync(jsonEncode(idMap));
  
  print('Done updating translation JSON files.');
}

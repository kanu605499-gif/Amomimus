import 'dart:convert';
import 'dart:io';

void main() async {
  final Map<String, Map<String, String>> updates = {
    'id': {
      'app_features_title': 'Fitur Aplikasi',
      'system_features_title': 'Fitur Sistem'
    },
    'de': {
      'app_features_title': 'App-Funktionen',
      'system_features_title': 'Systemfunktionen'
    },
    'ja': {
      'app_features_title': 'アプリの機能',
      'system_features_title': 'システムの機能'
    },
    'th': {
      'app_features_title': 'คุณสมบัติแอป',
      'system_features_title': 'คุณสมบัติระบบ'
    },
    'tm': {
      'app_features_title': 'Köpýe Aýratynlyklary',
      'system_features_title': 'Ulgam Aýratynlyklary'
    }
  };

  for (final entry in updates.entries) {
    final lang = entry.key;
    final file = File('lib/i18n/$lang.i18n.json');
    
    if (file.existsSync()) {
      var content = await file.readAsString();
      final Map<String, dynamic> jsonMap = jsonDecode(content);
      
      jsonMap['app_features_title'] = entry.value['app_features_title'];
      jsonMap['system_features_title'] = entry.value['system_features_title'];
      
      await file.writeAsString(jsonEncode(jsonMap));
      print('Updated $lang');
    }
  }
}

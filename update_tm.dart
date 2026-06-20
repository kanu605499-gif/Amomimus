import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('lib/i18n/tm.i18n.json');
  if (!file.existsSync()) {
    print('File not found');
    return;
  }
  
  final content = await file.readAsString();
  final Map<String, dynamic> jsonMap = json.decode(content);

  // Timebomb and action bar keys
  jsonMap['resend'] = 'Recast Thu\'um';
  jsonMap['delete_selected'] = 'Banish Runes';
  jsonMap['failed_to_send'] = 'Thu\'um fizzled';
  jsonMap['resend_confirm_title'] = 'Confirm Recast';
  jsonMap['resend_confirm_desc'] = 'Is the sequence of your voice true? The echoes will be released in order.';
  jsonMap['delete_confirm_desc'] = 'Are you certain you wish to cast this rot into the Void?';
  
  // Cheat detection
  jsonMap['cheat_detected_warning'] = 'The Daedric Princes mock your attempt to alter the flow of Time. This realm has been purged to ash.';
  jsonMap['cheat_partner_warning'] = 'Your fellow traveler tampered with the Elder Scrolls of Time.';
  
  // Reset and info
  jsonMap['room_chat_resetted'] = 'A new Courier approaches';
  jsonMap['started_at'] = 'Summoned:';
  jsonMap['end_at'] = 'Oblivion:';
  
  // Copy feature
  jsonMap['copy'] = 'Scribe Rune';
  jsonMap['copied_to_clipboard'] = 'Etched into memory';

  // Save the file
  await file.writeAsString(json.encode(jsonMap));
  print('Updated Tamriel translations!');
}

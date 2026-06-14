import 'dart:io';

void main() {
  final file = File('e:/Kanu Flutter/project_flutter_b6/lib/screens/roomchat.dart');
  var content = file.readAsStringSync();

  // Fix import
  content = content.replaceAll("import '../language/language_manager.dart';", "import 'package:amomimus/i18n/strings.g.dart';");

  // Replace getString calls
  content = content.replaceAll("context.read<LanguageManager>().getString('memories')", "Translations.of(context).memories");
  content = content.replaceAll("context.read<LanguageManager>().getString('no_memories_pinned')", "Translations.of(context).no_memories_pinned");
  content = content.replaceAll("context.read<LanguageManager>().getString('delete_chat_title')", "Translations.of(context).delete_chat_title");
  content = content.replaceAll("context.read<LanguageManager>().getString('delete_chat_room_confirm')", "Translations.of(context).delete_chat_room_confirm");
  content = content.replaceAll("context.read<LanguageManager>().getString('cancel')", "Translations.of(context).cancel");
  content = content.replaceAll("context.read<LanguageManager>().getString('delete')", "Translations.of(context).delete");
  content = content.replaceAll("context.read<LanguageManager>().getString('message_deleted')", "Translations.of(context).message_deleted");
  content = content.replaceAll("context.read<LanguageManager>().getString('pin_limit_error')", "Translations.of(context).pin_limit_error");

  // Fix withOpacity
  content = content.replaceAll("withOpacity(isDark ? 0.4 : 0.1)", "withValues(alpha: isDark ? 0.4 : 0.1)");

  file.writeAsStringSync(content);
}

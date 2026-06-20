import 'dart:io';

void main() async {
  final filesToUpdate = [
    'lib/widgets/feed/feed_post_card.dart',
    'lib/screens/roomchat.dart',
    'lib/screens/settings_screen.dart',
    'lib/screens/profile_screen.dart',
    'lib/widgets/report_dialog.dart',
    'lib/services/chatmodel.dart',
    'lib/widgets/profile/profile_recent_resonates.dart',
    'lib/widgets/chat/chat_message_bubble.dart',
    'lib/widgets/chat/selection_action_bar.dart',
    'lib/widgets/chat/room_chat_mini_island.dart',
    'lib/widgets/chat/chat_home_list_section.dart',
  ];

  final importString = "import 'package:amomimus/utils/jelly_dialog.dart';\n";

  for (final path in filesToUpdate) {
    final file = File(path);
    if (!file.existsSync()) {
      print('File not found: $path');
      continue;
    }

    String content = await file.readAsString();
    bool changed = false;

    if (content.contains('showDialog(')) {
      content = content.replaceAll('showDialog(', 'showJellyDialog(');
      changed = true;
    }

    if (changed) {
      if (!content.contains('jelly_dialog.dart')) {
        // Find last import
        final lines = content.split('\n');
        int lastImportIndex = -1;
        for (int i = 0; i < lines.length; i++) {
          if (lines[i].startsWith('import ')) {
            lastImportIndex = i;
          }
        }
        
        if (lastImportIndex != -1) {
          lines.insert(lastImportIndex + 1, importString.trim());
          content = lines.join('\n');
        } else {
          content = importString + content;
        }
      }
      await file.writeAsString(content);
      print('Updated $path');
    }
  }
}

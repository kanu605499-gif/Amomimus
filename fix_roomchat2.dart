import 'dart:io';

void main() {
  final file = File('e:/Kanu Flutter/project_flutter_b6/lib/screens/roomchat.dart');
  var content = file.readAsStringSync();

  final targetCall = 'child: largeProfileWidget(),';
  final replacementCall = '''child: RoomChatLargeProfile(
                                          themeProvider: themeProvider,
                                          isProfileMenuExpanded: _isProfileMenuExpanded,
                                          waveController: _waveController,
                                          targetUsername: widget.username,
                                          dynamicHeaderColor: dynamicHeaderColor,
                                          dynamicHeaderIcon: dynamicHeaderIcon,
                                          currentTextSecondary: currentTextSecondary,
                                          currentText: currentText,
                                          currentBg: currentBg,
                                          targetAccount: targetAccount,
                                          activeChat: activeChat,
                                          onToggleProfileMenu: () {
                                            setState(() {
                                              _isProfileMenuExpanded = !_isProfileMenuExpanded;
                                            });
                                          },
                                          onShowMemoriesPopup: _showMemoriesPopup,
                                        ),''';

  content = content.replaceFirst(targetCall, replacementCall);

  final importStmt = "import '../widgets/chat/room_chat_large_profile.dart';";
  if (!content.contains(importStmt)) {
    content = content.replaceFirst("import '../widgets/chat/room_chat_mini_island.dart';", "import '../widgets/chat/room_chat_mini_island.dart';\n\$importStmt");
  }

  // Remove largeProfileWidget
  final reg = RegExp(r'Widget largeProfileWidget\(\) \{.*?(?=return Theme\()', dotAll: true);
  content = content.replaceFirst(reg, '');

  file.writeAsStringSync(content);
}

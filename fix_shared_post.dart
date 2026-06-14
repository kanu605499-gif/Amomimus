import 'dart:io';

void main() {
  var file = File('e:/Kanu Flutter/project_flutter_b6/lib/widgets/chat/chat_message_bubble.dart');
  var content = file.readAsStringSync();
  
  if (!content.contains("import '../../widgets/feed/feed_post_card.dart';")) {
    content = content.replaceFirst(
      "import '../../services/account_manager.dart';", 
      "import '../../services/account_manager.dart';\nimport '../../widgets/feed/feed_post_card.dart';"
    );
  }

  // Find where it renders RichText
  String target = '''
                        if (isSticker)
                          Image.asset(
                            stickerAsset,
                            width: 130,
                            fit: BoxFit.contain,
                          )
                        else
                          RichText(
''';
  
  String replacement = '''
                        if (isSticker)
                          Image.asset(
                            stickerAsset,
                            width: 130,
                            fit: BoxFit.contain,
                          )
                        else if (isSharedPost && sharedPost != null)
                          FeedCard(model: sharedPost, feedIndex: -1)
                        else if (isSharedPost && sharedPost == null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: customBorderColor.withOpacity(0.5)),
                            ),
                            child: Text(
                              'Post is no longer available.',
                              style: TextStyle(color: textSecondaryColor, fontStyle: FontStyle.italic),
                            ),
                          )
                        else
                          RichText(
''';
  
  content = content.replaceFirst(target, replacement);
  file.writeAsStringSync(content);
}

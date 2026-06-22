import 'dart:io';

void main() {
  final file = File('lib/screens/roomchat.dart');
  var content = file.readAsStringSync();

  final sendMessageBlock = '''  void _sendMessage(String text) {
    final username = widget.username ?? '@partner_dev';
    final activeUser = context.read<AccountManager>().currentUser;
    final senderName = activeUser?.anonymousUsername ?? 'You';

    context.read<ChatModel>().sendMessage(
      username,
      text,
      senderName: senderName,
      targetName: widget.name,
      replyMessageId: _replyingToMessage?.id,
    );

    setState(() {
      _replyingToMessage = null;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendSticker(String assetPath) {
    final username = widget.username ?? '@partner_dev';
    final activeUser = context.read<AccountManager>().currentUser;
    final senderName = activeUser?.anonymousUsername ?? 'You';

    context.read<ChatModel>().sendMessage(
      username,
      '[STICKER]:\$assetPath',
      senderName: senderName,
      targetName: widget.name,
      replyMessageId: _replyingToMessage?.id,
    );

    setState(() {
      _replyingToMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }''';

  final replacementSend = '''  void _sendPayload(String payload) {
    final username = widget.username ?? '@partner_dev';
    final activeUser = context.read<AccountManager>().currentUser;
    final senderName = activeUser?.anonymousUsername ?? 'You';

    context.read<ChatModel>().sendMessage(
      username,
      payload,
      senderName: senderName,
      targetName: widget.name,
      replyMessageId: _replyingToMessage?.id,
    );

    setState(() {
      _replyingToMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) => _sendPayload(text);
  void _sendSticker(String assetPath) => _sendPayload('[STICKER]:\$assetPath');''';

  if (content.contains(sendMessageBlock)) {
    content = content.replaceAll(sendMessageBlock, replacementSend);
    print("Replaced _sendMessage and _sendSticker");
  } else {
    print("Did not find the exact send message block!");
  }

  file.writeAsStringSync(content);
}

import 'package:flutter/material.dart';
import '../../amomimusdark.dart';
import '../../models/post_model.dart';
import '../../helpers/gender_helpers.dart';
import '../../i18n/strings.g.dart';

class ChatSharedPost extends StatefulWidget {
  final FeedModel sharedPost;
  final Color bubbleColor;
  final Color customBorderColor;
  final Color textColor;
  final bool isUserMessage;

  const ChatSharedPost({
    super.key,
    required this.sharedPost,
    required this.bubbleColor,
    required this.customBorderColor,
    required this.textColor,
    required this.isUserMessage,
  });

  @override
  State<ChatSharedPost> createState() => _ChatSharedPostState();
}

class _ChatSharedPostState extends State<ChatSharedPost> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.bubbleColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.customBorderColor.withValues(alpha: 0.7),
          width: 1.85,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: widget.sharedPost.content,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                height: 1.5,
                fontFamily: 'serif',
              ),
            ),
            maxLines: 4,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);
          final bool isOverflowing = textPainter.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    GenderHelpers.getTypeIcon(widget.sharedPost.type),
                    color: GenderHelpers.getTypeColor(widget.sharedPost.type),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.sharedPost.id,
                    style:
                        GenderHelpers.getTypeIdTextStyle(
                          widget.sharedPost.type,
                        ).copyWith(
                          color: GenderHelpers.getTypeColor(
                            widget.sharedPost.type,
                          ),
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                maxLines: _isExpanded ? null : 4,
                overflow: _isExpanded
                    ? TextOverflow.clip
                    : TextOverflow.ellipsis,
                text: TextSpan(
                  text: widget.sharedPost.content,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    fontFamily: 'serif',
                  ),
                ),
              ),
              if (isOverflowing)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: widget.customBorderColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isExpanded ? t.show_less : t.show_more,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: widget.customBorderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

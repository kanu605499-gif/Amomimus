import 'package:amomimus/i18n/strings.g.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../models/post_model.dart';
import '../../services/feed_manager.dart';

class ProfileRecentResonates extends StatelessWidget {
  final dynamic user;
  final bool isDark;
  final bool isOtherUser;

  const ProfileRecentResonates({
    super.key,
    required this.user,
    required this.isDark,
    required this.isOtherUser,
  });

  void _showAllResonatesSheet(
    BuildContext context,
    List<FeedModel> userFeeds,
    bool isDark,
    bool isOtherUser,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool isSelectionMode = false;
        Set<String> selectedFeedIds = {};

        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.all_resonates,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xffb388ff),
                        ),
                      ),
                      if (isSelectionMode && selectedFeedIds.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                backgroundColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                                surfaceTintColor: Colors.transparent,
                                title: Row(
                                  children: [
                                    const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    const SizedBox(width: 8),
                                    Text(
                                      t.delete_post_title,
                                      style: TextStyle(
                                        color: isDark ? AmomimusDarkTheme.policeLineYellow : const Color(0xff684ca3),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  t.delete_post_confirm,
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogContext),
                                    child: Text(
                                      t.cancel,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final feedManager = Provider.of<FeedManager>(context, listen: false);
                                      for (final id in selectedFeedIds) {
                                        feedManager.deletePostById(id);
                                      }
                                      Navigator.pop(dialogContext);
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                    child: Text(
                                      t.delete,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: userFeeds.isEmpty
                        ? Center(
                            child: Text(
                              t.no_resonates_yet,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: userFeeds.length,
                            itemBuilder: (context, index) {
                              final feed = userFeeds[index];
                              return GestureDetector(
                                onTap: () {
                                  if (isSelectionMode) {
                                    setState(() {
                                      if (selectedFeedIds.contains(feed.id)) {
                                        selectedFeedIds.remove(feed.id);
                                        if (selectedFeedIds.isEmpty) {
                                          isSelectionMode = false;
                                        }
                                      } else {
                                        selectedFeedIds.add(feed.id);
                                      }
                                    });
                                  }
                                },
                                onLongPress: () {
                                  if (!isOtherUser) {
                                    setState(() {
                                      isSelectionMode = true;
                                      if (!selectedFeedIds.contains(feed.id)) {
                                        selectedFeedIds.add(feed.id);
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration.copyWith(
                                    border: isSelectionMode && selectedFeedIds.contains(feed.id)
                                        ? Border.all(color: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple, width: 2)
                                        : null,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (isSelectionMode)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12, top: 4),
                                          child: Icon(
                                            selectedFeedIds.contains(feed.id)
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: selectedFeedIds.contains(feed.id)
                                                ? (isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple)
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              feed.content,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isDark ? Colors.white : Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  feed.timeStamp,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.favorite_border,
                                                      size: 14,
                                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      feed.resonatedBy.length.toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final feedManager = Provider.of<FeedManager>(context);
    final userFeeds = feedManager.feeds.where((f) {
      if (f.realAuthorId != user.amomimusId) return false;
      if (isOtherUser) {
        if (f.createdAt != null) {
          final createdAt = DateTime.tryParse(f.createdAt!);
          if (createdAt != null) {
            if (DateTime.now().difference(createdAt).inHours > 24) return false;
          }
        } else {
          return false;
        }
      }
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.recent_resonates,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AmomimusDarkTheme.policeLineYellow
                        : AmomimusDarkTheme.primaryPurple,
                  ),
                ),
                TextButton(
                  onPressed: () => _showAllResonatesSheet(
                    context,
                    userFeeds,
                    isDark,
                    isOtherUser,
                  ),
                  child: Text(
                    t.see_all,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AmomimusDarkTheme.policeLineYellow
                          : AmomimusDarkTheme.primaryPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (userFeeds.isEmpty)
            Text(
              t.no_recent_resonates,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: min(3, userFeeds.length),
                itemBuilder: (context, index) {
                  final feed = userFeeds[index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: Provider.of<AmomimusDarkTheme>(
                      context,
                    ).cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '"${feed.content}"',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          feed.timeStamp,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class FeedManager extends ChangeNotifier {
  List<FeedModel> _feeds = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  DateTime? _lastFetchTime;
  DocumentSnapshot? _lastDocument;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<FeedModel> get feeds => _feeds;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  FeedModel? getPostById(String feedId) {
    try {
      return _feeds.firstWhere((f) => f.id == feedId);
    } catch (_) {
      return null;
    }
  }

  StreamSubscription<QuerySnapshot>? _feedSubscription;

  Future<void> loadFeeds({bool force = false}) async {
    // Prevent spamming reloads
    if (!force && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!).inSeconds < 3) {
        return; 
      }
    }
    _lastFetchTime = DateTime.now();
    
    if (force) {
      _isLoading = true;
      notifyListeners();
    }

    _feedSubscription?.cancel();
    _feedSubscription = _firestore
        .collection('feeds')
        .orderBy('createdAt', descending: true)
        .limit(30) // Initial load limit for pagination
        .snapshots()
        .listen((qs) {
      final now = DateTime.now();
      final List<FeedModel> loadedFeeds = [];

      for (var doc in qs.docs) {
        final feed = FeedModel.fromMap(doc.data());
        
        // Lazy cleanup for deleted authors' feeds (>30 days) AND normal feeds (>90 days)
        if (feed.createdAt != null) {
          try {
            final createdDate = DateTime.parse(feed.createdAt!);
            final daysOld = now.difference(createdDate).inDays;
            
            bool shouldDelete = false;
            if (feed.isDeletedAuthor && daysOld > 30) {
              shouldDelete = true;
            } else if (daysOld > 90) {
              shouldDelete = true; // All feeds expire after 3 months
            }

            if (shouldDelete) {
              // Delete permanently from server
              _firestore.collection('feeds').doc(feed.id).delete();
              continue; // Skip adding to UI
            }
          } catch (_) {
            // parsing error, ignore
          }
        }
        
        loadedFeeds.add(feed);
      }

      _feeds = loadedFeeds;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      print('Error loading feeds from Firestore stream: $e');
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _feedSubscription?.cancel();
    super.dispose();
  }

  DateTime? _lastPostTime;
  Future<bool> addPost(FeedModel post) async {
    // Anti-spam: 60 seconds cooldown between posts
    if (_lastPostTime != null && DateTime.now().difference(_lastPostTime!).inSeconds < 60) {
      return false; // Spam blocked
    }
    _lastPostTime = DateTime.now();

    // Add to UI immediately for snappy feeling
    _feeds.insert(0, post);
    // Only cap if we haven't loaded more pages, to avoid throwing away newly loaded items
    if (_feeds.length > 20 && !_hasMore) {
       // if we loaded everything and somehow hit >20, do nothing or just let it grow.
       // actually, just let it grow so pagination works.
    }
    notifyListeners();
    
    // Save to Firestore
    try {
      await _firestore.collection('feeds').doc(post.id).set(post.toMap());
    } catch (e) {
      print('Error adding post: $e');
    }
    return true;
  }

  Future<void> toggleResonate(String feedId, String userId) async {
    final index = _feeds.indexWhere((f) => f.id == feedId);
    if (index != -1) {
      // Optimistic update
      final feed = _feeds[index];
      if (feed.resonatedBy.contains(userId)) {
        feed.resonatedBy.remove(userId);
      } else {
        feed.resonatedBy.add(userId);
      }
      notifyListeners();

      // Update in Firestore using Transaction
      final feedRef = _firestore.collection('feeds').doc(feedId);
      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(feedRef);
          if (!snapshot.exists) return;

          final serverFeed = FeedModel.fromMap(snapshot.data()!);
          if (serverFeed.resonatedBy.contains(userId)) {
            serverFeed.resonatedBy.remove(userId);
          } else {
            serverFeed.resonatedBy.add(userId);
          }
          transaction.update(feedRef, {'resonatedBy': serverFeed.resonatedBy});
        });
      } catch (e) {
        print('Error toggling resonate: $e');
      }
    }
  }

  Future<void> addComment(String feedId, CommentModel comment) async {
    final index = _feeds.indexWhere((f) => f.id == feedId);
    if (index != -1) {
      // Optimistic update
      _feeds[index].comments.add(comment);
      notifyListeners();

      // Update in Firestore
      final feedRef = _firestore.collection('feeds').doc(feedId);
      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(feedRef);
          if (!snapshot.exists) return;

          final serverFeed = FeedModel.fromMap(snapshot.data()!);
          serverFeed.comments.add(comment);
          transaction.update(feedRef, {
            'comments': serverFeed.comments.map((e) => e.toMap()).toList()
          });
        });
      } catch (e) {
        print('Error adding comment: $e');
      }
    }
  }

  Future<void> deletePost(int index) async {
    if (index >= 0 && index < _feeds.length) {
      final feedId = _feeds[index].id;
      _feeds.removeAt(index);
      notifyListeners();

      try {
        await _firestore.collection('feeds').doc(feedId).delete();
      } catch (e) {
        print('Error deleting post: $e');
      }
    }
  }

  Future<void> deletePostById(String feedId) async {
    final index = _feeds.indexWhere((f) => f.id == feedId);
    if (index != -1) {
      _feeds.removeAt(index);
      notifyListeners();

      try {
        await _firestore.collection('feeds').doc(feedId).delete();
      } catch (e) {
        print('Error deleting post: $e');
      }
    }
  }

  Future<void> clearAll() async {
    // Only clear local cache, don't delete from Firestore
    _feeds.clear();
    notifyListeners();
  }
}




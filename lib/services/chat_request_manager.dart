import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_request_model.dart';

class ChatRequestManager extends ChangeNotifier {
  List<ChatRequest> _requests = [];
  String? _currentUserId;
  List<String> _localAccountIds = [];
  bool _initialized = false;
  StreamSubscription? _subscription;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _storageKey = 'amomimus_chat_requests';

  ChatRequestManager() {
    _loadLocalCache();
  }

  Future<void> _loadLocalCache() async {
    final storage = const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    );
    final data = await storage.read(key: _storageKey);
    if (data != null && data.isNotEmpty) {
      try {
        final List decoded = jsonDecode(data);
        _requests = decoded.map((e) => ChatRequest.fromJson(e)).toList();
      } catch (e) {
        _requests = [];
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> _saveLocalCache() async {
    final storage = const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    );
    await storage.write(
      key: _storageKey,
      value: jsonEncode(_requests.map((e) => e.toJson()).toList()),
    );
  }

  void setCurrentUser(String userId, List<String> localAccountIds) {
    if (_currentUserId != userId || _localAccountIds.join(',') != localAccountIds.join(',')) {
      _currentUserId = userId;
      _localAccountIds = List.from(localAccountIds);
      if (_initialized) {
        _setupFirestoreListener();
      }
    }
  }

  void _setupFirestoreListener() {
    _subscription?.cancel();
    if (_currentUserId == null) return;

    // Listen to requests where current user is sender OR receiver
    _subscription = _firestore
        .collection('chat_requests')
        .where(Filter.or(
          Filter('senderId', isEqualTo: _currentUserId),
          Filter('receiverId', isEqualTo: _currentUserId),
        ))
        .snapshots()
        .listen((snapshot) {
      _requests = snapshot.docs
          .map((doc) => ChatRequest.fromJson(doc.data()))
          .toList();
      
      _saveLocalCache();
      notifyListeners();
    }, onError: (e) {
      print('Error listening to chat requests: $e');
    });
  }

  List<ChatRequest> get incomingRequests {
    if (_currentUserId == null) return [];
    return _requests
        .where(
          (r) =>
              r.receiverId == _currentUserId &&
              r.status == RequestStatus.pending,
        )
        .toList();
  }

  List<ChatRequest> get outgoingRequests {
    if (_currentUserId == null) return [];
    return _requests
        .where(
          (r) =>
              r.senderId == _currentUserId &&
              r.status == RequestStatus.pending,
        )
        .toList();
  }

  bool hasPendingRequestWith(String targetId) {
    if (_currentUserId == null) return false;
    return _requests.any(
      (r) =>
          ((r.senderId == _currentUserId && r.receiverId == targetId) ||
              (r.receiverId == _currentUserId && r.senderId == targetId)) &&
          r.status == RequestStatus.pending,
    );
  }

  bool isChatAllowed(String targetId) {
    if (_currentUserId == null) return false;
    return _requests.any(
      (r) =>
          ((r.senderId == _currentUserId && r.receiverId == targetId) ||
              (r.receiverId == _currentUserId && r.senderId == targetId)) &&
          r.status == RequestStatus.accepted,
    );
  }

  Future<void> sendRequest(String targetId, String targetName, String senderName) async {
    if (_currentUserId == null) return;

    // Check if already requested
    if (hasPendingRequestWith(targetId) || isChatAllowed(targetId)) return;

    final newReq = ChatRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId!,
      senderName: senderName,
      receiverId: targetId,
      receiverName: targetName,
      timestamp: DateTime.now().toIso8601String(),
    );

    // Optimistic UI update
    _requests.add(newReq);
    _saveLocalCache();
    notifyListeners();

    if (_localAccountIds.contains(_currentUserId) && _localAccountIds.contains(targetId)) {
      return; // Skip Firestore for local sub-profiles
    }

    try {
      await _firestore
          .collection('chat_requests')
          .doc(newReq.id)
          .set(newReq.toJson());
    } catch (e) {
      print('Error sending chat request: $e');
    }
  }

  Future<void> acceptRequest(String requestId) async {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final req = _requests[idx];
      req.status = RequestStatus.accepted;
      notifyListeners();

      if (_localAccountIds.contains(req.senderId) && _localAccountIds.contains(req.receiverId)) {
        return; // Skip Firestore for local sub-profiles
      }

      try {
        await _firestore
            .collection('chat_requests')
            .doc(requestId)
            .update({'status': RequestStatus.accepted.name});
      } catch (e) {
        print('Error accepting chat request: $e');
      }
    }
  }

  Future<void> rejectRequest(String requestId) async {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final req = _requests[idx];
      req.status = RequestStatus.rejected;
      notifyListeners();

      if (_localAccountIds.contains(req.senderId) && _localAccountIds.contains(req.receiverId)) {
        return; // Skip Firestore for local sub-profiles
      }

      try {
        await _firestore
            .collection('chat_requests')
            .doc(requestId)
            .update({'status': RequestStatus.rejected.name});
      } catch (e) {
        print('Error rejecting chat request: $e');
      }
    }
  }

  Future<void> cancelRequest(String requestId) async {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final req = _requests[idx];
      _requests.removeAt(idx);
      notifyListeners();

      if (_localAccountIds.contains(req.senderId) && _localAccountIds.contains(req.receiverId)) {
        return; // Skip Firestore for local sub-profiles
      }

      try {
        await _firestore
            .collection('chat_requests')
            .doc(requestId)
            .delete();
      } catch (e) {
        print('Error canceling chat request: $e');
      }
    }
  }

  Future<void> deleteRequestWith(String targetId) async {
    if (_currentUserId == null) return;
    
    final toDelete = _requests.where(
      (r) =>
          ((r.senderId == _currentUserId && r.receiverId == targetId) ||
          (r.receiverId == _currentUserId && r.senderId == targetId)),
    ).toList();

    _requests.removeWhere((r) => toDelete.contains(r));
    notifyListeners();

    final batch = _firestore.batch();
    bool hasRemoteDeletes = false;
    for (var req in toDelete) {
      if (!(_localAccountIds.contains(req.senderId) && _localAccountIds.contains(req.receiverId))) {
        final docRef = _firestore.collection('chat_requests').doc(req.id);
        batch.delete(docRef);
        hasRemoteDeletes = true;
      }
    }
    
    if (!hasRemoteDeletes) return;

    try {
      await batch.commit();
    } catch (e) {
      print('Error deleting chat request: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

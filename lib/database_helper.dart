import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/user_model.dart';
export 'models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> createUser(UserAccount user) async {
    await _firestore.collection('users').doc(user.amomimusId).set(user.toMap());
    return 1;
  }

  Future<void> deleteUser(String email) async {
    final qs = await _firestore.collection('users').where('master_email', isEqualTo: email).get();
    for (var doc in qs.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> updateUser(UserAccount user) async {
    await _firestore.collection('users').doc(user.amomimusId).update(user.toMap());
  }

  Future<List<UserAccount>> getAllUsers() async {
    final currentUserEmail = _auth.currentUser?.email;
    if (currentUserEmail == null) return [];
    
    final qs = await _firestore.collection('users').where('master_email', isEqualTo: currentUserEmail).get();
    return qs.docs.map((doc) => UserAccount.fromMap(doc.data())).toList();
  }

  Future<void> clearAll() async {
    // Only for local cleanup if needed, skip for Firestore as it's cloud
  }
}

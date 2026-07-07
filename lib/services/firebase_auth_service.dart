import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../models/user_credentials_model.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> isEmailRegistered(String email) async {
    try {
      final qs = await _firestore
          .collection('users')
          .where('master_email', isEqualTo: email)
          .limit(1)
          .get();
      return qs.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }


  @override
  Future<UserAccount?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        if (!userCredential.user!.emailVerified) {
          await _auth.signOut();
          throw Exception('email-not-verified');
        }

        final qs = await _firestore
            .collection('users')
            .where('master_email', isEqualTo: email)
            .limit(1)
            .get();
        if (qs.docs.isNotEmpty) {
          return UserAccount.fromMap(qs.docs.first.data());
        }
      }
      return null;
    } catch (e) {
      if (e.toString().contains('email-not-verified')) {
        throw Exception('email-not-verified');
      }
      print("==== FIREBASE LOGIN ERROR: $e ====");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount(String email) async {
    try {
      // Hapus semua profil (maks 3) yang terhubung
      final qs = await _firestore
          .collection('users')
          .where('master_email', isEqualTo: email)
          .get();
      for (var doc in qs.docs) {
        final amomimusId = doc.id;
        
        // Soft-delete semua postingan Feed buatan profile ini
        final feedQs = await _firestore
            .collection('feeds')
            .where('realAuthorId', isEqualTo: amomimusId)
            .get();
        for (var feedDoc in feedQs.docs) {
          await feedDoc.reference.update({
            'isDeletedAuthor': true,
            'realAuthorId': '[DELETED]',
          });
        }
        
        await doc.reference.delete();
      }
      
      // Hapus data master
      await _firestore.collection('master_accounts').doc(email).delete();

      // Hapus Auth User
      if (_auth.currentUser?.email == email) {
        await _auth.currentUser?.delete();
      }
    } catch (e) {
      print("==== FIREBASE DELETE ERROR: $e ====");
    }
  }

  @override
  Future<bool> updateCredentials(UserCredentialsModel updatedCredentials) async {
    try {
      final email = updatedCredentials.email ?? "";
      if (updatedCredentials.password != null &&
          updatedCredentials.password!.isNotEmpty) {
        await _auth.currentUser?.updatePassword(updatedCredentials.password!);
      }
      
      final data = updatedCredentials.toMap();
      data.remove('password');
      await _firestore
          .collection('master_accounts')
          .doc(email)
          .update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserCredentialsModel?> getCredentials(String email) async {
    try {
      final doc = await _firestore.collection('master_accounts').doc(email).get();
      if (doc.exists) {
        final data = doc.data()!;
        return UserCredentialsModel.fromMap(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<GoogleAuthResult?> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: '932913168592-8pt7fcv6a1jg0a1t2tpkva3ca47o1vl3.apps.googleusercontent.com',
      );
      
      // Force Android to forget the previous choice so the account picker always shows up!
      await googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the login
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Check if master_accounts exists
        final doc = await _firestore.collection('master_accounts').doc(user.email).get();
        if (doc.exists) {
          // Fetch the first profile
          final qs = await _firestore
              .collection('users')
              .where('master_email', isEqualTo: user.email)
              .limit(1)
              .get();
              
          if (qs.docs.isNotEmpty) {
            return GoogleAuthResult(
              isNewUser: false,
              account: UserAccount.fromMap(qs.docs.first.data()),
            );
          }
        }

        // New user! Return their email and name to complete registration
        return GoogleAuthResult(
          isNewUser: true,
          email: user.email,
          name: user.displayName,
        );
      }
      return null;
    } catch (e) {
      print("==== GOOGLE SIGN-IN ERROR: $e ====");
      return null;
    }
  }

  Future<String> _generateUniqueAmomimusId() async {
    int retries = 0;
    while (retries < 5) {
      final alpha = String.fromCharCode(math.Random().nextInt(26) + 65);
      final numeric = math.Random().nextInt(1000000).toString().padLeft(6, '0');
      final newId = 'AM$alpha-$numeric';

      final qs = await _firestore.collection('users').where('amomimusId', isEqualTo: newId).get();
      if (qs.docs.isEmpty) {
        return newId; // Unique ID found
      }
      retries++;
    }
    throw Exception("Failed to generate unique Amomimus ID after 5 retries.");
  }

  @override
  Future<UserAccount?> registerAccount(
    UserCredentialsModel credentials,
    UserAccount profile,
  ) async {
    try {
      // 1. Check if we need to create Auth User or just add profile
      try {
        // New Master Email
        await _auth.createUserWithEmailAndPassword(
          email: credentials.email!,
          password: credentials.password!,
        );
        await _auth.currentUser?.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // Master Email already exists (Sub-profile creation)
          // Verify password first by signing in
          await _auth.signInWithEmailAndPassword(
            email: credentials.email!,
            password: credentials.password!,
          );
          
          // Cek limit maksimal 3 profil
          final profilesQs = await _firestore
              .collection('users')
              .where('master_email', isEqualTo: credentials.email)
              .get();
          if (profilesQs.docs.length >= 3) {
            return null; // Limit tercapai
          }
        } else {
          return null;
        }
      }

      // 2. Generate Unique ID for the new profile
      final finalProfile = profile.copyWith(amomimusId: await _generateUniqueAmomimusId());

      // 3. Save Master Account Metadata (if doesn't exist)
      final masterDoc = await _firestore.collection('master_accounts').doc(credentials.email).get();
      if (!masterDoc.exists) {
        final masterData = credentials.toMap();
        masterData.remove('password');
        await _firestore.collection('master_accounts').doc(credentials.email).set(masterData);
      }

      // 4. Save User Profile under 'users' collection
      await _firestore
          .collection('users')
          .doc(finalProfile.amomimusId)
          .set(finalProfile.toMap());
      return finalProfile;
    } catch (e) {
      print("==== FIREBASE REGISTER ERROR: $e ====");
      return null;
    }
  }

  @override
  Future<UserAccount?> registerGoogleProfile(UserCredentialsModel credentials, UserAccount profile) async {
    try {
      final email = credentials.email ?? "";
      print("==== DEBUG: Starting registerGoogleProfile for $email ====");
      
      // 1. Validasi Maksimal 3 Profil
      final profilesQs = await _firestore
          .collection('users')
          .where('master_email', isEqualTo: email)
          .get();
      print("==== DEBUG: Found ${profilesQs.docs.length} existing profiles ====");
      if (profilesQs.docs.length >= 3) {
        print("==== DEBUG: Limit 3 reached, returning null ====");
        return null;
      }

      // 2. Generate Unique ID
      final newId = await _generateUniqueAmomimusId();
      print("==== DEBUG: Generated new ID: $newId ====");
      final finalProfile = profile.copyWith(amomimusId: newId);

      // 3. Simpan Profil ke Firestore (Tabel users)
      await _firestore
          .collection('users')
          .doc(finalProfile.amomimusId)
          .set(finalProfile.toMap());
      print("==== DEBUG: Saved profile to users collection ====");

      // 4. Simpan Metadata Master Akun jika belum ada
      final doc = await _firestore.collection('master_accounts').doc(email).get();
      if (!doc.exists) {
        final data = credentials.toMap();
        data.remove('password');
        await _firestore
            .collection('master_accounts')
            .doc(email)
            .set(data);
      }

      return finalProfile;
    } catch (e) {
      print("==== FIREBASE REGISTER GOOGLE PROFILE ERROR: $e ====");
      return null;
    }
  }

  @override
  Future<bool> reauthenticate(String? password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      if (password != null && password.isNotEmpty) {
        // Email/Password re-authentication
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(cred);
        return true;
      } else {
        // Google Sign-In re-authentication
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return false;

        final googleAuth = await googleUser.authentication;
        final cred = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await user.reauthenticateWithCredential(cred);
        return true;
      }
    } catch (e) {
      print("==== REAUTHENTICATION ERROR: $e ====");
      return false;
    }
  }
}

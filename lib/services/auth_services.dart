import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_flutter/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // dang ky và lưu thông tin vào firestore

  Future<User?> signUp(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        AppUser appUser = AppUser(
          uid: user.uid,
          email: email,
          name: name,
          phone: phone,
        );

        await _db.collection('users').doc(user.uid).set(appUser.toMap());

        return user;
      }
    } catch (e) {
      print('Sign Up error $e');
      return null;
    }
  }

  // lấy thông tin user từ firestore
  Future<AppUser?> getUserProfile(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).get();
    if (snapshot.exists) {
      return AppUser.fromMap(snapshot.data()!, uid);
    }
  }

  // dang nhap
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Sign In error $e');
      return null;
    }
  }

  // đăng xuất
  Future<User?> signOut() async {
    await _auth.signOut();
  }

  // Stream theo dõi trạng thái User
  Stream<User?> get userChanges {
    return _auth.authStateChanges();
  }
}

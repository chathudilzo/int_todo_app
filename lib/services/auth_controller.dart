import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

 Future<User?> checkAuth() async {
  try {
    return await _auth.authStateChanges().first;
  } catch (e) {
    print('Error checking authentication: $e');
    return null;
  }
}


  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Show success snackbar
      Get.snackbar('Success', 'Registration successful',
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to login page
      Get.offAllNamed('/login');
    } catch (e) {

      Get.snackbar('Error', 'Failed to register',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    
      Get.snackbar('Success', 'Login successful',
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to home page 
      Get.offAllNamed('/home');
    } catch (e) {
      
      Get.snackbar('Error', 'Failed to sign in',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  Future<void> createUserProfile(String uid, String email) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
    });
  }

  Future<DocumentSnapshot> getUserProfile(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final RxString Username = "".obs;
  final RxString email = "".obs;
  final RxString imageUrl = "".obs;
  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final emailController = TextEditingController(text: "amresh@gmail.com").obs;
  final passwordController = TextEditingController(text: "Test@123456").obs;
  final nameController = TextEditingController().obs;

  final isVisible = false.obs;

  void toggleVisibility() {
    isVisible.value = !isVisible.value;
  }

  Rx<User?> user = Rx<User?>(null);

  Future<void> createNewUser(
      String email, String password, String nameController) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'id': userCredential.user!.uid,
        'createdAt': DateTime.now().toIso8601String(),
        'username': nameController,
      });
      Get.snackbar("Reister", "created succesfully");
      if (kDebugMode) {
        print('User created successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user: $e');
      }
    }
  }

  Future<bool?> login() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.value.text,
        password: passwordController.value.text,
      );
      Get.snackbar("login", "User logged in successfully!");
      if (kDebugMode) {
        print('User ID: ${userCredential.user!.email}');
      }
      Username.value = userCredential?.user?.displayName ?? "no name";
      email.value = userCredential?.user?.email ?? "no email";
      imageUrl.value = userCredential?.user?.photoURL ??
          "https://images.unsplash.com/photo-1523050598477-4e179eda3d60?q=80&w=1681&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
      isLoading.value = false;
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in: $e');
      }
      isLoading.value = false;
      return false;
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) return null;

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      Username.value = user?.displayName ?? "";
      email.value = user?.email ?? "";
      imageUrl.value = user?.photoURL ?? "";
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}

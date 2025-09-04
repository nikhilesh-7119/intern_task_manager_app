import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/models/user_model.dart';
import 'package:task_manager_app/screens/auth_gateway/auth_gateway.dart';

class AuthController extends GetxController {
  final loginEmail = TextEditingController();
  final loginPassword = TextEditingController();

  final signName = TextEditingController();
  final signEmail = TextEditingController();
  final signPassword = TextEditingController();
  final signConfirm = TextEditingController();

  RxBool isLoading = false.obs;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  void dispose() {
    loginEmail.dispose();
    loginPassword.dispose();
    signName.dispose();
    signEmail.dispose();
    signPassword.dispose();
    signConfirm.dispose();
    super.dispose();
  }

  initUser() async {
    var newUser = UserModel(
      id: auth.currentUser!.uid,
      email: signEmail.text,
      name: signName.text,
      createdAt: DateTime.now(),
    );
    try {
      await db
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(newUser.toJson());
    } catch (e) {
      Get.snackbar('Error in firebase', e.toString());
    }
  }

  Future<void> loginUser() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: loginEmail.text,
        password: loginPassword.text,
      );
      Get.snackbar('User logged in', 'Successful');
    } catch (e) {
      Get.snackbar('Error in login', e.toString());
    }
    isLoading.value = false;
  }

  Future<void> createUser() async {
    isLoading.value = true;
    try {
      if (signConfirm.text != signPassword.text) {
        Get.snackbar('Password Mismatch', 'Both passwords are different');
        isLoading.value = false;
        return;
      }
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: signEmail.text,
        password: signPassword.text,
      );
      await initUser();
      Get.snackbar('User Created', 'Successful');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoading.value = false;
  }

  Future<void> signOut() async {
    await auth.signOut();
    Get.snackbar('User logged out', 'Successful');
    Get.offAll(AuthGateway());
  }

  Future<UserModel?> fetchCurrentUser() async {
    final user = auth.currentUser;
    if (user == null) return null;
    final doc = await db.collection('users').doc(user.uid).get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    data['id'] = doc.id; // ensure id filled
    return UserModel.fromJson(data);
  }
}

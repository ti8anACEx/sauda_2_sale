import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sauda_2_sale/features/auth/pages/login_page.dart';
import 'package:sauda_2_sale/features/auth/pages/otp_page.dart';
import 'package:sauda_2_sale/features/auth/pages/splash_page.dart';
import 'package:sauda_2_sale/features/home/pages/home_page.dart';
import 'package:sauda_2_sale/models/vendor_model.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  RxBool isLoading = false.obs;
  RxBool isSplashing = true.obs;

  late Rx<User?> _userPersist;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserCredential? credential;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxString verificationCodeEntered = ''.obs;
  RxString verificationCodeSentToUser = ''.obs;
  int verificationCodeLength = 6;

  RxString currentUserUID = ''.obs;
  RxString currentPhoneNumber = ''.obs;
  RxString currentUsername = ''.obs;
  RxString currentEmail = ''.obs;
  RxString currentProfilePic = ''.obs;

  Future<void> getOTP() async {
    if (emailController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      Get.to(() => OTPPage());
    } else {
      return;
    }
  }

  Future<void> verifyOTP() async {
    // TODO: write code for verification then...
    isLoading.value = true;
    await checkIfUserExistsAndSign();
  }

  Future<void> resendOTP() async {}

  // USER STATE PERSISTENCE
  @override
  void onReady() {
    super.onReady();
    _userPersist = Rx<User?>(firebaseAuth.currentUser);
    _userPersist.bindStream(firebaseAuth.authStateChanges());
    ever(_userPersist, _setInitialRoute);
  }

  _setInitialRoute(User? user) {
    if (user == null) {
      Get.to(() => const SplashPage());
      Future.delayed(const Duration(seconds: 2)); // check for problems
      Get.offAll(() => LoginPage());
    } else {
      Get.to(() => const SplashPage());
      setInitialVariables();
    }
  }

  void setInitialVariables() {
    try {
      firestore
          .collection('vendors')
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots()
          .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          currentUserUID.value = FirebaseAuth.instance.currentUser!.uid;
          currentUsername.value = snapshot.data()?['username'] ?? '';
          currentEmail.value = snapshot.data()?['email'] ?? '';
          currentPhoneNumber.value = snapshot.data()?['phoneNumber'] ?? '';
          currentProfilePic.value = snapshot.data()?['profilePic'] ?? '';
          // currentHashedPassword.value = snapshot.data()?['hashedPassword'] ?? ''; // TODO : Hashed password is not made,

          isSplashing.value = false;
          Get.offAll(() => HomePage());
        } else {
          Get.offAll(() => HomePage());
        }
      });
    } catch (e) {
      Get.snackbar('', '"Error occured while loading details"');
    }
  }

  // Sign Up / Registration

  Future<void> signUpUser() async {
    try {
      if (emailController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          usernameController.text.isNotEmpty) {
        credential = await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        currentUserUID.value = credential!.user!.uid;

        VendorModel vendorModel = VendorModel(
          storeName: '',
          vendorsAppBundleId: '',
          username: usernameController.text,
          email: emailController.text.trim(),
          profilePic: '',
          ownerName: usernameController.text,
          uid: currentUserUID.value,
          phoneNumber: phoneNumberController.text,
          isSubscribed: false,
          officeAddress: '',
          gstin: '',
        );

        await FirebaseFirestore.instance
            .collection("vendors")
            .doc(currentUserUID.value)
            .set(vendorModel.toJson());

        Get.snackbar("Account Created",
            "Wassup ${currentUsername.value}, have a great time here!");
        Get.offAll(() => HomePage(), transition: Transition.circularReveal);
      } else {
        Get.snackbar("Failed Creating Account",
            "Please make sure you have filled all the details");
      }
    } catch (e) {
      Get.snackbar("Error Creating Account",
          "Please make sure you have filled all the details");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIfUserExistsAndSign() async {
    await firestore
        .collection('vendors')
        .where('username', isEqualTo: usernameController.text)
        .where('phoneNumber', isEqualTo: phoneNumberController.text)
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        signInUser();
      } else {
        signUpUser();
      }
    }).catchError((e) {
      Get.snackbar('Error', "Failed to fetch details");
    });
  }

  // Sign in / Log in
  Future<void> signInUser() async {
    isLoading.value = true;
    try {
      if (emailController.text.isNotEmpty &&
          usernameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());

        Get.snackbar("Success", "Logged in successfully");
        Get.offAll(() => HomePage(), transition: Transition.circularReveal);
      } else {
        Get.snackbar("Error Logging in", "Please fill up all the blocks");
      }
    } catch (e) {
      Get.snackbar("Error Logging in", '');
    } finally {
      isLoading.value = false;
    }
  }
}

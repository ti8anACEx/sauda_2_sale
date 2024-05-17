import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sauda_2_sale/features/auth/pages/login_page.dart';
import 'package:sauda_2_sale/features/auth/pages/otp_page.dart';
import 'package:sauda_2_sale/features/auth/pages/splash_page.dart';
import 'package:sauda_2_sale/features/home/pages/home_page.dart';
import 'package:sauda_2_sale/models/vendor_model.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  RxBool isLoading = false.obs;
  RxBool isSplashing = true.obs;
  RxBool wantEmailLogin = false.obs;

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
  RxString countryCode = '+91'.obs;

  RxString currentUserUID = ''.obs;
  RxString currentPhoneNumber = ''.obs;
  RxString currentUsername = ''.obs;
  RxString currentEmail = ''.obs;
  RxString currentProfilePic = ''.obs;

  void toggleWantEmailLogin() {
    wantEmailLogin.toggle();
    Get.snackbar("User wants Email Login", wantEmailLogin.value ? "Yes" : "No");
  }

  void toggleToTestCountryCode() {
    // for testing purposes to avoid going out of quota
    if (countryCode.value == "+91") {
      countryCode.value = "+1";
    } else {
      countryCode.value = "+91";
    }
    Get.snackbar("CountryCodeChanged", countryCode.value);
  }

  Future<void> getOTP() async {
    try {
      isLoading.value = true;
      if (emailController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          usernameController.text.isNotEmpty) {
        if (Platform.isIOS || kIsWeb || wantEmailLogin.value) {
          // we sign in with email and password only (will create a new user if not registered)
          await checkIfUserExistsAndSign(false, null);
        } else {
          // remove Platform.isIOS when configured IOS settings in a MAC device
          await phoneSignIn(countryCode + phoneNumberController.text);
        }
      } else {
        return;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("error", e.toString());
    }
  }

  Future<void> verifyOTP() async {
    try {
      isLoading.value = true;
      if (verificationCodeEntered.isEmpty ||
          verificationCodeEntered.value.length < verificationCodeLength) {
        Get.snackbar('Attention', 'Please enter the verification code');
        return;
      }
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCodeSentToUser.value,
        smsCode: verificationCodeEntered.value,
      );
      await checkIfUserExistsAndSign(true, credential);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> resendOTP() async {}

  Future<void> phoneSignIn(String phoneNo) async {
    try {
      if (kIsWeb) {
        ConfirmationResult result =
            await firebaseAuth.signInWithPhoneNumber(phoneNo);
        verificationCodeSentToUser.value = result.verificationId;
        Get.to(() => OTPPage());
        isLoading.value = false;
      } else {
        // FOR ANDROID, IOS
        await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          verificationCompleted: (PhoneAuthCredential cred) async {
            //FN works only on Android, auto fills to verify
            await firebaseAuth.signInWithCredential(cred);
          },
          verificationFailed: (error) {
            Get.snackbar('Failed', error.toString());
          },
          codeSent: ((String verificationId, int? resendToken) async {
            verificationCodeSentToUser.value = verificationId;
            Get.to(() => OTPPage());
            isLoading.value = false;
          }),
          codeAutoRetrievalTimeout: (verificationId) {},
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Auth Error :$e");
    }
  }

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

  Future<void> checkIfUserExistsAndSign(
      bool isPhoneAuth, AuthCredential? credential) async {
    await firestore
        .collection('vendors')
        .where('username', isEqualTo: usernameController.text)
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        if (isPhoneAuth) {
          signInUserWithPhone(credential!);
        } else {
          signInUser();
        }
        isLoading.value = false;
      } else {
        if (isPhoneAuth) {
          signUpUserWithPhone(credential!);
        } else {
          signUpUser();
        }
        isLoading.value = false;
      }
    }).catchError((e) {
      Get.snackbar('Error', "Failed to fetch details");
    });
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
          "Please make sure you have filled all the details $e");
    } finally {
      isLoading.value = false;
    }
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

  Future<void> signUpUserWithPhone(AuthCredential credential) async {
    try {
      if (emailController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          usernameController.text.isNotEmpty) {
        await firebaseAuth.signInWithCredential(credential);

        currentUserUID.value = firebaseAuth.currentUser!.uid;

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
          "Please make sure you have filled all the details $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInUserWithPhone(AuthCredential credential) async {
    isLoading.value = true;
    try {
      if (emailController.text.isNotEmpty &&
          usernameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        await firebaseAuth.signInWithCredential(credential);
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

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_finder/api/fire_base_auth.dart';
import 'package:parking_finder/utilities/diaglog.dart';

import '../api/authenticate_service.dart';
import '../model/user_model.dart';
import '../utilities/helper_function.dart';

class LoginProvider extends ChangeNotifier {
  int _forgotPasswordTile = 0;
  late String verificationCode;
  late String otpCode;
  bool _buttonDeactive = false;
  int _forgotPasswordTileSelect = 1;
  bool _passwordVisible = false;
  bool _directLogin = false;
  String? pickImagePath;
  String selectGender = "Male";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final nickNameController = TextEditingController();
  final nidController = TextEditingController();
  final addressController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final focusNode = FocusNode();
  final nickNameFocusNode = FocusNode();

  String? dob;
  String? gender;
  List<String> genderList = <String>['Male', 'Female', 'Others'];

  bool get passwordVisible => _passwordVisible;

  set passwordVisible(bool value) {
    _passwordVisible = value;
    notifyListeners();
  }

  int get forgotPasswordTile => _forgotPasswordTile;

  set forgotPasswordTile(int value) {
    _forgotPasswordTile = value;
    notifyListeners();
  }

  bool get directLogin => _directLogin;

  set directLogin(bool value) {
    _directLogin = value;
    notifyListeners();
  }

  int get forgotPasswordTileSelect => _forgotPasswordTileSelect;

  set forgotPasswordTileSelect(int value) {
    _forgotPasswordTileSelect = value;
    notifyListeners();
  }

  bool get buttonDeactive => _buttonDeactive;

  set buttonDeactive(bool value) {
    _buttonDeactive = value;
    notifyListeners();
  }

  getDatePicker(BuildContext context) async {
    DateTime? pickDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now());
    dob = getFormattedDate(pickDate!);
    notifyListeners();
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      cropImage(pickedImage.path);
    }
  }

  cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      cropStyle: CropStyle.circle,
      uiSettings: [],
    );
    if (croppedImage != null) {
      pickImagePath = croppedImage.path;
      notifyListeners();
    }
  }

  void registrationUser(String phoneNumber, LoginProvider loginProvider) {
    Userinfo userinfo = Userinfo(
      username: fullNameController.text,
      // nickName: nickNameController.text,
      contNo: phoneNumber ?? "",
      profileImage: pickImagePath ?? "",
      // isVerified: "",
      licenceImage: "",
      nidImage: "",
      role: "",
    );
    var userModel = UserModel(
      email: emailController.text,
      password: passwordController.text,
      userinfo: [userinfo],
    );
    log("${userModel.toJson()}");
    AuthenticateService.userRegistration(userModel, loginProvider);
  }

  Future<void> logInWithGoogle(
      LoginProvider loginProvider, BuildContext context) async {
    await FirebaseAuthService.signInWithGoogle().then((credential) async {
      AuthenticateService.userLogin(
          credential.user!.email!, '123456', loginProvider);
    }).catchError((onError) {
      showSnackBar("Attention", onError.toString());
      log("error :${onError.toString()}");
    });
  }

  Future<void> createUserWithGoogle(
      LoginProvider loginProvider, BuildContext context) async {
    await FirebaseAuthService.signInWithGoogle().then((credential) async {
      log("Credential ${credential.user.toString()}");
      Userinfo userinfo = Userinfo(
        username: credential.user!.displayName,
        //  nickName: credential.user!.displayName,
        contNo: "01900000000",
        profileImage: credential.user!.photoURL ?? "",
        //isVerified: "",
        licenceImage: "",
        nidImage: "",
        role: "",
      );
      var userModel = UserModel(
        email: credential.user!.email,
        password: '123456',
        userinfo: [userinfo],
      );
      AuthenticateService.userRegistration(userModel, loginProvider);
    }).catchError((onError) {
      showSnackBar("Attention", onError.toString());
      log("error :${onError.toString()}");
    });
  }

  sendVerificationCode(String phoneNumber, BuildContext context) async {
    String phone = "+88$phoneNumber";
    startLoading("Sending Code");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        log("credential : ${credential.smsCode!}");
      },
      verificationFailed: (FirebaseAuthException e) {
        log('Verification Failed : ${e.toString()}');
        showErrorToastMessage("SomeThing Error TryAgain Latter");
        Navigator.pop(context);
      },
      codeSent: (String verificationId, int? resendToken) {
        log("verificationId:$verificationId - resendToken:$resendToken");
        verificationCode = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    EasyLoading.dismiss();
  }

  Future<void> verify(String phoneNumber) async {
    EasyLoading.show(status: 'Verifying, please wait');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCode, smsCode: phoneNumber);
    if (credential.smsCode == phoneNumber) {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        showCorrectToastMessage("Code Correct");

        log("ok");
        EasyLoading.dismiss();
      }).catchError((onError) {
        EasyLoading.dismiss();
        showErrorToastMessage("Code Wrong");
        log("Code Wrong");
      });
    }
  }

  allControllerInit() {
    forgotPasswordTile = 0;
    emailController.text = '';
    passwordController.text = '';
    fullNameController.text = '';
    nickNameController.text = '';
    nidController.text = '';
    addressController.text = '';
  }

  controllerDispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    nickNameController.dispose();
    addressController.dispose();
  }
}

import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as Http;
import 'package:parking_finder/pages/login_page.dart';
import 'package:parking_finder/pages/welcome_page.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/utilities/diaglog.dart';

import '../model/user_model.dart';
import '../pages/password_rest_page.dart';
import '../preference/user_preference.dart';
import '../providers/user_provider.dart';
import 'api_const.dart';
import 'api_error_handler.dart';

class AuthenticateService {
  static Future<void> userLogin(
      String email, String password, LoginProvider loginProvider) async {
    startLoading("Login Wait...");
    var url = Uri.parse('$baseUrl/signin/user');
    Map<String, String> body = {"email": email, "password": password};
    var response = await Http.post(url, body: body);
    if (response.statusCode == 201) {
      log(response.body);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      setLoginStatus(true);
      setJWTToken(jsonResponse['token']);
      setUserInfo(convert.jsonEncode(jsonResponse['user']));
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      loginProvider.buttonDeactive = false;
      loginProvider.allControllerInit();
      Get.offAll(const WelcomePage(),
          transition: Transition.leftToRightWithFade);
    } else {
      EasyLoading.dismiss();
      log(response.statusCode.toString());
      if (response.statusCode == 500) {
        Get.snackbar(
          "Attention",
          "Server Error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      }
      apiErrorHandler(response);

      Future.delayed(
        const Duration(seconds: 1),
        () {
          loginProvider.buttonDeactive = false;
        },
      );
    }
  }

  static Future<void> logout() async {
    setLoginStatus(false);
    setUserInfo('');
    setJWTToken('');
    Future.delayed(
      const Duration(seconds: 1),
      () {
        EasyLoading.dismiss();
        Get.offAll(const WelcomePage(), transition: Transition.fadeIn);
      },
    );
  }

  // static Future<void> registerUser(
  //     UserModel userModel, LoginProvider loginProvider) async {
  //   startLoading("Register Wait...");
  //   var url = Uri.parse('$baseUrl/signup/user');
  //   final headers = <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   };
  //   var body = '''
  // {
  //   "email": "${userModel.email}",
  //   "password": "${userModel.password}",
  //   "userinfo": [
  //     {
  //       "profile_image": "${userModel.userinfo![0].profileImage}",
  //       "username": "${userModel.userinfo![0].username}",
  //       "nick_name": "${userModel.userinfo![0].nickName}",
  //       "cont_no": "${userModel.userinfo![0].contNo}",
  //       "nid_image": "",
  //       "licence_image": "",
  //       "role": "",
  //       "isVerified": ""
  //     }
  //   ]
  // }
  // ''';
  //
  //   final response = await Http.post(
  //     url,
  //     headers: headers,
  //     body: body,
  //   ).catchError((onError) {
  //     EasyLoading.dismiss();
  //     log(onError.toString());
  //   });
  //   if (response.statusCode == 201) {
  //     loginProvider.buttonDeactive = false;
  //     loginProvider.allControllerInit();
  //     log(response.body);
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //     EasyLoading.dismiss();
  //     Fluttertoast.showToast(
  //         msg: "Registration Successful",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     if (loginProvider.directLogin) {
  //       userLogin(userModel.email!, userModel.password!, loginProvider);
  //     }
  //   } else {
  //     loginProvider.buttonDeactive = false;
  //     EasyLoading.dismiss();
  //     log(response.statusCode.toString());
  //     log("Error");
  //     apiErrorHandler(response);
  //   }
  // }

  static Future<void> forgotPassword(
      String email, BuildContext context, LoginProvider loginProvider) async {
    startLoading("Login Wait...");
    var url = Uri.parse('$baseUrl/user/forgot-password');
    Map<String, String> body = {"email": email};
    var response = await Http.post(url, body: body);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      loginProvider.forgotPasswordTile = 1;
      showCorrectToastMessage("Email Send To Your Mail");
    } else {
      EasyLoading.dismiss();
      loginProvider.forgotPasswordTile = 0;

      showSnackBar(
        "Attention",
        'Email not found. Try Again Later\n Or Try to Create A Account!!',
      );
      Get.back();
    }
  }

  static Future<void> verifyForgotCode(String code) async {
    startLoading("Login Wait...");
    var url = Uri.parse('$baseUrl/user/verifyToken');

    Map<String, String> body = {"resetToken": code};
    log("$url : $body");
    var response = await Http.post(url, body: body).catchError((onError) {
      EasyLoading.dismiss();
      log(onError.toString());
    });
    if (response.statusCode == 200) {
      EasyLoading.dismiss();

      showCorrectToastMessage("Code Valid");
      Get.to(const PasswordRestPage(),
          transition: Transition.fade, arguments: code);
    } else {
      EasyLoading.dismiss();
      showErrorToastMessage("OTP not Match. Try Again Later");
    }
  }

  static Future<void> restPassword(
      String password, String resetToken, LoginProvider loginProvider) async {
    startLoading("Login Wait...");
    var url = Uri.parse('$baseUrl/user/resetPassword');

    Map<String, String> body = {
      "resetToken": resetToken,
      "newPassword": password
    };
    log("$url : $body");
    var response = await Http.post(url, body: body).catchError((onError) {
      EasyLoading.dismiss();
      log(onError.toString());
    });
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      showCorrectToastMessage("Password Reset Successfully Valid");
      loginProvider.allControllerInit();
      Get.to(const LoginPage(), transition: Transition.fade);
    } else {
      EasyLoading.dismiss();
      showErrorToastMessage("Ops Reset Failed. Try Again Later");
    }
  }

  static Future<void> userRegistration(
      Map<String, dynamic> userJson, LoginProvider loginProvider) async {
    startLoading("Registration Wait..");
    loginProvider.nameController.text = '';
    loginProvider.emailController.text = '';
    loginProvider.passwordController.text = '';

    var url = Uri.parse('$baseUrl/signup/user');
    log("Data $userJson");
    log("Data $url");
    try {
      final response =
          await Http.post(url, body: userJson).catchError((onError) {
        EasyLoading.dismiss();
        log(onError.toString());
      });
      if (response.statusCode == 201) {
        loginProvider.buttonDeactive = false;
        loginProvider.allControllerInit();
        log(response.body);
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "Registration Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        if (loginProvider.directLogin) {
          userLogin(userJson['email'], userJson["password"], loginProvider);
        }
      } else {
        loginProvider.buttonDeactive = false;
        EasyLoading.dismiss();
        log(response.statusCode.toString());
        log("Error");
        apiErrorHandler(response);
      }
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  static Future<void> updateUser(UserModel userinfo, UserProvider userProvider,
      String email, BuildContext context) async {
    var jwtToken = await getJWTToken();
    // startLoading("Updating Info Wait..");
    Map<String, dynamic> map = userinfo.toJson();
    map.removeWhere((key, value) => value == null);
    // var header = {
    //   "Authorization": "Bearer $jwtToken",
    //   'Content-Type': 'application/json'
    // };

    log(map.toString());

    var url = Uri.parse('$baseUrl/user/update/profile/$email');

    try {
      var response = await Http.patch(url, body: map).catchError((onError) {
        EasyLoading.dismiss();
        log(onError.toString());
      });
      if (response.statusCode == 200) {
        userProvider.clearController();
        log("update Data: ${response.body.toString()}");
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        setUserInfo(convert.jsonEncode(jsonResponse['updatedUser']));
        userProvider.getUserFromSharePref();
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "Update Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        EasyLoading.dismiss();
        log(response.body.toString());
        log(response.statusCode.toString());
        log("Error");
        apiErrorHandler(response);
      }
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future<String> uploadImage(String path) async {
    try {
      List<int> imageBytes = await File(path).readAsBytes();
      String base64Image = base64Encode(imageBytes);
      log("Base:$base64Image");
      var map = <String, dynamic>{};
      map['image'] = base64Image;
      map['key'] = 'f37014febec8af063cef4f686f5928c3';
      var url = Uri.parse(imageUploadUrl);
      var response = await Http.post(url, body: map);
      log(response.body);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse['data']['url'];
    } catch (error) {
      log(error.toString());
      return '';
    }
  }
}

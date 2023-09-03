import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_finder/pages/email_login_page.dart';
import 'package:parking_finder/pages/welcome_page.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:provider/provider.dart';

import '../database/dbhelper.dart';
import '../model/user_model.dart';
import '../services/Auth_service.dart';
import '../utilities/testStyle.dart';
import 'continue_with_phone_page.dart';
import 'createAccount_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Let's you in",
                      style: GoogleFonts.novaOval(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Get.width * .86,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showCorrectToastMessage(
                                  "On Working That,Try Other Options");
                            },
                            label: Text(
                              'Continue with FaceBook',
                              style: continueBlackTextStyle,
                            ),
                            icon: const Icon(FontAwesomeIcons.facebook),
                          ),
                        ),
                        const SizedBox(height: 13),
                        SizedBox(
                          width: Get.width * .86,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _logInWithGoogle();
                            },
                            label: Text(
                              'Continue with Google',
                              style: continueBlackTextStyle,
                            ),
                            icon: const Icon(FontAwesomeIcons.google),
                          ),
                        ),
                        const SizedBox(height: 13),
                        SizedBox(
                          width: Get.width * .86,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.to(const ContinueWithPhonePage(),
                                  transition: Transition.leftToRightWithFade);
                            },
                            label: Text(
                              'Continue with Phone',
                              style: continueBlackTextStyle,
                            ),
                            icon: const Icon(FontAwesomeIcons.phone),
                          ),
                        ),
                        const SizedBox(height: 13),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: .5,
                          width: Get.width * .4,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4),
                          child: Text(
                            "OR",
                            style: continueBlackTextStyle,
                          ),
                        ),
                        Container(
                          height: .5,
                          width: Get.width * .4,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    CupertinoButton(
                      color: AppColors.primaryColor,
                      onPressed: () {
                        Get.to(const EmailLoginPage(),
                            transition: Transition.rightToLeft);
                      },
                      child: const Text("Sign in with Email & Password"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: grayTextStyle,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              const CreateAccountPage(),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: linkTextStyle,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logInWithGoogle() async {
    await AuthService.signInWithGoogle().then((credential) async {
      EasyLoading.show(status: "Wait");
      final userExists = await DbHelper.doesUserExist(credential.user!.uid);
      if (!userExists) {
        log("Creating User Account");
        addUser(credential).then((value) {
          EasyLoading.dismiss();
          Get.to(() => const WelcomePage());
        });
      } else {
        EasyLoading.dismiss();
        Get.to(() => const WelcomePage());
      }
    }).catchError((onError) {
      EasyLoading.dismiss();
      Get.snackbar("Error Occurs", onError.toString(),
          backgroundColor: Colors.red);
      log("error :${onError.toString()}");
    });
  }

  Future<void> addUser(UserCredential credential) async {
    final userModel = UserModel(
      balance: "0.0",
      createdAt: Timestamp.fromDate(DateTime.now()),
      isUserVerified: false,
      accountActive: true,
      isGarageOwner: false,
      uid: AuthService.currentUser!.uid,
      phoneNumber: credential.user!.phoneNumber ?? "0088",
      email: credential.user!.email,
      name: credential.user!.displayName,
      profileUrl: credential.user!.photoURL,
      createTime: Timestamp.fromDate(DateTime.now()),
    );
    log(userModel.toString());
    return await DbHelper.addUser(userModel);
  }
}

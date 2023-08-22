import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_finder/pages/email_login_page.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:provider/provider.dart';

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
                              loginProvider.logInWithGoogle(
                                  loginProvider, context);
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
}

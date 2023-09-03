import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_finder/api/authenticate_service.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../utilities/app_colors.dart';
import '../utilities/testStyle.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments as String;
    final pinController = TextEditingController();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.primaryColor.withOpacity(.6),
      ),
    );
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => WillPopScope(
        onWillPop: () => _onWillPop(context, loginProvider),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarWithTitle(context: context, title: "Forgot Password"),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Lottie.asset(
                  'assets/animation/forgot_passwprd.json',
                  width: 200,
                  height: 200,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    loginProvider.forgotPasswordTile == 1
                        ? "Please Enter a code which send on your mail:- $data "
                        : "Select which contact details should we use to reset your password",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  child: loginProvider.forgotPasswordTile == 0
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _contactTile(Icons.message_outlined, "via SMS",
                                "+8801932610623", loginProvider, 0),
                            _contactTile(Icons.mail, "via Email", data,
                                loginProvider, 1),
                          ],
                        )
                      : Pinput(
                          controller: pinController,
                          length: 6,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.none,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          validator: (s) {
                            log("Valid");
                          },
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (value) {
                            AuthenticateService.verifyForgotCode(value);
                          },
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (loginProvider.forgotPasswordTile == 1) {
                      } else {
                        AuthenticateService.forgotPassword(
                            data, context, loginProvider);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 18),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      loginProvider.forgotPasswordTile == 1
                          ? "Verify"
                          : 'Continue',
                      style: whiteBoldText,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell _contactTile(IconData iconData, String title, String contact,
      LoginProvider loginProvider, int index) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          showErrorToastMessage(message: "Right Now This Feature Not Available");
          return;
        }
        loginProvider.forgotPasswordTileSelect = index;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        height: 90,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(.1),
          border: Border.all(
            color: loginProvider.forgotPasswordTileSelect == index
                ? Colors.blue
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.withOpacity(.1),
              child: Icon(
                iconData,
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    contact,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onWillPop(BuildContext context, LoginProvider loginProvider) {
    loginProvider.forgotPasswordTile = 0;

    Navigator.pop(context);
  }
}

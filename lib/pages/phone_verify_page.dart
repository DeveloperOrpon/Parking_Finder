import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../custom_widget/number_button_code.dart';

class PhoneVerifyPage extends StatelessWidget {
  const PhoneVerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);

    String phone = Get.arguments as String;
    var phoneController = TextEditingController();
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
    loginProvider.sendVerificationCode(phone, context);
    return Scaffold(
      appBar: appBarWithTitle(context: context, title: "Verify Phone"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Code is sent to : $phone",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            Lottie.asset(
              'assets/animation/message_sent.json',
              width: 200,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            IgnorePointer(
              child: Pinput(
                controller: phoneController,
                length: 6,
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                validator: (s) {
                  log("Valid");
                },
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (value) {
                  loginProvider.verify(value);
                },
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NumberButtonPhoneVerify(
                      number: 1,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButtonPhoneVerify(
                      number: 2,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButtonPhoneVerify(
                      number: 3,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NumberButtonPhoneVerify(
                      number: 4,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButtonPhoneVerify(
                      number: 5,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButtonPhoneVerify(
                      number: 6,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NumberButtonPhoneVerify(
                      number: 7,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButtonPhoneVerify(
                      number: 8,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButtonPhoneVerify(
                      number: 9,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // this button is used to delete the last number
                    IconButton(
                      onPressed: () {
                        if (phoneController.text.isEmpty) {
                          return;
                        }
                        phoneController.text = phoneController.text
                            .substring(0, phoneController.text.length - 1);
                      },
                      icon: const Icon(
                        Icons.backspace,
                        color: Colors.red,
                      ),
                      iconSize: 32,
                    ),
                    NumberButtonPhoneVerify(
                      number: 0,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    // this button is used to submit the entered value
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.done_rounded,
                        color: Colors.red,
                      ),
                      iconSize: 32,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

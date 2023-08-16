import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/pages/phone_verify_page.dart';
import 'package:parking_finder/utilities/testStyle.dart';

import '../custom_widget/number_button.dart';
import '../utilities/app_colors.dart';

class ContinueWithPhonePage extends StatelessWidget {
  const ContinueWithPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var phoneController = PhoneNumberInputController(context);

    return Scaffold(
      appBar: appBarWithTitle(context: context, title: "Continue With Phone"),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset(
              'assets/animation/login_phone.json',
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "You'll receive 6 digit code\nto verity next create account",
                  style: grayLowColor,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IgnorePointer(
                child: PhoneNumberInput(
                  errorText: "Enter Phone Number",
                  controller: phoneController,
                  initialCountry: 'BD',
                  locale: 'en',
                  pickContactIcon: const Icon(Icons.phone),
                  countryListMode: CountryListMode.dialog,
                  contactsPickerPosition: ContactsPickerPosition.suffix,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hint: "Phone Number",
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NumberButton(
                      number: 1,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButton(
                      number: 2,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButton(
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
                    NumberButton(
                      number: 4,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButton(
                      number: 5,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButton(
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
                    NumberButton(
                      number: 7,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButton(
                      number: 8,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    NumberButton(
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
                        if (phoneController.phoneNumber.isEmpty) {
                          return;
                        }
                        phoneController.phoneNumber =
                            phoneController.phoneNumber.substring(
                                0, phoneController.phoneNumber.length - 1);
                      },
                      icon: const Icon(
                        Icons.backspace,
                        color: Colors.red,
                      ),
                      iconSize: 32,
                    ),
                    NumberButton(
                      number: 0,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(.5),
                      controller: phoneController,
                    ),
                    // this button is used to submit the entered value
                    IconButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          Get.to(
                            const PhoneVerifyPage(),
                            transition: Transition.fadeIn,
                            arguments: phoneController.phoneNumber,
                          );
                        }
                      },
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

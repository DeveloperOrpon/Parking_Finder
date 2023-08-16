import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_finder/api/authenticate_service.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class PasswordRestPage extends StatelessWidget {
  const PasswordRestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controllerOne = TextEditingController();
    final controllerTwo = TextEditingController();
    final focusNodeOne = FocusNode();
    final focusNodeTwo = FocusNode();
    String resetToken = Get.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Set Your Password",
          style: TextStyle(color: Colors.black45),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.offAll(const LoginPage(), transition: Transition.fade);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
                  child: Text(
                    "Create New Password",
                    style: blackBoldText,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
                  child: Text(
                    "Your new password must be different from previous used passwords.",
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        letterSpacing: 1.3),
                  ),
                ),
                Lottie.asset(
                  'assets/animation/reset-password.json',
                  width: 200,
                  height: 150,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controllerOne,
                    autofocus: false,
                    focusNode: focusNodeOne,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: ("Password"),
                      hintText: '**********',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.lock, color: AppColors.primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fillColor: AppColors.primarySoft,
                      filled: true,
                      //
                    ),
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Input Valid Password Minimum Six(6) digit';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controllerTwo,
                    autofocus: false,
                    focusNode: focusNodeTwo,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: ("Confirm Password"),
                      hintText: '**********',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.lock, color: AppColors.primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fillColor: AppColors.primarySoft,
                      filled: true,
                      //
                    ),
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Input Valid Password Minimum Six(6) digit';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoButton(
                  onPressed: () {
                    focusNodeTwo.unfocus();
                    focusNodeOne.unfocus();
                    if (formKey.currentState!.validate()) {
                      if (controllerOne.text != controllerTwo.text) {
                        showErrorToastMessage("Password Not Match");
                        return;
                      }
                      AuthenticateService.restPassword(
                          controllerOne.text, resetToken, loginProvider);
                    }
                  },
                  color: AppColors.primaryColor,
                  child: const Text('Reset Password'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

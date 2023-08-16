import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/pages/login_page.dart';
import 'package:parking_finder/pages/profileInfo_set_page.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:provider/provider.dart';

import '../custom_widget/simple_appBar.dart';
import '../utilities/diaglog.dart';
import '../utilities/testStyle.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createKey = GlobalKey<FormState>();

    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: simpleAppBar(context),
        body: Form(
          key: createKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 12),
                child: Text(
                  'Welcome Back Mate ! 😁',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: const Text(
                  'Create Your Account',
                  style: TextStyle(
                      color: Colors.black, fontSize: 30, height: 150 / 100),
                ),
              ),
              // Section 2 - Form
              // Email
              TextFormField(
                controller: loginProvider.emailController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'youremail@email.com',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.email, color: AppColors.primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
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
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Input Valid Email like example@example.com';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Password
              TextFormField(
                controller: loginProvider.passwordController,
                autofocus: false,
                obscureText: !loginProvider.passwordVisible,
                decoration: InputDecoration(
                  hintText: '**********',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child:
                        Icon(Icons.key_outlined, color: AppColors.primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      loginProvider.passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable

                      loginProvider.passwordVisible =
                          !loginProvider.passwordVisible;
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.length < 6) {
                    return 'Input Valid Password with Six(6) digit';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        value: loginProvider.directLogin,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          loginProvider.directLogin =
                              !loginProvider.directLogin;
                        },
                      ),
                    ),
                    Text(
                      "Remember me",
                      style: continueBlackTextStyle,
                    )
                  ],
                ),
              ),
              // Sign In button
              ElevatedButton(
                onPressed: () {
                  if (createKey.currentState!.validate()) {
                    Get.to(const ProfileInformationSetPage(),
                        transition: Transition.rightToLeftWithFade);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Sign Up',
                  style: whiteBoldText,
                ),
              ),

              ///
              SizedBox(height: Get.height * .1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: .5,
                    width: Get.width * .2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4),
                    child: Text(
                      "OR Continue With",
                      style: continueBlackTextStyle,
                    ),
                  ),
                  Container(
                    height: .5,
                    width: Get.width * .2,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: Get.height * .03),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        splashColor: AppColors.primaryColor,
                        onPressed: () {
                          showCorrectToastMessage(
                              "On Working That,Try Other Options");
                        },
                        icon: const Icon(
                          FontAwesomeIcons.facebook,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        splashColor: AppColors.primaryColor,
                        onPressed: () {},
                        icon: const Icon(
                          FontAwesomeIcons.phone,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        splashColor: AppColors.primaryColor,
                        onPressed: () {
                          log("Google LogIn");
                          loginProvider.createUserWithGoogle(
                              loginProvider, context);
                        },
                        icon: const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height * .03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: grayTextStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAll(
                        const LoginPage(),
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                    child: Text(
                      "Sign in",
                      style: linkTextStyle,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

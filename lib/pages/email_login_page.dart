import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:parking_finder/utilities/appConst.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:provider/provider.dart';

import '../api/authenticate_service.dart';
import '../custom_widget/simple_appBar.dart';
import '../utilities/testStyle.dart';
import 'forgot_password_page.dart';

class EmailLoginPage extends StatelessWidget {
  const EmailLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginKey = GlobalKey<FormState>();
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => WillPopScope(
        onWillPop: () => _onWillPop(context, loginProvider),
        child: Scaffold(
          appBar: simpleAppBar(context),
          body: Form(
            key: loginKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Section 1 - Header
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 12),
                  child: Text(
                    'Welcome Back Mate ! 😁',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    'login and explore the $appName',
                    style: TextStyle(
                        color: AppColors.primaryColor.withOpacity(0.7),
                        fontSize: 19,
                        height: 150 / 100),
                  ),
                ),
                // Section 2 - Form
                // Email
                TextFormField(
                  controller: loginProvider.emailController,
                  autofocus: false,
                  focusNode: loginProvider.emailFocusNode,
                  decoration: InputDecoration(
                    hintText: 'youremail@email.com',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.email, color: AppColors.primaryColor),
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
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input Your Email';
                    }
                    if (!value.contains("@")) {
                      return 'Input Valid Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password
                TextFormField(
                  controller: loginProvider.passwordController,
                  autofocus: false,
                  focusNode: loginProvider.passFocusNode,
                  obscureText: !loginProvider.passwordVisible,
                  decoration: InputDecoration(
                    hintText: '**********',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.key_outlined,
                          color: AppColors.primaryColor),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginProvider.passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        loginProvider.passwordVisible =
                            !loginProvider.passwordVisible;
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Input Valid Password Minimum Six(6) digit';
                    }
                    return null;
                  },
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      loginProvider.emailFocusNode.unfocus();
                      loginProvider.passFocusNode.unfocus();
                      if (loginProvider.emailController.text.isEmpty) {
                        showSnackBar(
                          "Information",
                          "Please provide your email address",
                        );
                        return;
                      }
                      if (loginProvider.emailController.text.contains('@') ||
                          loginProvider.emailController.text.length > 6) {
                        Get.to(const ForgotPage(),
                            transition: Transition.leftToRightWithFade,
                            arguments: loginProvider.emailController.text);
                        return;
                      }
                      showSnackBar(
                        "Information",
                        "Please provide valid email address",
                      );
                      return;
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryColor.withOpacity(0.1),
                    ),
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.withOpacity(0.5),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                // Sign In button
                ElevatedButton(
                  onPressed: loginProvider.buttonDeactive
                      ? null
                      : () {
                          loginProvider.emailFocusNode.unfocus();
                          loginProvider.passFocusNode.unfocus();
                          if (loginKey.currentState!.validate()) {
                            loginProvider.buttonDeactive = true;
                            AuthenticateService.userLogin(
                                loginProvider.emailController.text,
                                loginProvider.passwordController.text,
                                loginProvider);
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
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'poppins'),
                  ),
                ),
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
                            color: Colors.black87,
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
                            loginProvider.logInWithGoogle(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onWillPop(BuildContext context, LoginProvider loginProvider) {
    loginProvider.allControllerInit();
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

void showErrorToastMessage({String message = '"Something Error"'}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showCorrectToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

showSnackBar(String title, String body) {
  Get.showSnackbar(GetSnackBar(
    title: title,
    message: body,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 1),
    backgroundGradient:
        LinearGradient(colors: [AppColors.primaryColor, Colors.amber]),
  ));
}

startLoading(String text) async {
  await EasyLoading.show(
    dismissOnTap: false,
    status: text,
    indicator: Image.asset(
      'assets/image/loading.gif',
      color: AppColors.primaryColor,
      width: 120,
      height: 80,
      fit: BoxFit.fitWidth,
    ),
  );
}

Padding inputField(
    {required TextEditingController controller,
    required String hintText,
    required bool isPrefix,
    IconData? iconPreFix}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        suffixIcon: isPrefix
            ? Icon(
                iconPreFix,
                color: Colors.grey,
              )
            : null,
      ),
      validator: (value) {
        if (value!.length < 4) {
          return "Input $hintText minimum Four(4) digit";
        }
        return null;
      },
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true;
}

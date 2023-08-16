import 'dart:convert' as convert;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as Http;

apiErrorHandler(Http.Response response) {
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  log("Error : ${jsonResponse['msg']}");
  log("Login Error");

  if (response.statusCode == 401) {
    Get.snackbar(
      "Warning",
      jsonResponse["msg"] ?? "Session Expired",
      colorText: Colors.white,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  } else if (response.statusCode == 404) {
    Get.snackbar(
      "User Not Found",
      jsonResponse["msg"],
      colorText: Colors.white,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  } else if (response.statusCode > 499) {
    Get.snackbar(
      "Attention",
      jsonResponse["msg"] ?? "Server Error, Try Again after sometimes",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  } else if (response.statusCode == 400) {
    Get.snackbar(
      "Attention",
      jsonResponse["msg"] ?? "User already exist",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  } else if (response.statusCode == 500) {
    Get.snackbar(
      "Attention",
      "Server Error",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  } else {
    Get.snackbar(
      "Warning",
      jsonResponse["msg"] ?? "Something went to wrong",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }
}

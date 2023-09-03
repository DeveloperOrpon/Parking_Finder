import 'dart:convert' as convert;
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:parking_finder/database/dbhelper.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/services/Auth_service.dart';
import 'package:parking_finder/utilities/diaglog.dart';

import '../api/api_const.dart';
import '../model/vicModel.dart';
import '../preference/user_preference.dart';

class BookingProvider extends ChangeNotifier {
  String selectImage = 'assets/image/motoCar.png';
  String bikeCar = 'assets/image/motoCar.png';
  String carCar = 'assets/image/carCar.png';
  String otherCar = 'assets/image/othersCar.png';
  String? selectStartTime;
  String? selectEndTime;
  final formKey = GlobalKey<FormState>();
  late String selectToTalTime;
  late TextEditingController carNameController;
  late TextEditingController carNamePlateController;
  late TextEditingController carModelController;
  late FocusNode carNameFocus;
  late FocusNode carNamePlateFocus;
  late FocusNode carModelFocus;
  String _vehicleType = '4 Wheeler';

  String get vehicleType => _vehicleType;

  set vehicleType(String value) {
    _vehicleType = value;
    notifyListeners();
  }

  String getVehicleImage(String type) {
    if (type == '4 Wheeler') {
      return carCar;
    }
    if (type == '2 Wheeler') {
      return bikeCar;
    }
    return otherCar;
  }

  showDatePickerDialog(BuildContext context, bool isSelectStartTime) async {
    log("showTimePicker");
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      var df = DateFormat("h:mm a");
      var dt = df.parse(pickedTime.format(context));
      isSelectStartTime
          ? selectStartTime
          : selectEndTime = DateFormat('HH:mm').format(dt);
      log(pickedTime.hour.toString());
      notifyListeners();
    }
  }

  selectImageVehicle(int index) {
    index == 0
        ? selectImage = carCar
        : index == 1
            ? selectImage = bikeCar
            : selectImage = otherCar;
    notifyListeners();
  }

  controllerDispose() {
    carNameFocus.unfocus();
    carNamePlateFocus.unfocus();
    carModelFocus.unfocus();
    carNameController.dispose();
    carNamePlateController.dispose();
    carModelController.dispose();
  }

  controllerInit() {
    log("Int");

    carNameFocus = FocusNode();
    carNamePlateFocus = FocusNode();
    carModelFocus = FocusNode();
    carNameController = TextEditingController();
    carNamePlateController = TextEditingController();
    carModelController = TextEditingController();
  }

  Future<void> addVehicle(
      UserProvider userProvider, BuildContext context) async {
    startLoading("Please Wait");
    List<Map<String, dynamic>> myVehiclesMap = [];
    VicModel vicModel = VicModel(
      isDefault: false,
      model: carModelController.text,
      plateNumber: carNamePlateController.text,
      vehicle: carNameController.text,
      vehicleType: vehicleType,
      vId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    try {
      await DbHelper.addVehicle(AuthService.currentUser!.uid, vicModel);
      EasyLoading.dismiss();
      carNameController.text = '';
      carNamePlateController.text = '';
      carModelController.text = '';
      Fluttertoast.showToast(
          msg: 'Car Added Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (error) {
      log("ERROR ${error.toString()}");
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> defaultCar(VicModel vicList, UserProvider userProvider) async {
    List<Map<String, dynamic>> myVehiclesMap = [];
    // log("v: ${userProvider.user!.vicList!.firstWhere((element) => element.vId == vicList.vId).toJson()}");
    // if (userProvider.user!.vicList!.isNotEmpty) {
    //   for (VicList vic in userProvider.user!.vicList!) {
    //     if (vic.vId == vicList.vId) {
    //       vic.isDefault = true;
    //     } else {
    //       vic.isDefault = false;
    //     }
    //     myVehiclesMap.add(vic.toJson());
    //   }
    // }
    Map<String, dynamic> updateMap = {"vic_list": myVehiclesMap};
    try {
      Response response = await Dio().patch(
          '$baseUrl/user/update/profile/${userProvider.user!.email}',
          data: updateMap);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = response.data;
        setUserInfo(convert.jsonEncode(jsonResponse['updatedUser']));
        // userProvider.getUserFromSharePref();
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "Vehicle Default Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioException catch (error) {
      log("ERROR ${error.toString()}");
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

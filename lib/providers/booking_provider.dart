import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingProvider extends ChangeNotifier {
  String selectImage = 'assets/image/motoCar.png';
  String bikeCar = 'assets/image/motoCar.png';
  String carCar = 'assets/image/carCar.png';
  String otherCar = 'assets/image/othersCar.png';
  String? selectStartTime;
  String? selectEndTime;
  late String selectToTalTime;
  late TextEditingController carNameController;
  late TextEditingController carNamePlateController;
  late TextEditingController carModelController;
  late FocusNode carNameFocus;
  late FocusNode carNamePlateFocus;
  late FocusNode carModelFocus;

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
}

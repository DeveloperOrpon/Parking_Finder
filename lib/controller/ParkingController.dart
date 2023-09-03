import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:parking_finder/database/dbhelper.dart';
import 'package:parking_finder/model/booking_model.dart';
import 'package:parking_finder/model/garage_model.dart';
import 'package:parking_finder/model/money_transsion_model.dart';
import 'package:parking_finder/model/notification_model.dart';
import 'package:parking_finder/model/parking_model.dart';
import 'package:parking_finder/services/Auth_service.dart';

import '../model/vicModel.dart';
import '../utilities/diaglog.dart';

class ParkingController extends GetxController with StateMixin<List<dynamic>> {
  RxList<VicModel> carList = RxList<VicModel>();
  Rxn<VicModel> selectCar = Rxn<VicModel>();

  @override
  void onInit() {
    getAllParkingPoint();
    getActiveParkingPoint();
    getAllCar();
    super.onInit();
  }

  getParkingMyGarage(ParkingModel parkingModel) async {
    log("message");
    final value = await DbHelper.getGarageInfoById(parkingModel.gId);
    final pValue = await DbHelper.getParkingInfoById(parkingModel.parkId!);
    GarageModel garageModel = GarageModel.fromMap(value.data()!);
    ParkingModel parking = ParkingModel.fromMap(pValue.data()!);
    change([garageModel, parking], status: RxStatus.success());
  }

  getAllCar() {
    DbHelper.getAllVehicle(AuthService.currentUser!.uid).listen((event) {
      carList.value = List.generate(event.docs.length,
              (index) => VicModel.fromJson(event.docs[index].data()));
      selectCar.value = carList.value
          .firstWhereOrNull((element) => element.isDefault ?? false);
      if (selectCar.value == null && carList.value.isNotEmpty) {
        selectCar.value = carList.value[0];
      }
    });
  }

  RxList<ParkingModel> activeParkingList = RxList<ParkingModel>();
  RxList<ParkingModel> parkingList = RxList<ParkingModel>();

  getActiveParkingPoint() {
    DbHelper.getAllParkingPoint().listen((snapshot) {
      activeParkingList.value = parkingList.value
          .where((element) => element.isActive == true)
          .toList();
    });
  }

  getAllParkingPoint() {
    DbHelper.getAllParkingPoint().listen((snapshot) {
      parkingList.value = List.generate(snapshot.docs.length,
              (index) => ParkingModel.fromMap(snapshot.docs[index].data()));
    });
  }

  void addBookingInfo(BookingModel bookingModel) async {
    startLoading("Wait..");
    var gMap = await DbHelper.getGarageInfoById(bookingModel.garageGId);
    GarageModel garageModel = GarageModel.fromMap(gMap.data()!);
    FloorModel floorModel = garageModel.floorDetails!.firstWhere(
            (element) =>
        element.floorNumber == bookingModel.spotInformation.floor);
    log("old : ${floorModel.toJson()}");
    for (int i = 0; i < floorModel.spotInformation!.length; i++) {
      if (floorModel.spotInformation![i].spotId ==
          bookingModel.spotInformation.spotId) {
        floorModel.spotInformation!.remove(floorModel.spotInformation![i]);
        floorModel.spotInformation!.insert(i, bookingModel.spotInformation);
      }
    }
    for (int i = 0; i < garageModel.floorDetails!.length; i++) {
      if (garageModel.floorDetails![i].floorNumber ==
          bookingModel.spotInformation.floor) {
        garageModel.floorDetails!.remove(garageModel.floorDetails![i]);
        garageModel.floorDetails!.insert(i, floorModel);
      }
    }
    final transactionModel = MoneyTransactionModel(
      tId: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      bId: bookingModel.bId,
      pId: bookingModel.parkingPId,
      tType: "Custom",
      amount: bookingModel.cost,
      vat: '0',
      userId: AuthService.currentUser!.uid,
      gOwnerId: garageModel.ownerUId,
      tGenerateTime: Timestamp.now(),);
    final notificationModel = NotificationModelOfUser(
        title: "Booking Parking Request Sent",
        id: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        otherId: bookingModel.bId,
        type: 'booking',
        notificationTime: Timestamp.now());
    log("new : ${garageModel.toMap()}");
    try {
      await DbHelper.addBooking(
          garageModel.gId, garageModel.toMap(), bookingModel, transactionModel,
          notificationModel);
      EasyLoading.dismiss();
      showCorrectToastMessage("Booking Request Is Sent Wait For Confirmation");
    } on FirebaseException catch (error) {
      log(error.toString());
      EasyLoading.dismiss();
      showErrorToastMessage(message: error.toString());
    }
  }

}

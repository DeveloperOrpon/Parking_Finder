import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/model/parking_model.dart';
import 'package:parking_finder/model/user_model.dart';
import 'package:parking_finder/utilities/diaglog.dart';

import '../database/dbhelper.dart';
import '../model/garage_model.dart';
import '../model/notification_model.dart';
import '../pages/parking_information_page.dart';
import '../services/Auth_service.dart';
import '../utilities/appConst.dart';
import '../utilities/app_colors.dart';
import '../utilities/testStyle.dart';

class GarageController extends GetxController {
  ///Rx Variable
  ///firebase
  Rxn<UserModel> user = Rxn<UserModel>();
  RxList<NotificationModelOfUser> allNotificationModel =
      RxList<NotificationModelOfUser>([]);
  final Set<Marker> markers = {};
  RxInt selectFloorIndex = RxInt(1);
  RxList<ParkingModel> allActiveParking = RxList<ParkingModel>([]);

  RxList<GarageModel> garageList = RxList<GarageModel>([]);
  RxList<GarageModel> activeGarageList = RxList<GarageModel>([]);
  RxList<GarageModel> myActiveGarages = RxList<GarageModel>([]);
  RxList<GarageModel> myUnActiveGarages = RxList<GarageModel>([]);
  RxBool isShowActiveGarage = RxBool(true);
  final floorController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    getUserInfo();

    getAllGarageInfo();
    getMyGarageInfo();
    getMyUnActiveGarageInfo();
    getAllActiveParking();
    getAllUserNotification();
    super.onInit();
  }

  getAllUserNotification() {
    DbHelper.getUserNotification(AuthService.currentUser!.uid).listen((event) {
      allNotificationModel.value = List.generate(
          event.docs.length,
          (index) =>
              NotificationModelOfUser.fromMap(event.docs[index].data()!));
    });
  }

  ///garage info
  getAllGarageInfo() {
    garageList.value = [];
    DbHelper.getAllGarageInfo().listen((snapshot) {
      garageList.value = List.generate(snapshot.docs.length,
          (index) => GarageModel.fromMap(snapshot.docs[index].data()));
      activeGarageList.value =
          garageList.value.where((element) => element.isActive).toList();
      log("All Garage : ${garageList.length}");
    });
  }

  getMyGarageInfo() {
    myActiveGarages.value = [];
    DbHelper.getAllGarageInfo().listen((snapshot) {
      myActiveGarages.value = garageList
          .where((element) =>
              element.ownerUId == AuthService.currentUser!.uid &&
              element.isActive)
          .toList();
    });
  }

  getMyUnActiveGarageInfo() {
    myUnActiveGarages.value = [];
    DbHelper.getAllGarageInfo().listen((snapshot) {
      myUnActiveGarages.value = garageList
          .where((element) =>
              !element.isActive &&
              element.ownerUId == AuthService.currentUser!.uid)
          .toList();
    });
  }

  void deleteAGarage(GarageModel garageModel) {
    startLoading('Deleting..');
    DbHelper.deleteAGarage(garageModel.gId).then((value) {
      EasyLoading.dismiss();
      showCorrectToastMessage('Garage Delete Successfully');
    }).catchError((onError) {
      EasyLoading.dismiss();
      showErrorToastMessage();
    });
  }

  Future<List<geocoding.Placemark>> getLatLngToAddress(LatLng latLng) async {
    List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude);
    return placemarks;
  }

  RxList<dynamic> garageFacility = RxList<String>([]);

  addFacilityFunction(String s) {
    if (garageFacility.contains(s)) {
      garageFacility.remove(s);
    } else {
      garageFacility.add(s);
    }
  }

  ///get all parking data
  getAllActiveParking() {
    allActiveParking.value = [];
    DbHelper.getAllParkingPoint().listen((snapshot) {
      log('all Parking : ${snapshot.docs[0].data()}');
      List<ParkingModel> temp = List.generate(snapshot.docs.length,
          (index) => ParkingModel.fromMap(snapshot.docs[index].data()));
      allActiveParking.value =
          temp.where((element) => element.isActive).toList();
    });
  }

  Future<void> getUserInfo() async {
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      user.value = UserModel.fromMap(snapshot.data()!);
    });
  }

  Set<Marker> getMarkers(
      BitmapDescriptor parkingBitmap, BuildContext context, List list) {
    for (ParkingModel parkingModel in allActiveParking.value) {
      if (parkingModel.isActive) {
        markers.add(
          Marker(
              markerId: MarkerId(parkingModel.parkId!),
              position: LatLng(double.parse(parkingModel.lat),
                  double.parse(parkingModel.lon)),
              infoWindow: InfoWindow(
                title: parkingModel.title,
                snippet: parkingModel.parkingCost + currencySymbol,
              ),
              icon: parkingBitmap,
              onTap: () {
                log("Tap");
                showParkingInfoInBottomSheet(context, parkingModel);
              }),
        );
      }
    }
    return markers;
  }

  void showParkingInfoInBottomSheet(
      BuildContext context, ParkingModel parkingModel) {
    var dt = DateTime.now();
    log("Time ${dt.hour}");
    bool isOpenFull = false;
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 10,
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 1),
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: isOpenFull ? Get.height * .66 : Get.height * .30,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: ListView(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: Get.width * .3,
                      right: Get.width * .3),
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                height: Get.height * .2,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                  text: parkingModel.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      ' ${parkingModel.parkingCost}$currencySymbol/hr',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                        ),
                        Text(
                          parkingModel.address,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Icon(
                                      Icons.local_parking,
                                      color: Colors.white,
                                    )),
                                Entry(
                                    xOffset: -50,
                                    delay: Duration(milliseconds: 300),
                                    duration: Duration(milliseconds: 700),
                                    child:
                                        Text(parkingModel.capacity + " Sopt")),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                        right: 6, left: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.white,
                                    )),
                                const Entry(
                                  xOffset: -50,
                                  delay: Duration(milliseconds: 300),
                                  duration: Duration(milliseconds: 700),
                                  child: Text("10.44 k/m"),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                            )),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            height: Get.height * .18,
                            width: Get.width * .24,
                            fit: BoxFit.cover,
                            imageUrl: "${parkingModel.parkImageList[0]}",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    SpinKitSpinningLines(
                              color: AppColors.primaryColor,
                              size: 50.0,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      color: AppColors.primaryColor,
                      child: Text(
                        isOpenFull ? "BOOK SPOT" : 'SEE MORE INFORMATION',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (isOpenFull) {
                          Get.to(
                              ParkingInformationPage(
                                parkingModel: parkingModel,
                              ),
                              transition: Transition.topLevel);
                        } else {
                          isOpenFull = !isOpenFull;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                  future: DbHelper.getUserInfoMap(parkingModel.uId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error = ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CupertinoActivityIndicator(
                        radius: 30,
                        color: AppColors.primaryColor,
                      );
                    }
                    final userModel =
                        UserModel.fromMap(snapshot!.data!.data()!);
                    return AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      height: isOpenFull ? Get.height * .4 : 0,
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Working Hours",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    parkingModel.openTime,
                                    style: blackBoldText,
                                  ),
                                  Text(
                                    "Open Now",
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  )
                                ],
                              ),
                            ),
                            const Divider(color: Colors.grey),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Contacts Information",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(CupertinoIcons.phone),
                                      const SizedBox(width: 8),
                                      Text(
                                        userModel.phoneNumber,
                                        style: blackBoldText,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(CupertinoIcons.mail),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${userModel.email}",
                                        style: TextStyle(
                                            color: AppColors.primaryColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(color: Colors.grey),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Full Address",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        Text(
                                          "${parkingModel.address}",
                                          style: blackBoldText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    color: Colors.blue,
                                    child: const Text(
                                      'All INFORMATION',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      log("All INFORMATION");
                                      Get.to(
                                          ParkingInformationPage(
                                            parkingModel: parkingModel,
                                          ),
                                          transition: Transition.topLevel);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        );
      }),
    );
  }
}

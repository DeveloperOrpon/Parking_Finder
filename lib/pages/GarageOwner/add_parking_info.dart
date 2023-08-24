import 'dart:developer';
import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_koi/pages/redirect_page.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';
import '../database/dbhelper.dart';
import '../model/garage_model.dart';
import '../model/parking_model.dart';
import '../provider/mapProvider.dart';
import '../services/Auth_service.dart';
import '../utils/const.dart';
import '../utils/helper_function.dart';

class AddParkingInfoPage extends StatefulWidget {
  const AddParkingInfoPage({Key? key}) : super(key: key);

  @override
  State<AddParkingInfoPage> createState() => _AddParkingInfoPageState();
}

class _AddParkingInfoPageState extends State<AddParkingInfoPage> {
  final controller = Get.find<HomeController>();
  var formKey = GlobalKey<FormState>();
  bool buttonDisable = false;
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var capacityController = TextEditingController();
  var costController = TextEditingController();
  late MapProvider provider;
  GarageModel? garageModel;
  String? parkingCategoryName;
  List<String> selectImages = [];
  List<String> selectFacility = [];
  List<String> selectVehicleType = [];
  List<String> listOfFacility = [
    "CC TV",
    "Guard",
    "Indoor",
    "Car Wash",
    "24/7 Service"
  ];
  List<String> parkingVehicleType = [
    'MotorCycle',
    'Private Car',
    "Buss",
    "BiCycle",
    'Mini Bus',
    'Small Vehicle'
  ];
  final selectPosition = Get.arguments as LatLng;

  @override
  void didChangeDependencies() {
    provider = Provider.of<MapProvider>(context);
    garageModel = provider.myActiveGarages[0];
    parkingCategoryName = garageModel!.parkingCategoryList[0];
    if (provider.userModel == null) {
      AuthService.logout();
      Get.to(const RedirectPage());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking Place Additional Information"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Enter Place Name",
                        helperStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Name";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Enter Full Address",
                        helperStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Address";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: capacityController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Enter Parking Capacity",
                        helperStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Capacity";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: costController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Enter Rent Cost $takaSymbol per hour",
                        helperStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Cost";
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Select Facility",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ChipsChoice<String>.multiple(
                    value: selectFacility,
                    onChanged: (val) => setState(() => selectFacility = val),
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: listOfFacility,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Select Vehicle Type",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ChipsChoice<String>.multiple(
                    value: selectVehicleType,
                    onChanged: (val) => setState(() => selectVehicleType = val),
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: parkingVehicleType,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<GarageModel>(
                    decoration: const InputDecoration(
                        labelText: 'Garage Selection',
                        border: OutlineInputBorder()),
                    value: garageModel,
                    items: provider.myActiveGarages.map((gModel) {
                      return DropdownMenuItem(
                          key: UniqueKey(),
                          value: gModel,
                          child: Text(
                            "${gModel.name} ${gModel.address} (${gModel.totalSpace})",
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        parkingCategoryName = value!.parkingCategoryList[0];
                        garageModel = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    key: UniqueKey(),
                    decoration: const InputDecoration(
                        labelText: 'Parking Category Selection',
                        border: OutlineInputBorder()),
                    value: parkingCategoryName,
                    items: garageModel!.parkingCategoryList.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (category) {
                      setState(() {
                        parkingCategoryName = category;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text("Select Image Source"),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text("Camera"),
                                  onPressed: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    final pickedImage = await _picker.pickImage(
                                        source: ImageSource.camera);
                                    if (pickedImage != null) {
                                      setState(() {
                                        selectImages.add(pickedImage.path);
                                      });
                                    }
                                    Get.back();
                                  },
                                ),
                                CupertinoDialogAction(
                                    child: const Text("Gallery"),
                                    onPressed: () async {
                                      final ImagePicker _picker = ImagePicker();
                                      final pickedImage =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedImage != null) {
                                        setState(() {
                                          selectImages.add(pickedImage.path);
                                        });
                                      }
                                      Get.back();
                                    }),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border.all(
                                color: Colors.orange,
                                width: 1,
                              )),
                          child: const Icon(Icons.add),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: selectImages.map((e) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.orange,
                                    width: 1,
                                  )),
                                  child: Image.file(
                                    File(e),
                                    width: 90,
                                    height: 90,
                                  ),
                                ),
                                Positioned(
                                  right: -15,
                                  top: -10,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectImages.remove(e);
                                        });
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.delete_solid,
                                        color: Colors.red,
                                        size: 32,
                                      )),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CupertinoButton.filled(
                  onPressed: buttonDisable
                      ? null
                      : () {
                          _savePost();
                        },
                  child: const Text(
                    "Add Post For Review",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _savePost() async {
    if (num.parse(garageModel!.totalSpace).toInt() -
            num.parse(capacityController.text.toString()).toInt() <
        0) {
      Get.snackbar("Information", "Not Enough Space In This Garage",
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red);
      return;
    }
    if (formKey.currentState!.validate() &&
        selectImages.isNotEmpty &&
        num.parse(garageModel!.totalSpace).toInt() -
                num.parse(capacityController.text.toString()).toInt() >=
            0) {
      EasyLoading.show(status: "Wait Data Uploading.....");
      setState(() {
        buttonDisable = true;
      });

      bool isAdmin = await getAdminStatus();
      String title = nameController.text;
      String address = addressController.text;
      String capacity = capacityController.text;
      String parkingCost = costController.text;
      var parkingDownloadUrlList = [];
      try {
        for (String url in selectImages) {
          String downloadUrl = await DbHelper.uploadImage(url);
          parkingDownloadUrlList.add(downloadUrl);
        }
        final parkingModel = ParkingModel(
          uId: AuthService.currentUser!.uid,
          parkId: DateTime.now().microsecondsSinceEpoch.toString(),
          address: address,
          phone: isAdmin ? '+00000' : provider.userModel!.phoneNumber,
          parkingCost: parkingCost,
          facilityList: selectFacility,
          parkImageList: parkingDownloadUrlList,
          capacity: capacity,
          capacityRemaining: capacity,
          lon: selectPosition.longitude.toString(),
          lat: selectPosition.latitude.toString(),
          title: title,
          gId: garageModel!.gId,
          selectVehicleTypeList: selectVehicleType,
          parkingCategoryName: parkingCategoryName!,
          createTime: Timestamp.fromDate(DateTime.now()),
        );

        _clearForm();
        await DbHelper.addParkingLocation(parkingModel, garageModel!)
            .catchError((onError) {
          EasyLoading.dismiss();
          setState(() {
            buttonDisable = false;
          });
          log(onError.toString());
        });
        setState(() {
          buttonDisable = false;
        });
        Get.snackbar(
          "Information",
          "Your Place Added Successfully",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );
        EasyLoading.dismiss();
      } catch (error) {
        EasyLoading.dismiss();
        setState(() {
          buttonDisable = false;
        });
        log(error.toString());
      }
    } else {
      Get.snackbar("Information", "Please Select All Field",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red);
    }
  }

  void _clearForm() {
    nameController.clear();
    costController.clear();
    capacityController.clear();
    addressController.clear();
    selectFacility = [];
    selectImages = [];
    setState(() {});
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/database/dbhelper.dart';
import 'package:parking_finder/model/garage_model.dart';
import 'package:parking_finder/utilities/diaglog.dart';

import '../../api/authenticate_service.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/testStyle.dart';

class UpdateGaragePage extends StatefulWidget {
  final GarageModel garageModel;
  const UpdateGaragePage({Key? key, required this.garageModel})
      : super(key: key);

  @override
  State<UpdateGaragePage> createState() => _UpdateGaragePageState();
}

class _UpdateGaragePageState extends State<UpdateGaragePage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final totalSpaceController = TextEditingController();
  final adInfoController = TextEditingController();
  final floorController = TextEditingController();
  String? selectImage;
  bool isSubmitBtnActive = true;
  final categoryList = [];
  final garageController = Get.put(GarageController());

  @override
  void initState() {
    nameController.text = widget.garageModel.name;
    addressController.text = widget.garageModel.address;
    totalSpaceController.text = widget.garageModel.totalSpace;
    adInfoController.text = widget.garageModel.additionalInformation;
    floorController.text = widget.garageModel.totalFloor;
    List<String> list = [];
    for (String val in widget.garageModel.facilities!) {
      list.add(val);
    }
    garageController.garageFacility.value = list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: CupertinoColors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text(
            "Update Garage Information",
            style: continueBlackTextStyle,
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: InputBorder.none,
                    labelText: "Enter Garage Name",
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Fill Garage Name";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: addressController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: InputBorder.none,
                    labelText: "Enter Garage Address",
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Fill Garage address";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  minLines: 4,
                  maxLines: 10,
                  keyboardType: TextInputType.text,
                  controller: adInfoController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: InputBorder.none,
                    labelText: "Additional Information",
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "enter additionalInformation";
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          showErrorToastMessage(
                              message:
                                  "Update This Filed From Slot Information Page");
                        },
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: floorController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none,
                            labelText: "Floor",
                            labelStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Fill Garage Floor";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: totalSpaceController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: InputBorder.none,
                          labelText: "Total Space",
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Fill Total Space";
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 7),
              Text("Does your Parking Spot have any these?",
                  style: blackBoldSmallText),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        garageController.addFacilityFunction("CCTV");
                      },
                      child: Obx(() {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                garageController.garageFacility.contains("CCTV")
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.camera,
                                color: Colors.white,
                              ),
                              Text("CCTV", style: whiteBold14Text),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        garageController.addFacilityFunction("Lighting");
                      },
                      child: Obx(() {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: garageController.garageFacility
                                    .contains("Lighting")
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.lightbulb,
                                color: Colors.white,
                              ),
                              Text("Lighting", style: whiteBold14Text)
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        garageController.addFacilityFunction("Security Guard");
                      },
                      child: Obx(() {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: garageController.garageFacility
                                    .contains("Security Guard")
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.security,
                                color: Colors.white,
                              ),
                              Text("Security Guard", style: whiteBold14Text),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        garageController.addFacilityFunction("24/7 Service");
                      },
                      child: Obx(() {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: garageController.garageFacility
                                    .contains("24/7 Service")
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.lock_open,
                                color: Colors.white,
                              ),
                              Text("24/7 Service", style: whiteBold14Text)
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        garageController.addFacilityFunction("Covered Parking");
                      },
                      child: Obx(() {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: garageController.garageFacility
                                    .contains("Covered Parking")
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.car_detailed,
                                color: Colors.white,
                              ),
                              Text("Covered Parking", style: whiteBold14Text),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        garageController
                            .addFacilityFunction("Roadside Parking");
                      },
                      child: Obx(() {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: garageController.garageFacility
                                    .contains("Roadside Parking")
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_road,
                                color: Colors.white,
                              ),
                              Text("Roadside Parking", style: whiteBold14Text)
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  final ImagePicker picker = ImagePicker();
                                  final pickedImage = await picker.pickImage(
                                      source: ImageSource.camera);
                                  if (pickedImage != null) {
                                    setState(() {
                                      selectImage = (pickedImage.path);
                                    });
                                  }
                                  Get.back();
                                },
                              ),
                              CupertinoDialogAction(
                                  child: const Text("Gallery"),
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final pickedImage = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (pickedImage != null) {
                                      setState(() {
                                        selectImage = (pickedImage.path);
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
                    selectImage != null
                        ? Stack(
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
                                  File(selectImage!),
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                              Positioned(
                                right: -20,
                                top: -20,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectImage = null;
                                      });
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.delete_solid,
                                      color: Colors.red,
                                      size: 32,
                                    )),
                              )
                            ],
                          )
                        : const Expanded(
                            child: Center(
                              child: Text(
                                "Add More A Image",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          )
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(left: 30.0),
          child: CupertinoButton.filled(
            onPressed: () {
              _updateGarageInformation();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                ),
                Text(
                  "Add Update",
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  clear() {
    nameController.text = '';
    addressController.text = '';
    totalSpaceController.text = '';
    adInfoController.text = '';
    selectImage = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    totalSpaceController.dispose();
    adInfoController.dispose();
    floorController.dispose();
    super.dispose();
  }

  Future<void> _updateGarageInformation() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      startLoading('Please Wait');
      if (selectImage != null) {
        String url = await AuthenticateService.uploadImage(selectImage!);
        widget.garageModel.coverImage.add(url);
      }
      final map = {
        "name": nameController.text,
        "address": addressController.text,
        "additionalInformation": adInfoController.text,
        "totalSpace": totalSpaceController.text,
        "totalFloor": floorController.text,
        "coverImage": widget.garageModel.coverImage
      };
      await DbHelper.updateGarageInfo(widget.garageModel.gId, map)
          .then((value) {
        EasyLoading.dismiss();
        clear();
        Get.back();
        Get.back();
        showCorrectToastMessage('Update Successfully');
      }).catchError((onError) {
        EasyLoading.dismiss();

        showErrorToastMessage();
      });
    }
  }
}

import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:parking_finder/database/dbhelper.dart';
import 'package:parking_finder/model/garage_model.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/diaglog.dart';

import '../../controller/GarageController.dart';
import '../../custom_widget/appbar_with_title.dart';
import '../../custom_widget/parking_slot_ui.dart';
import '../../utilities/helper_function.dart';
import '../../utilities/testStyle.dart';

class EditParkingSpace extends StatelessWidget {
  final GarageModel garageModel;

  const EditParkingSpace({Key? key, required this.garageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
    garageController.selectFloorIndex.value = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWithTitleSubTitleWhiteBG(
        imageUrl: garageModel.coverImage[0],
        isOnlineImage: true,
        context: context,
        title: garageModel.name,
        subTitle: garageModel.city + garageModel.division,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  width: Get.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: Obx(() {
                          return Text(
                              'Total Free Space : ${garageController.garageList.value.firstWhere((element) => element.gId == garageModel.gId).totalSpace}');
                        }),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            alignment: Alignment.center,
                            height: 40,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.primaryColor,
                            ),
                            child: Text("Floor ", style: whiteBoldText),
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 1)),
                            child: Obx(() {
                              return DefaultTabController(
                                initialIndex:
                                    garageController.selectFloorIndex.value,
                                //optional, starts from 0, select the tab by default
                                length: num.parse(garageController
                                            .garageList.value
                                            .firstWhere((element) =>
                                                element.gId == garageModel.gId)
                                            .totalFloor)
                                        .toInt() +
                                    1,
                                child: TabBar(
                                  onTap: (value) {
                                    // if (garageController.garageList.value
                                    //         .firstWhere((element) =>
                                    //             element.gId == garageModel.gId)
                                    //         .floorDetails!
                                    //         .length ==
                                    //     value) {
                                    //   return;
                                    // }
                                    garageController.selectFloorIndex.value =
                                        value;
                                  },
                                  isScrollable: true,
                                  dividerColor: AppColors.primaryColor,
                                  unselectedLabelColor: Colors.black,
                                  indicatorColor: Colors.grey,
                                  indicator: const BoxDecoration(
                                    color: Colors.greenAccent,
                                  ),
                                  tabs: List.generate(
                                    num.parse(garageController.garageList.value
                                                .firstWhere((element) =>
                                                    element.gId ==
                                                    garageModel.gId)
                                                .totalFloor)
                                            .toInt() +
                                        1,
                                    (index) {
                                      if (garageController.garageList.value
                                              .firstWhere((element) =>
                                                  element.gId ==
                                                  garageModel.gId)
                                              .floorDetails!
                                              .length ==
                                          index) {
                                        return Tab(
                                          child: Text("Add"),
                                        );
                                      }
                                      String floor = garageController
                                          .garageList.value
                                          .firstWhere((element) =>
                                              element.gId == garageModel.gId)
                                          .floorDetails![index]
                                          .floorNumber!;
                                      return Tab(
                                        child: Text(
                                            '${floor == '0' ? "" : floor}${ordinal(num.parse(floor).toInt())}'),
                                      );
                                    },
                                  ).toList(),
                                ),
                              );
                            }),
                          ))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("ENTRY"),
                        const Icon(Icons.keyboard_arrow_down),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () {
                            int deleteFloor = num.parse(garageController
                                    .garageList.value
                                    .firstWhere((element) =>
                                        element.gId == garageModel.gId)
                                    .floorDetails![
                                        garageController.selectFloorIndex.value]
                                    .floorNumber!)
                                .toInt();

                            _deleteAFloor(
                                garageModel,
                                deleteFloor,
                                garageController,
                                garageController.selectFloorIndex.value);
                          },
                          label: const Text("Delete This Floor"),
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Obx(() {
                      return (garageController.garageList.value
                                  .firstWhere((element) =>
                                      element.gId == garageModel.gId)
                                  .floorDetails!
                                  .length ==
                              garageController.selectFloorIndex.value)
                          ? Center(
                              child: OutlinedButton(
                                  onPressed: () {
                                    if (garageController.formKey.currentState!
                                        .validate()) {
                                      _addAFloor(
                                          garageModel,
                                          garageController.floorController.text
                                              .trim());
                                      garageController.floorController.text =
                                          '';
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: Form(
                                          key: garageController.formKey,
                                          child: TextFormField(
                                            controller: garageController
                                                .floorController,
                                            maxLength: 2,
                                            keyboardType: TextInputType
                                                .numberWithOptions(),
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey.shade200,
                                              filled: true,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'Fill The Name Of Floor';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Text("Add A Floor"),
                                    ],
                                  )),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 1.4),
                              itemCount: garageController.garageList.value
                                      .firstWhere((element) =>
                                          element.gId == garageModel.gId)
                                      .floorDetails![garageController
                                          .selectFloorIndex.value]
                                      .spotInformation!
                                      .length +
                                  1,
                              itemBuilder: (context, index) {
                                if (index ==
                                    garageController.garageList.value
                                        .firstWhere((element) =>
                                            element.gId == garageModel.gId)
                                        .floorDetails![garageController
                                            .selectFloorIndex.value]
                                        .spotInformation!
                                        .length) {
                                  return DottedBorder(
                                    color: AppColors
                                        .primaryColor, //color of dotted/dash line
                                    strokeWidth: 1, //thickness of dash/dots
                                    dashPattern: const [10, 6],
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 180,
                                      height: 120,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                          color: AppColors.primaryColor,
                                        )),
                                        onPressed: () {
                                          _addSpot(
                                              context,
                                              garageController,
                                              garageModel,
                                              garageModel.floorDetails![
                                                  garageController
                                                      .selectFloorIndex.value]);
                                        },
                                        child: const Text("Add More Spot"),
                                      ),
                                    ),
                                  );
                                }

                                final parkingSpot = garageController
                                    .garageList.value
                                    .firstWhere((element) =>
                                        element.gId == garageModel.gId)
                                    .floorDetails![
                                        garageController.selectFloorIndex.value]
                                    .spotInformation![index];
                                return ParkingSlotEdit(
                                  isBooked: parkingSpot.isBooked,
                                  isParked: parkingSpot.bookedUserId != null,
                                  slotId: parkingSpot.spotId ?? "",
                                  time: 1.toString(),
                                  slotName: parkingSpot.spotName ?? '',
                                  onTap: () {
                                    _removedSpot(
                                        garageModel,
                                        garageController.selectFloorIndex.value,
                                        index);
                                  },
                                );
                              },
                            );
                    })),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("EXIT"),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addSpot(BuildContext context, GarageController garageController,
      GarageModel garageModel, FloorModel floorModel) async {
    int lastIndex = 1;
    if (floorModel.spotInformation!.isNotEmpty) {
      final lastSpot =
          floorModel.spotInformation![floorModel.spotInformation!.length - 1];
      lastIndex = num.parse(lastSpot.spotName!.substring(3)).toInt() + 1;
    }
    final spot = SpotInformation(
        spotId: DateTime.now().millisecondsSinceEpoch.toString(),
        spotName: "SP-$lastIndex",
        floor: ((num.parse(floorModel.floorNumber!).toInt())).toString());
    log("newSpod $lastIndex: ${spot.toJson()}");
    await DbHelper.increaseASpotGarage(
            garageModel, spot, garageController.selectFloorIndex.value)
        .catchError((onError) {
      log(onError.toString());
    });
  }

  void _removedSpot(GarageModel garageModel, int floor, int position) async {
    log("$floor _ $position");
    await DbHelper.deleteASpotGarage(garageModel, floor.toString(), position);
  }

  void _addAFloor(GarageModel garageModel, String floorNumber) async {
    await DbHelper.addAFloorGarage(garageModel, floorNumber);
  }

  void _deleteAFloor(GarageModel garageModel, int floor,
      GarageController garageController, int indexOfArray) async {
    garageController.selectFloorIndex.value = 0;
    log("floor: $floor : ${garageModel.toMap()} ${garageController.selectFloorIndex.value}");
    log("${indexOfArray}");
    try {
      startLoading('Wait');
      if (garageModel.floorDetails![indexOfArray].spotInformation!.isNotEmpty) {
        EasyLoading.dismiss();
        showErrorToastMessage(message: 'First Remove All The Available Spot');

        return;
      }
      await DbHelper.deleteAFloorGarage(garageModel, indexOfArray);
      EasyLoading.dismiss();
    } catch (erro) {
      showErrorToastMessage();
      EasyLoading.dismiss();
    }
  }
}

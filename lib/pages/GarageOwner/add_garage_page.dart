import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:provider/provider.dart';

import '../../custom_widget/appbar_with_title.dart';
import '../../providers/map_provider.dart';
import '../../utilities/diaglog.dart';
import '../../utilities/testStyle.dart';

class AddGaragePage extends StatelessWidget {
  const AddGaragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) => Scaffold(
        appBar: appBarWithTitleWhiteBG(
          context: context,
          title: "Add Garage Page",
        ),
        body: Stack(
          children: [
            mapProvider.currentLocation == null
                ? Center(
                    child: SpinKitWave(
                      color: AppColors.primaryColor,
                      size: 60.0,
                    ),
                  )
                : GoogleMap(
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(mapProvider.currentLocation!.latitude!,
                          mapProvider.currentLocation!.longitude!),
                      zoom: 13.5,
                    ),
                    onMapCreated: (mapController) {
                      mapProvider.mapController.complete(mapController);
                    },
                    onCameraMove: (position) {
                      mapProvider.selectPosition = position.target;
                    },
                  ),
            Positioned(
              bottom: 0,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    height: 150,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.8),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        )),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          trailing: SizedBox(
                            width: Get.width * .3,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              icon: const Icon(
                                CupertinoIcons.location_solid,
                                color: Colors.white,
                                size: 14,
                              ),
                              onPressed: () {
                                mapProvider.getLatLngToAddress(
                                    mapProvider.selectPosition);
                              },
                              label:
                                  const FittedBox(child: Text("Load Address")),
                            ),
                          ),
                          title: Text(mapProvider.placemarks == null
                              ? "Location Not Selection"
                              : "Address:${mapProvider.placemarks!.last.street}  ${mapProvider.placemarks?.first.subLocality}"),
                          subtitle: Text(mapProvider.placemarks == null
                              ? "No City"
                              : "City : ${mapProvider.placemarks?.first.administrativeArea}"),
                        ),
                        CupertinoButton(
                          color: Colors.white,
                          disabledColor: Colors.grey,
                          onPressed: mapProvider.placemarks == null
                              ? null
                              : () {
                                  mapProvider.garageImagesSelection = [];
                                  _showBottomSheet(context);
                                },
                          child: const Text(
                            "Add Garage Place",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                child: Center(
              child: Image.asset(
                "assets/image/markLogo.png",
                width: 40,
                height: 60,
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    int currentPage = 0;
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return StatefulBuilder(builder: (context, setState) {
            return Consumer<MapProvider>(
              builder: (context, mapProvider, child) {
                return Form(
                  key: mapProvider.formKey,
                  child: Container(
                    height: Get.height * .84,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Stack(
                      children: [
                        PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollBehavior: const ScrollBehavior(),
                          controller: mapProvider.addGarageController,
                          children: [
                            ListView(
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
                                Text("Name of spot", style: blackBoldSmallText),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller:
                                        mapProvider.garageNameController,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        hintText: "Garage Name Of Your",
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        helperText:
                                            "Please do not mention the parking spot number here",
                                        helperStyle: TextStyle(
                                          color: Colors.red.shade200,
                                          fontSize: 12,
                                        )),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Input Your Garage name';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                Text("Address", style: blackBoldSmallText),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller:
                                        mapProvider.garageAddressController,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      hintText: "Garage Address",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      helperText:
                                          "Your address will not visible to drivers still they book your spot",
                                      helperStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Input Garage Address name';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                Text("Additional Information",
                                    style: blackBoldSmallText),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller:
                                        mapProvider.garageAddInfoController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      hintText: "Garage Address",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      helperStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Input Garage Address name';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "No. of vacancies : ",
                                      style: blackBoldSmallText,
                                    ),
                                    SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: TextFormField(
                                        controller:
                                            mapProvider.totalSlotController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Slot",
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: Colors.grey.shade100,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Input slot';
                                          }

                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  height: 100,
                                  width: Get.width,
                                  child: GoogleMap(
                                    zoomControlsEnabled: false,
                                    zoomGesturesEnabled: false,
                                    scrollGesturesEnabled: false,
                                    mapType: MapType.hybrid,
                                    initialCameraPosition: CameraPosition(
                                      target: mapProvider.selectPosition,
                                      zoom: 15.5,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ListView(
                              children: [
                                Container(
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
                                Text("Enter Spot Details",
                                    style: blackBoldText),
                                const SizedBox(height: 7),
                                Text("Image of Spot",
                                    style: blackBoldSmallText),
                                const SizedBox(height: 7),
                                Container(
                                  height: Get.height * .42,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: mapProvider
                                          .garageImagesSelection.isNotEmpty
                                      ? GridView.count(
                                          primary: false,
                                          padding: const EdgeInsets.all(20),
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          crossAxisCount: 3,
                                          children: mapProvider
                                              .garageImagesSelection
                                              .map((e) => Stack(
                                                    children: [
                                                      Image.file(
                                                        File(e),
                                                        fit: BoxFit.cover,
                                                        width: Get.width * .3,
                                                        height:
                                                            Get.height * .13,
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            mapProvider
                                                                .deleteSelectImage(
                                                                    e);
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                            size: 30,
                                                          ))
                                                    ],
                                                  ))
                                              .toList(),
                                        )
                                      : Center(
                                          child: Text("No Image Select",
                                              style: grayLowSmallColor),
                                        ),
                                ),
                                Center(
                                  child: IconButton(
                                    onPressed: () {
                                      if (mapProvider
                                              .garageImagesSelection.length ==
                                          9) {
                                        showErrorToastMessage(
                                            "You Select Max Image");
                                        return;
                                      }
                                      mapProvider.pickImage();
                                    },
                                    icon: Icon(
                                      Icons.upload,
                                      size: 44,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                    textAlign: TextAlign.center,
                                    "Upload photo of your parking spot\n[Minimum 1 photos]",
                                    style: grayTextStyle),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.check_mark_circled,
                                        color: AppColors.primaryColor),
                                    Text("Make sure the photo is well",
                                        style: grayLowSmallColor)
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.check_mark_circled,
                                        color: AppColors.primaryColor),
                                    Text("Avoid Blurry Images",
                                        style: grayLowSmallColor)
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.check_mark_circled,
                                        color: AppColors.primaryColor),
                                    Text("Show the complete spot",
                                        style: grayLowSmallColor)
                                  ],
                                ),
                                const SizedBox(height: 7),
                              ],
                            ),
                            ListView(
                              children: [
                                const SizedBox(height: 30),
                                Text("Enter Spot Details",
                                    style: blackBoldText),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    Text("Number of Floor :",
                                        style: blackBoldSmallText),
                                    SizedBox(
                                      width: 70,
                                      height: 55,
                                      child: TextFormField(
                                        controller:
                                            mapProvider.numberOfFloorController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Floor",
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: Colors.grey.shade100,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
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
                                          mapProvider
                                              .addFacilityFunction("CCTV");
                                        },
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: mapProvider.garageFacility
                                                    .contains("CCTV")
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.camera,
                                                color: Colors.white,
                                              ),
                                              Text("CCTV",
                                                  style: whiteBoldText),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          mapProvider
                                              .addFacilityFunction("Lighting");
                                        },
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: mapProvider.garageFacility
                                                    .contains("Lighting")
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                CupertinoIcons.lightbulb,
                                                color: Colors.white,
                                              ),
                                              Text("Lighting",
                                                  style: whiteBoldText)
                                            ],
                                          ),
                                        ),
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
                                          mapProvider.addFacilityFunction(
                                              "Security Guard");
                                        },
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: mapProvider.garageFacility
                                                    .contains("Security Guard")
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.security,
                                                color: Colors.white,
                                              ),
                                              Text("Security Guard",
                                                  style: whiteBoldText),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          mapProvider.addFacilityFunction(
                                              "24/7 Service");
                                        },
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: mapProvider.garageFacility
                                                    .contains("24/7 Service")
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                CupertinoIcons.lock_open,
                                                color: Colors.white,
                                              ),
                                              Text("24/7 Service",
                                                  style: whiteBoldText)
                                            ],
                                          ),
                                        ),
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
                                          mapProvider.addFacilityFunction(
                                              "Covered Parking");
                                        },
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: mapProvider.garageFacility
                                                    .contains("Covered Parking")
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                CupertinoIcons.car_detailed,
                                                color: Colors.white,
                                              ),
                                              Text("Covered Parking",
                                                  style: whiteBoldText),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          mapProvider.addFacilityFunction(
                                              "Roadside Parking");
                                        },
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: mapProvider.garageFacility
                                                    .contains(
                                                        "Roadside Parking")
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.add_road,
                                                color: Colors.white,
                                              ),
                                              Text("Roadside Parking",
                                                  style: whiteBoldText)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    trailing: Checkbox(
                                      value: mapProvider.tramsCond,
                                      onChanged: (value) {
                                        mapProvider.tramsCond =
                                            !mapProvider.tramsCond;
                                      },
                                    ),
                                    onTap: () {
                                      log("value : ${mapProvider.tramsCond}");
                                      mapProvider.tramsCond =
                                          !mapProvider.tramsCond;
                                    },
                                    title: Text(
                                      "All The Information Are the contains your terms and conditions",
                                      style: grayLowSmallColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ListView(
                              children: [
                                Center(
                                  child: Text("Row & Colum"),
                                )
                              ],
                            )
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List<Widget>.generate(
                                    3,
                                    (index) => AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                            color: AppColors.primaryColor,
                                          ),
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          height: 10,
                                          curve: Curves.easeIn,
                                          width: currentPage == index ? 20 : 10,
                                        )),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                      ),
                                      child: Text(currentPage == 0
                                          ? "Back To Map"
                                          : "Back"),
                                      onPressed: () {
                                        currentPage == 0
                                            ? Get.back()
                                            : currentPage = currentPage - 1;
                                        mapProvider.addGarageController
                                            .animateToPage(currentPage,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves
                                                    .fastLinearToSlowEaseIn);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                      ),
                                      child: Text(
                                          currentPage == 2 ? "Submit" : "Next"),
                                      onPressed: () {
                                        if (currentPage == 2) {
                                          if (mapProvider.formKey.currentState!
                                              .validate()) {
                                            mapProvider.createAGarage(context);
                                          }
                                        } else {
                                          currentPage++;
                                          mapProvider.addGarageController
                                              .animateToPage(
                                                  currentPage,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves
                                                      .fastLinearToSlowEaseIn);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        });
  }
}

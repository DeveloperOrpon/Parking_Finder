import 'dart:developer';

import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/pages/parking_information_page.dart';
import 'package:parking_finder/providers/map_provider.dart';
import 'package:parking_finder/utilities/appConst.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';

import 'avalable_parking_space_page.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (context, mapProvider, child) {
      if (mapProvider.currentLocation == null) mapProvider.getCurrentLocation();

      return mapProvider.currentLocation == null ||
              mapProvider.parkingBitmap == null
          ? SpinKitCubeGrid(
              color: AppColors.primaryColor,
              size: 50.0,
            )
          : GoogleMap(
              onCameraMoveStarted: () {
                mapProvider.isShowAds = false;
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                ..add(Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer())),
              scrollGesturesEnabled: true,
              indoorViewEnabled: true,
              compassEnabled: true,
              markers: {
                Marker(
                  onTap: () => _showParkingInfoInBottomSheet(context),
                  markerId: const MarkerId('1'),
                  position: mapProvider.myPosition2,
                  infoWindow: InfoWindow(
                    title: 'Perdo Garage',
                    snippet: '12$currencySymbol /hr',
                    onTap: () => _showParkingInfoInBottomSheet(context),
                  ),
                  icon: mapProvider.parkingBitmap!,
                )
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(mapProvider.currentLocation!.latitude!,
                    mapProvider.currentLocation!.longitude!),
                zoom: 14.5,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapProvider.mapController.complete(controller);
              },
            );
    });
  }

  void _showParkingInfoInBottomSheet(BuildContext context) {
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
                              const TextSpan(
                                  text: "Perdo Garage",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' 12$currencySymbol/hr',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                        ),
                        const Text(
                          "235 Zemblack Crest Apt 102",
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
                                const Entry(
                                    xOffset: -50,
                                    delay: Duration(milliseconds: 300),
                                    duration: Duration(milliseconds: 700),
                                    child: Text("24 spots")),
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
                          child: Image.asset(
                            'assets/image/bg.jpg',
                            height: Get.height * .18,
                            width: Get.width * .24,
                            fit: BoxFit.cover,
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
                          Get.to(const AvailableParkingSpacePage(),
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
              AnimatedContainer(
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              "05:00 AM - 11.00 PM",
                              style: blackBoldText,
                            ),
                            Text(
                              "Open Now",
                              style: TextStyle(color: AppColors.primaryColor),
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Row(
                              children: [
                                const Icon(CupertinoIcons.phone),
                                const SizedBox(width: 8),
                                Text(
                                  "+8801932610623",
                                  style: blackBoldText,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(CupertinoIcons.mail),
                                const SizedBox(width: 8),
                                Text(
                                  "admin@gmail.com",
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                                  Text(
                                    "Shewrapara, Mirpur-10, Dhaka ,Bangladesh",
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
                                Get.to(const ParkingInformationPage(),
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
              )
            ],
          ),
        );
      }),
    );
  }
}

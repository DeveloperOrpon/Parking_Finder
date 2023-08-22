import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/providers/booking_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class AddVehiclePage extends StatelessWidget {
  const AddVehiclePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserProvider>(context, listen: false);
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) => Scaffold(
        appBar: appBarWithTitleWhiteBG(
          context: context,
          title: "Add Car Details",
        ),
        body: Form(
          key: bookingProvider.formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                      spreadRadius: 4,
                    )
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                height: Get.height * .28,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              bookingProvider.vehicleType = "4 Wheeler";
                              bookingProvider.selectImageVehicle(0);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              margin: const EdgeInsets.all(3),
                              alignment: Alignment.center,
                              height: Get.height * .07,
                              width: Get.width * .35,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: bookingProvider.selectImage ==
                                        bookingProvider.carCar
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.car,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "4 Wheeler",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      Text(
                                        "Car/SUV/etc.",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 10),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              bookingProvider.vehicleType = "2 Wheeler";
                              bookingProvider.selectImageVehicle(1);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              margin: const EdgeInsets.all(3),
                              alignment: Alignment.center,
                              height: Get.height * .07,
                              width: Get.width * .35,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: bookingProvider.selectImage ==
                                        bookingProvider.bikeCar
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.bicycle,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "2 Wheeler",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      Text(
                                        "Bike/Scooter",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 10),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              bookingProvider.vehicleType = "Custom";
                              bookingProvider.selectImageVehicle(2);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              margin: const EdgeInsets.all(3),
                              alignment: Alignment.center,
                              height: Get.height * .07,
                              width: Get.width * .35,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: bookingProvider.selectImage ==
                                        bookingProvider.otherCar
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.car_repair,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Custom",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      Text(
                                        "Any Type",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 10),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -70,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        child: Image.asset(
                          bookingProvider.selectImage,
                          height: Get.height * .24,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bookingProvider.carNameController,
                  autofocus: false,
                  focusNode: bookingProvider.carNameFocus,
                  decoration: InputDecoration(
                    label: const Text('Car Name'),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.email, color: AppColors.primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: AppColors.primarySoft,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input Your Car name';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bookingProvider.carNamePlateController,
                  autofocus: false,
                  focusNode: bookingProvider.carNamePlateFocus,
                  decoration: InputDecoration(
                    label: const Text('Car Plate Number'),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.email, color: AppColors.primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: AppColors.primarySoft,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input Your Car Plate Number';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bookingProvider.carModelController,
                  autofocus: false,
                  focusNode: bookingProvider.carModelFocus,
                  decoration: InputDecoration(
                    label: const Text('Brand & Model'),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.email, color: AppColors.primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: AppColors.primarySoft,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input Your Brand name';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: CupertinoButton(
                  color: AppColors.primaryColor,
                  child: const Text("Save Details"),
                  onPressed: () {
                    if (bookingProvider.formKey.currentState!.validate()) {
                      bookingProvider.addVehicle(userController, context);
                    }
                    //Get.back();
                    // bookingProvider.controllerDispose();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

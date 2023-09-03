import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/controller/ParkingController.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/providers/booking_provider.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';

import '../model/vicModel.dart';
import '../utilities/app_colors.dart';
import 'add_vehicle_page.dart';

class SelectVehiclePage extends StatelessWidget {
  const SelectVehiclePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parkingController = Get.put(ParkingController());
    final bookingProvider = Provider.of<BookingProvider>(context);
    return Scaffold(
      appBar: appBarWithTitleWhiteBG(
        context: context,
        title: "Select Your Vehicle",
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: userProvider.user == null ||
                          userProvider.user!.name!.isEmpty
                      ? Center(
                          child: Text(
                            "You Haven't Any Vehicles",
                            style: appThemeTextStyle,
                          ),
                        )
                      : Obx(() {
                          return ListView.builder(
                            itemCount: parkingController.carList.value.length,
                            itemBuilder: (context, index) {
                              var vicList =
                                  parkingController.carList.value[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                alignment: Alignment.center,
                                height: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Image.asset(bookingProvider
                                      .getVehicleImage(vicList.vehicleType!)),
                                  title: Text(vicList.vehicle!,
                                      style: blackBoldText),
                                  subtitle: Text(
                                    vicList.model!,
                                    style: grayTextStyle,
                                  ),
                                  trailing: Radio(
                                    value: true,
                                    groupValue: vicList.isDefault,
                                    onChanged: (value) {
                                      bookingProvider.defaultCar(
                                          VicModel(), userProvider);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        })),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        side: const BorderSide(
                            color: AppColors.primarySoft, width: 2),
                      ),
                      onPressed: () {
                        bookingProvider.controllerInit();
                        bookingProvider.vehicleType = '2 Wheeler';
                        bookingProvider.selectImage =
                            'assets/image/motoCar.png';
                        Get.to(const AddVehiclePage(),
                            transition: Transition.leftToRightWithFade);
                      },
                      child: const Text("Add New Vehicle"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton.filled(
                      child: const Text("Select Vehicle"),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }
}

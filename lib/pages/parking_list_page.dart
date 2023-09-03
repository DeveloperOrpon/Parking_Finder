import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/controller/ParkingController.dart';
import 'package:parking_finder/pages/Delegate/Searchdelegate.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';

import '../custom_widget/ParkingTileUi.dart';
import '../utilities/testStyle.dart';

class ParkingListPage extends StatelessWidget {
  final UserProvider userProvider;

  const ParkingListPage({Key? key, required this.userProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
    final parkingController = Get.put(ParkingController());
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "NearBy Parking : ",
                style: blackBoldText,
              ),
              TextSpan(
                text: "Dhaka,Mirpur",
                style: blackPrimaryText,
              )
            ]),
          ),
          actions: [
            InkWell(
              onTap: () {
                showSearch(
                    context: context,
                    delegate: ParkingSearchDelegate(garageController));
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1,
                    )),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_location,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                    Text(
                      "Edit",
                      style: blackPrimaryText,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Obx(() {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final parking = garageController.allActiveParking[index];
                return ParkingTileUi(
                  parkingModel: parking,
                  garageModel: null,
                );
              },
              childCount: garageController.allActiveParking.length,
            ),
          );
        }),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(
            height: 100,
          )
        ]))
      ],
    );
  }
}

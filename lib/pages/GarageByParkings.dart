import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parking_finder/custom_widget/ParkingTileUi.dart';

import '../utilities/testStyle.dart';

class GarageByParking extends StatelessWidget {
  const GarageByParking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          "Garage Of Mirpur",
          style: continueBlackTextStyle,
        ),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: OutlinedButton(onPressed: () {}, child: Text("Edit")),
          ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            CircleAvatar(
              radius: 50,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  "Mirpur Garage 10",
                  style: linkTextStyle,
                ),
              ),
            ),
            Center(
              child: Text(
                "Mirpur Mirpur 10, Dhaka",
                style: grayLowSmallColor,
              ),
            ),
            Center(
                child: OutlinedButton(
                    onPressed: () {}, child: const Text("Analytes"))),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "Parking Ads Are :",
                style: grayLowMediumColor,
              ),
            ),
          ])),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => ParkingTileUi(),
                  childCount: 20))
        ],
      ),
    );
  }
}

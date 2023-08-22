import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parking_finder/utilities/app_colors.dart';

import '../utilities/testStyle.dart';

class SingleGaragePreview extends StatelessWidget {
  const SingleGaragePreview({Key? key}) : super(key: key);

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
              child: Text(
                "Available Spot : 102",
                style: grayLowSmallColor,
              ),
            ),
            Center(
              child: Text(
                "Total Spot : 150",
                style: grayLowSmallColor,
              ),
            ),
            Center(
              child: Text(
                "Booked Spot : 10",
                style: grayLowSmallColor,
              ),
            ),
            Center(
              child: Text(
                "Average Review : 4.6🖤",
                style: grayLowSmallColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 5),
              child: Text(
                "Garage Owner Information : ",
                style: grayLowMediumColor,
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12),
                  color: AppColors.primaryColor,
                  width: 200,
                  height: 2,
                ),
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 20,
              ),
              title: Text(
                "Orpon Hasan",
                style: grayLowMediumColor,
              ),
              subtitle: Text('Mirpur Dhaka'),
            )
          ])),
        ],
      ),
    );
  }
}

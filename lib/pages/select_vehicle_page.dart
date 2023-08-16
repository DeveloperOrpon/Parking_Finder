import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/utilities/testStyle.dart';

import '../utilities/app_colors.dart';
import 'add_vehicle_page.dart';

class SelectVehiclePage extends StatelessWidget {
  const SelectVehiclePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithTitleWhiteBG(
        context: context,
        title: "Select Your Vehicle",
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
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
                leading: const Icon(
                  Icons.photo,
                  size: 44,
                ),
                title: Text("BM W X8 G9", style: blackBoldText),
                subtitle: Text(
                  "HGE 484942",
                  style: grayTextStyle,
                ),
                trailing: Radio(
                  value: true,
                  groupValue: false,
                  onChanged: (value) {},
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.greenAccent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.photo,
                  size: 44,
                ),
                title: Text("BM W X5 G10", style: blackBoldText),
                subtitle: Text(
                  "M6 Wheel",
                  style: grayTextStyle,
                ),
                trailing: Radio(
                  value: true,
                  groupValue: true,
                  onChanged: (value) {},
                ),
              ),
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                side: const BorderSide(color: AppColors.primarySoft, width: 2),
              ),
              onPressed: () {
                Get.to(const AddVehiclePage(),
                    transition: Transition.leftToRightWithFade);
              },
              child: const Text("Add New Vehicle"),
            ),
            const SizedBox(height: 10),
            CupertinoButton.filled(
              child: const Text("Select Vehicle"),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

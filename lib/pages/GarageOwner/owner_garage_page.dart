import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/utilities/appConst.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'add_garage_page.dart';

class OwnerGaragePage extends StatelessWidget {
  const OwnerGaragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Your Garage List", style: blackBoldText),
              const SizedBox(width: 8),
              Icon(FontAwesomeIcons.squareParking,
                  color: AppColors.primaryColor),
            ],
          ),
          SizedBox(
            width: Get.width / 2,
            child: Divider(
              thickness: 1,
              color: AppColors.primaryColor.withOpacity(.3),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                Card(
                  elevation: 5,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: AppColors.primaryColor.withOpacity(.5),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(6),
                        title: Text("Orpon Garage"),
                        subtitle: const FittedBox(
                          child: Text(
                            maxLines: 1,
                            "Shewrapara Mirpur Dhaka - 12$currencySymbol /hr",
                          ),
                        ),
                        trailing: PullDownButton(
                          itemBuilder: (context) => [
                            PullDownMenuItem(
                              onTap: () {},
                            ),
                            const PullDownMenuDivider(),
                            PullDownMenuItem(
                              title: 'Menu item 2',
                              onTap: () {},
                            ),
                          ],
                          buttonBuilder: (context, showMenu) => CupertinoButton(
                            onPressed: showMenu,
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.ellipsis_circle),
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/image/bg.jpg',
                            height: Get.height * .15,
                            width: Get.width * .15,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: CupertinoButton(
              color: AppColors.primaryColor,
              child: Text("Add Garage Location", style: whiteBoldText),
              onPressed: () {
                Get.to(const AddGaragePage(),
                    transition: Transition.rightToLeftWithFade);
              },
            ),
          ),
          SizedBox(
            height: Get.height * .09,
          )
        ],
      ),
    );
  }
}

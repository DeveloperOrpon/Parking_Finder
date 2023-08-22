import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../utilities/appConst.dart';
import '../utilities/app_colors.dart';
import '../utilities/testStyle.dart';
import 'GarageByParkings.dart';
import 'SingleGaragePreview.dart';

class NearByGarageScreen extends StatelessWidget {
  const NearByGarageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text("Available Garage Information", style: blackBoldSmallText),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("NearBy Garages", style: blackBoldText),
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
                                icon: FontAwesomeIcons.v,
                                title: 'Preview',
                                onTap: () {
                                  Get.to(const SingleGaragePreview(),
                                      transition: Transition.topLevel);
                                },
                              ),
                              const PullDownMenuDivider(),
                              PullDownMenuItem(
                                icon: FontAwesomeIcons.parking,
                                title: 'Parking Ads',
                                onTap: () {
                                  Get.to(const GarageByParking(),
                                      transition: Transition.topLevel);
                                },
                              ),
                              const PullDownMenuDivider(),
                              PullDownMenuItem(
                                icon: FontAwesomeIcons.bookBookmark,
                                title: 'All Bookings',
                                onTap: () {},
                              ),
                            ],
                            buttonBuilder: (context, showMenu) =>
                                CupertinoButton(
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
          ],
        ),
      ),
    );
  }
}

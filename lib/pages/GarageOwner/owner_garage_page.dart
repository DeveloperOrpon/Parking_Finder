import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../model/user_model.dart';
import '../GarageByParkings.dart';
import '../SingleGaragePreview.dart';
import 'add_garage_page.dart';

class OwnerGaragePage extends StatelessWidget {
  const OwnerGaragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
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
              child: userProvider.user!.garazList!.isEmpty
                  ? const Center(
                      child: Text("No Garage Available"),
                    )
                  : ListView.builder(
                      itemCount: userProvider.user!.garazList!.length,
                      itemBuilder: (context, index) {
                        GarageModel garageModel =
                            userProvider.user!.garazList![index];
                        return Card(
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
                                title: Text(garageModel.name ?? ''),
                                subtitle: FittedBox(
                                  child: Text(
                                    maxLines: 1,
                                    "${garageModel.city},${garageModel.division}- ${garageModel.address}",
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
                                    child: const Icon(
                                        CupertinoIcons.ellipsis_circle),
                                  ),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    garageModel.coverImage?[0] ?? "",
                                    height: Get.height * .15,
                                    width: Get.width * .15,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
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
    });
  }
}

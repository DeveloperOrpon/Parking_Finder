import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/pages/GarageOwner/updateGarage.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../model/garage_model.dart';
import '../GarageByParkings.dart';
import 'SingleGaragePreview.dart';
import 'add_garage_page.dart';
import 'add_parking_info.dart';

class OwnerGaragePage extends StatelessWidget {
  const OwnerGaragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
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
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                ),
                onPressed: () {
                  log("Garage : ${garageController.myUnActiveGarages.value.length}");
                  garageController.isShowActiveGarage.value =
                      !garageController.isShowActiveGarage.value;
                },
                child: Obx(() {
                  return Text(garageController.isShowActiveGarage.value
                      ? "UnActive/Pending"
                      : "Active/Live");
                }),
              )
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
            child: Obx(() => garageController.isShowActiveGarage.value
                ? garageController.myActiveGarages.isEmpty
                    ? const Center(
                        child: Text("No Garage Information Available"),
                      )
                    : ListView.builder(
                        itemCount: garageController.myActiveGarages.length,
                        itemBuilder: (context, index) {
                          GarageModel garageModel =
                              garageController.myActiveGarages[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 + 100 * index),
                            child: Card(
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
                                  PullDownButton(
                                      itemBuilder: (context) => [
                                            PullDownMenuItem(
                                              iconColor: AppColors.primaryColor,
                                              icon: FontAwesomeIcons.v,
                                              title: 'Preview',
                                              onTap: () {
                                                Get.to(
                                                    SingleGaragePreview(
                                                        garageModel:
                                                            garageModel),
                                                    transition:
                                                        Transition.topLevel);
                                              },
                                            ),
                                            const PullDownMenuDivider(),
                                            PullDownMenuItem(
                                              icon: Icons.garage,
                                              iconColor: AppColors.primaryColor,
                                              title: 'Add Parking Ads',
                                              onTap: () {
                                                Get.to(
                                                    AddParkingInfoPage(
                                                      garageModel: garageModel,
                                                    ),
                                                    transition:
                                                        Transition.fadeIn);
                                              },
                                            ),
                                            const PullDownMenuDivider(),
                                            PullDownMenuItem(
                                              iconColor: AppColors.primaryColor,
                                              icon: FontAwesomeIcons.parking,
                                              title: 'Parking Ads',
                                              onTap: () {
                                                Get.to(
                                                    GarageByParking(
                                                        garageModel:
                                                            garageModel),
                                                    transition:
                                                        Transition.topLevel);
                                              },
                                            ),
                                            const PullDownMenuDivider(),
                                            PullDownMenuItem(
                                              iconColor: AppColors.primaryColor,
                                              icon:
                                                  FontAwesomeIcons.bookBookmark,
                                              title: 'All Bookings',
                                              onTap: () {},
                                            ),
                                          ],
                                      buttonBuilder: (context, showMenu) =>
                                          ListTile(
                                            onTap: showMenu,
                                            contentPadding: EdgeInsets.all(6),
                                            title: Text(garageModel.name ?? ''),
                                            subtitle: FittedBox(
                                              child: Text(
                                                maxLines: 1,
                                                "${garageModel.city},${garageModel.division}- ${garageModel.address}",
                                              ),
                                            ),
                                            trailing: const Icon(
                                                CupertinoIcons.ellipsis_circle),
                                            leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  height: Get.height * .15,
                                                  width: Get.width * .15,
                                                  fit: BoxFit.cover,
                                                  imageUrl: garageModel
                                                          .coverImage[0] ??
                                                      "",
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          SpinKitSpinningLines(
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: 50.0,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )),
                                          )),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                : garageController.myUnActiveGarages.isEmpty
                    ? const Center(
                        child: Text("No Garage Information Available"),
                      )
                    : ListView.builder(
                        itemCount: garageController.myUnActiveGarages.length,
                        itemBuilder: (context, index) {
                          GarageModel garageModel =
                              garageController.myUnActiveGarages[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 + 100 * index),
                            child: Card(
                              elevation: 5,
                              color: Colors.red.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: AppColors.primaryColor.withOpacity(.5),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PullDownButton(
                                      itemBuilder: (context) => [
                                            PullDownMenuItem(
                                              iconColor: AppColors.primaryColor,
                                              icon: FontAwesomeIcons.v,
                                              title: 'Preview',
                                              onTap: () {
                                                Get.to(
                                                    SingleGaragePreview(
                                                        garageModel:
                                                            garageModel),
                                                    transition:
                                                        Transition.topLevel);
                                              },
                                            ),
                                            const PullDownMenuDivider(),
                                            PullDownMenuItem(
                                              icon: CupertinoIcons.delete,
                                              title: 'Delete',
                                              onTap: () {
                                                garageController
                                                    .deleteAGarage(garageModel);
                                              },
                                            ),
                                            const PullDownMenuDivider(),
                                            PullDownMenuItem(
                                              icon: FontAwesomeIcons.parking,
                                              title: 'Update',
                                              onTap: () {
                                                Get.to(
                                                    UpdateGaragePage(
                                                        garageModel:
                                                            garageModel),
                                                    transition:
                                                        Transition.fade);
                                              },
                                            ),
                                            const PullDownMenuDivider(),
                                          ],
                                      buttonBuilder: (context, showMenu) =>
                                          ListTile(
                                            onTap: showMenu,
                                            contentPadding: EdgeInsets.all(6),
                                            title: Text(garageModel.name ?? ''),
                                            subtitle: FittedBox(
                                              child: Text(
                                                maxLines: 1,
                                                "${garageModel.city},${garageModel.division}- ${garageModel.address}",
                                              ),
                                            ),
                                            trailing: const Icon(
                                                CupertinoIcons.ellipsis_circle),
                                            leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  height: Get.height * .15,
                                                  width: Get.width * .15,
                                                  fit: BoxFit.cover,
                                                  imageUrl: garageModel
                                                          .coverImage[0] ??
                                                      "",
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          SpinKitSpinningLines(
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: 50.0,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )),
                                          )),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
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

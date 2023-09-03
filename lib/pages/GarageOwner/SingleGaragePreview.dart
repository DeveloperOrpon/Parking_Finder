import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/database/dbhelper.dart';
import 'package:parking_finder/model/garage_model.dart';
import 'package:parking_finder/model/user_model.dart';
import 'package:parking_finder/pages/GarageOwner/updateGarage.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/diaglog.dart';

import '../../model/parking_model.dart';
import '../../services/Auth_service.dart';
import '../../utilities/testStyle.dart';
import '../UserProfileViewPage.dart';
import '../parking_information_page.dart';
import 'GarageImageGalleryPage.dart';
import 'edit_avalable_parking_space_page.dart';

class SingleGaragePreview extends StatelessWidget {
  final GarageModel garageModel;

  const SingleGaragePreview({Key? key, required this.garageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
    int totalRent() {
      int temp = 0;
      for (FloorModel floorModel in garageModel.floorDetails!) {
        temp += floorModel.spotInformation!.length;
      }
      return temp;
    }

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
          garageModel.name,
          style: continueBlackTextStyle,
        ),
        actions: [
          if (AuthService.currentUser!.uid == garageModel.ownerUId)
            CupertinoButton(
              onPressed: () {
                Get.to(UpdateGaragePage(garageModel: garageModel),
                    transition: Transition.leftToRightWithFade);
              },
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.edit,
                color: AppColors.primaryColor,
                size: 35,
              ),
            )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            CachedNetworkImage(
                imageUrl: "${garageModel.coverImage[0]}",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SpinKitSpinningLines(
                      color: AppColors.primaryColor,
                      size: 50.0,
                    ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: imageProvider,
                  );
                }),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      garageModel.name,
                      style: linkTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Obx(() {
                        return CircleAvatar(
                          radius: 8,
                          backgroundColor: garageController.garageList.value
                                  .firstWhere((element) =>
                                      element.gId == garageModel.gId)
                                  .isActive
                              ? AppColors.primaryColor
                              : Colors.red,
                        );
                      }),
                    ),
                    Obx(() {
                      return Text(
                        garageController.garageList.value
                                .firstWhere(
                                    (element) => element.gId == garageModel.gId)
                                .isActive
                            ? "(Active)"
                            : "(InActive)",
                        style: primaryLowSmallColor,
                      );
                    })
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                "${garageModel.city},${garageModel.division},(${garageModel.address})",
                style: grayLowSmallColor,
              ),
            ),
            Center(
              child: Text(
                "Available Spot : ${garageModel.availableSpace}",
                style: primaryLowSmallColor,
              ),
            ),
            Center(
              child: Text(
                "Total Spot : ${garageModel.totalSpace}",
                style: grayLowSmallColor,
              ),
            ),
            Center(
              child: Text(
                "Total Rent : ${totalRent()}",
                style: primaryLowSmallColor,
              ),
            ),
            Center(
              child: Text(
                "Booked Spot : 10",
                style: primaryLowSmallColor,
              ),
            ),
            Center(
              child: Text(
                "Average Review : ${garageModel.rating}🧡",
                style: grayLowSmallColor,
              ),
            ),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                ),
                onPressed: () {
                  Get.to(GarageImageGallery(garageModel: garageModel),
                      transition: Transition.fade);
                },
                child: const Text("Image Gallery Preview",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            if (AuthService.currentUser!.uid == garageModel.ownerUId)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      Get.to(EditParkingSpace(garageModel: garageModel),
                          transition: Transition.fadeIn);
                    },
                    child: const Text("Spot Details(Edit)",
                        style: TextStyle(color: Colors.white)),
                  ),
                  Obx(() {
                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: garageController.garageList.value
                                .firstWhere(
                                    (element) => element.gId == garageModel.gId)
                                .isActive
                            ? Colors.red.shade500
                            : AppColors.primaryColor,
                      ),
                      onPressed: () {
                        _deactiveGarage(
                            context,
                            garageController.garageList.value.firstWhere(
                                (element) => element.gId == garageModel.gId),
                            garageController);
                      },
                      child: Text(
                        garageController.garageList.value
                                .firstWhere(
                                    (element) => element.gId == garageModel.gId)
                                .isActive
                            ? "Deactivate Garage"
                            : "Active Garage",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                ],
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
                  margin: const EdgeInsets.only(left: 12),
                  color: AppColors.primaryColor,
                  width: 200,
                  height: 2,
                ),
              ],
            ),
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            FutureBuilder(
                future: DbHelper.getUserInfoMap(garageModel.ownerUId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CupertinoActivityIndicator(
                      radius: 30,
                      color: AppColors.primaryColor,
                    );
                  }
                  final user = UserModel.fromMap(snapshot.data!.data()!);
                  return Padding(
                    padding: const EdgeInsets.all(6),
                    child: Card(
                      elevation: 5,
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: AppColors.primaryColor.withOpacity(.5),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Get.to(UserProfilePreviewPage(userModel: user),
                              transition: Transition.fadeIn);
                        },
                        trailing: (garageController.user.value!.isUserVerified!)
                            ? Tooltip(
                                waitDuration: Duration.zero,
                                showDuration: Duration(minutes: 4),
                                message: 'User Verified',
                                child: Icon(
                                  Icons.verified,
                                  color: AppColors.primaryColor,
                                  size: 30,
                                ),
                              )
                            : null,
                        leading: Hero(
                          tag: user.uid!,
                          child: CachedNetworkImage(
                            imageUrl: user.profileUrl ?? "",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    SpinKitSpinningLines(
                              color: AppColors.primaryColor,
                              size: 50.0,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundImage: imageProvider,
                              );
                            },
                          ),
                        ),
                        title: Text(
                          user.name ?? "",
                          style: grayLowMediumColor,
                        ),
                        subtitle: Text(user.location ?? ''),
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 5),
              child: Text(
                "Garage Parking Ads : ",
                style: grayLowMediumColor,
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  color: AppColors.primaryColor,
                  width: 140,
                  height: 2,
                ),
              ],
            ),
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            FutureBuilder(
              future: DbHelper.getAllParkingPointGet(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CupertinoActivityIndicator(
                    radius: 30,
                    color: AppColors.primaryColor,
                  );
                }
                log("length : ${snapshot.data!.docs.length}");
                List<ParkingModel> parkingModels = List.generate(
                    snapshot.data!.docs.length,
                    (index) => ParkingModel.fromMap(
                        snapshot.data!.docs[index].data()));
                log("length : ${parkingModels[0].gId} : g :${garageModel.gId}");
                List<ParkingModel> thisGarageParking = parkingModels
                    .where((element) => element.gId == garageModel.gId)
                    .toList();
                return thisGarageParking.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(" NO PARKING ADS"),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: thisGarageParking
                            .map((parkingModel) => Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Card(
                                    elevation: 5,
                                    color: parkingModel.isActive
                                        ? Colors.grey.shade100
                                        : Colors.red.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: AppColors.primaryColor
                                            .withOpacity(.5),
                                      ),
                                    ),
                                    child: Hero(
                                      tag: parkingModel.parkId!,
                                      child: ListTile(
                                        onTap: () {
                                          Get.to(
                                              ParkingInformationPage(
                                                  parkingModel: parkingModel),
                                              transition: Transition.fadeIn);
                                        },
                                        trailing: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: !parkingModel.isActive
                                                    ? Colors.red
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        AppColors.primaryColor,
                                                    width: 1)),
                                            child: Text(parkingModel.isActive
                                                ? "Available"
                                                : "InActive")),
                                        leading: CachedNetworkImage(
                                            imageUrl:
                                                "${parkingModel.parkImageList[0]}",
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                SpinKitSpinningLines(
                                                  color: AppColors.primaryColor,
                                                  size: 50.0,
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return CircleAvatar(
                                                radius: 20,
                                                backgroundImage: imageProvider,
                                              );
                                            }),
                                        title: Text(
                                          parkingModel.title,
                                          style: grayLowMediumColor,
                                        ),
                                        subtitle: Text(parkingModel.address),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      );
              },
            ),
          ]))
        ],
      ),
    );
  }

  _deactiveGarage(BuildContext context, GarageModel newGarageModel,
      GarageController garageController) async {
    try {
      log("Garage: ${newGarageModel.isActive}");
      startLoading('Wait');

      if (!newGarageModel.isActive) {
        log("if ${garageController.user.value!.isUserVerified}");
        if (garageController.user.value!.isUserVerified!) {
          EasyLoading.dismiss();
          await DbHelper.updateGarageInfo(newGarageModel.gId,
              {garageFieldIsActive: !newGarageModel.isActive});
          return;
        }
        showErrorToastMessage(
            message:
                'You Are Not Verified User So Please Wait for Admin Confirmation or Take Support');
        EasyLoading.dismiss();
      } else {
        log("Else");
        await DbHelper.updateGarageInfo(newGarageModel.gId,
            {garageFieldIsActive: !newGarageModel.isActive});
        EasyLoading.dismiss();
      }
    } catch (error) {
      EasyLoading.dismiss();
    }
  }
}

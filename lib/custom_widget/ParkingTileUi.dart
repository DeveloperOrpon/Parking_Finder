import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/model/parking_model.dart';
import 'package:parking_finder/pages/GarageOwner/add_parking_info.dart';

import '../model/garage_model.dart';
import '../pages/parking_information_page.dart';
import '../utilities/appConst.dart';
import '../utilities/app_colors.dart';
import '../utilities/testStyle.dart';

class ParkingTileUi extends StatelessWidget {
  final ParkingModel parkingModel;
  final GarageModel? garageModel;
  const ParkingTileUi(
      {Key? key, required this.parkingModel, required this.garageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
    return InkWell(
      onTap: () {
        Get.to(ParkingInformationPage(parkingModel: parkingModel),
            transition: Transition.fadeIn);
      },
      child: Stack(
        children: [
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            color: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: AppColors.primaryColor.withOpacity(.5),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        imageUrl: parkingModel.parkImageList[0],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                SpinKitSpinningLines(
                          color: AppColors.primaryColor,
                          size: 50.0,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          parkingModel.title,
                          style: blackPrimaryText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: FutureBuilder(
                            future: garageController.getLatLngToAddress(LatLng(
                              num.parse(parkingModel.lat).toDouble(),
                              num.parse(parkingModel.lon).toDouble(),
                            )),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CupertinoActivityIndicator();
                              }
                              log("snapshot ${snapshot.data}");
                              return Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                parkingModel.address,
                                style: grayNoSpaceLowSmallColor,
                              );
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    "${parkingModel.parkingCost} $currencySymbol  ",
                                style: blackPrimaryText,
                              ),
                              TextSpan(
                                text:
                                    "${parkingModel.capacityRemaining} spot Left",
                                style: grayNoSpaceLowSmallColor,
                              )
                            ]),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 1)),
                            child: const Text("Available"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
          if (garageModel != null)
            Positioned(
              right: 10,
              child: InkWell(
                onTap: () {
                  Get.to(
                      AddParkingInfoPage(
                          garageModel: garageModel!,
                          parkingModel: parkingModel),
                      transition: Transition.topLevel,
                      arguments: true);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1)),
                  child: const Text("Edit"),
                ),
              ),
            )
        ],
      ),
    );
  }
}

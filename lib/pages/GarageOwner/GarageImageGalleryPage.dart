import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/database/dbhelper.dart';
import 'package:parking_finder/model/garage_model.dart';
import 'package:parking_finder/pages/PreviewFullScreenImages.dart';
import 'package:parking_finder/services/Auth_service.dart';
import 'package:parking_finder/utilities/diaglog.dart';

import '../../utilities/app_colors.dart';
import '../../utilities/testStyle.dart';

class GarageImageGallery extends StatelessWidget {
  final GarageModel garageModel;

  const GarageImageGallery({Key? key, required this.garageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
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
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Icon(
              Icons.image,
              color: AppColors.primaryColor,
              size: 30,
            ),
            title: Text(
              'Images Of Garage',
              style: continueBlackTextStyle,
            ),
          ),
          Obx(() {
            return SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  childCount: garageController.garageList.value
                      .firstWhere((element) => element.gId == garageModel.gId)
                      .coverImage
                      .length,
                  (context, index) => Stack(
                        children: [
                          InkWell(
                            onTap: (AuthService.currentUser!.uid ==
                                    garageModel.ownerUId)
                                ? null
                                : () {
                                    Get.to(
                                        PreviewFullScreenImages(
                                            images: garageModel.coverImage),
                                        transition: Transition.zoom);
                                  },
                            child: Hero(
                              tag: garageModel.coverImage[0],
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 3)),
                                child: CachedNetworkImage(
                                  width: Get.width,
                                  height: Get.height,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${garageController.garageList.value.firstWhere((element) => element.gId == garageModel.gId).coverImage[index]}",
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
                          ),
                          if (garageModel.ownerUId ==
                              AuthService.currentUser!.uid)
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: 0,
                              top: 0,
                              child: IconButton(
                                  onPressed: () {
                                    _deleteAImageOfGarage(index);
                                  },
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    size: 30,
                                    color: Colors.red,
                                  )),
                            )
                        ],
                      )),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1.4),
            );
          })
        ],
      ),
    );
  }

  _deleteAImageOfGarage(int index) {
    if (garageModel.coverImage.length == 1) {
      showErrorToastMessage(message: 'You Can Not Delete ALL Images');
      return;
    }
    garageModel.coverImage.removeAt(index);
    DbHelper.updateGarageInfo(
        garageModel.gId, {"coverImage": garageModel.coverImage});
  }
}

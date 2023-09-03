import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parking_finder/custom_widget/ParkingTileUi.dart';
import 'package:parking_finder/model/garage_model.dart';
import 'package:parking_finder/pages/GarageOwner/updateGarage.dart';

import '../database/dbhelper.dart';
import '../model/parking_model.dart';
import '../utilities/app_colors.dart';
import '../utilities/testStyle.dart';

class GarageByParking extends StatelessWidget {
  final GarageModel garageModel;
  const GarageByParking({Key? key, required this.garageModel})
      : super(key: key);

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
          garageModel.name,
          style: continueBlackTextStyle,
        ),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: OutlinedButton(
                onPressed: () {
                  Get.to(UpdateGaragePage(garageModel: garageModel),
                      transition: Transition.fadeIn);
                },
                child: Text("Edit")),
          ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(garageModel.coverImage[0]),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  garageModel.name,
                  style: linkTextStyle,
                ),
              ),
            ),
            Center(
              child: Text(
                "${garageModel.city},${garageModel.division},(${garageModel.address})",
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
          SliverFillRemaining(
            child: FutureBuilder(
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
                  List<ParkingModel> parkingModels = List.generate(
                      snapshot.data!.docs.length,
                      (index) => ParkingModel.fromMap(
                          snapshot.data!.docs[index].data()));
                  List<ParkingModel> thisGarageParking = parkingModels
                      .where((element) => element.gId == garageModel.gId)
                      .toList();
                  return ListView.builder(
                    itemCount: thisGarageParking.length,
                    itemBuilder: (context, index) {
                      ParkingModel parkingModel = thisGarageParking[index];
                      return ParkingTileUi(
                          parkingModel: parkingModel, garageModel: garageModel);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}

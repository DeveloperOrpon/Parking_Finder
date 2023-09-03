import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/model/parking_model.dart';
import 'package:parking_finder/utilities/app_colors.dart';

import '../controller/GarageController.dart';
import '../custom_widget/appbar_with_title.dart';
import '../custom_widget/parking_slot_ui.dart';
import '../model/garage_model.dart';
import '../utilities/helper_function.dart';
import '../utilities/testStyle.dart';

class AvailableParkingSpacePage extends StatelessWidget {
  final GarageModel garageModel;
  final ParkingModel parkingModel;
  const AvailableParkingSpacePage(
      {Key? key, required this.garageModel, required this.parkingModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
    garageController.selectFloorIndex.value = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWithTitleSubTitleWhiteBG(
        context: context,
        title: garageModel.name,
        subTitle: garageModel.city + garageModel.division,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.primaryColor.withOpacity(.7),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(.7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 13,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Reserved",
                          style: smallWhiteTextStyle,
                        ),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                          radius: 13,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Non-Reserved",
                          style: smallWhiteTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    width: Get.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(
                              'Total Free Space : ${garageModel.totalSpace}'),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.center,
                              height: 40,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.primaryColor,
                              ),
                              child: Text("Floor ", style: whiteBoldText),
                            ),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: AppColors.primaryColor, width: 1)),
                              child: DefaultTabController(
                                initialIndex: 0,
                                //optional, starts from 0, select the tab by default
                                length:
                                    num.parse(garageModel.totalFloor).toInt(),
                                child: TabBar(
                                  onTap: (value) {
                                    garageController.selectFloorIndex.value =
                                        value;
                                  },
                                  isScrollable: true,
                                  dividerColor: AppColors.primaryColor,
                                  unselectedLabelColor: Colors.black,
                                  indicatorColor: Colors.grey,
                                  indicator: const BoxDecoration(
                                    color: Colors.greenAccent,
                                  ),
                                  tabs: List.generate(
                                    num.parse(garageModel.totalFloor).toInt(),
                                    (index) => Tab(
                                      child: Text(
                                          '${index + 1}${ordinal(index + 1)}'),
                                    ),
                                  ).toList(),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("ENTRY"),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ],
                    ),
                    Expanded(child: Obx(() {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 1.4),
                        itemCount: garageController.garageList.value
                            .firstWhere(
                                (element) => element.gId == garageModel.gId)
                            .floorDetails![
                                garageController.selectFloorIndex.value]
                            .spotInformation!
                            .length,
                        itemBuilder: (context, index) {
                          final parkingSpot = garageController.garageList.value
                              .firstWhere(
                                  (element) => element.gId == garageModel.gId)
                              .floorDetails![
                                  garageController.selectFloorIndex.value]
                              .spotInformation![index];
                          return ParkingSlot(
                            parkingModel: parkingModel,
                            spotInformation: parkingSpot,
                            isBooked: parkingSpot.isBooked,
                            isParked: parkingSpot.bookedUserId != null,
                            slotId: parkingSpot.spotId ?? "",
                            time: 1.toString(),
                            slotName: parkingSpot.spotName ?? '',
                          );
                        },
                      );
                    })),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("EXIT"),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

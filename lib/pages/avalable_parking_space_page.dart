import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:provider/provider.dart';

import '../custom_widget/appbar_with_title.dart';
import '../custom_widget/parking_slot_ui.dart';
import '../providers/map_provider.dart';
import '../utilities/testStyle.dart';

class AvailableParkingSpacePage extends StatelessWidget {
  const AvailableParkingSpacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWithTitleSubTitleWhiteBG(
          context: context,
          title: "Usaman Parking House",
          subTitle: '📍 2.0 km Away',
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 160,
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
                      height: 100,
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
                            child: const Text('Total Free Space : 120'),
                          ),
                          Row(
                            children: [
                              Text("Floor ", style: blackBoldText),
                              Expanded(
                                child: CupertinoSegmentedControl(
                                  padding: const EdgeInsets.all(10),
                                  children: const {
                                    0: Text("1st"),
                                    1: Text("2nd"),
                                    2: Text("3nd"),
                                  },
                                  onValueChanged: (value) {
                                    mapProvider.selectFloor = value;
                                  },
                                  selectedColor: AppColors.primaryColor,
                                  unselectedColor: CupertinoColors.white,
                                  borderColor: AppColors.primaryColor,
                                  pressedColor: CupertinoColors.inactiveGray,
                                  groupValue: mapProvider.selectFloor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              mapProvider.selectFloor == 0
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: const [
                                      Text("ENTRY"),
                                      Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                      child: ParkingSlot(
                                    isBooked: false,
                                    isParked: false,
                                    slotId: '1',
                                    time: "0.0",
                                    slotName: "A-1",
                                  )),
                                  const SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: VerticalDivider(
                                      color: Colors.blue,
                                      thickness: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: ParkingSlot(
                                      isBooked: false,
                                      isParked: false,
                                      slotId: '1',
                                      time: 1.toString(),
                                      slotName: "A-2",
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                      child: ParkingSlot(
                                    isBooked: true,
                                    isParked: true,
                                    slotId: '1',
                                    time: 1.toString(),
                                    slotName: "A-3",
                                  )),
                                  const SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: VerticalDivider(
                                      color: Colors.blue,
                                      thickness: 1,
                                    ),
                                  ),
                                  Expanded(
                                      child: ParkingSlot(
                                    isBooked: true,
                                    isParked: true,
                                    slotId: '2239',
                                    time: 1.toString(),
                                    slotName: "A-4",
                                  ))
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                      child: ParkingSlot(
                                    isBooked: false,
                                    isParked: false,
                                    slotId: '1',
                                    time: 1.toString(),
                                    slotName: "A-5",
                                  )),
                                  const SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: VerticalDivider(
                                      color: Colors.blue,
                                      thickness: 1,
                                    ),
                                  ),
                                  Expanded(
                                      child: ParkingSlot(
                                    isBooked: false,
                                    isParked: false,
                                    slotId: '1',
                                    time: 1.toString(),
                                    slotName: "A-6",
                                  ))
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                      child: ParkingSlot(
                                    isBooked: false,
                                    isParked: false,
                                    slotId: '1',
                                    time: 1.toString(),
                                    slotName: "A-7",
                                  )),
                                  const SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: VerticalDivider(
                                      color: Colors.blue,
                                      thickness: 1,
                                    ),
                                  ),
                                  Expanded(
                                      child: ParkingSlot(
                                    isBooked: false,
                                    isParked: false,
                                    slotId: '1',
                                    time: 1.toString(),
                                    slotName: "A-8",
                                  ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: const [
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
                      ),
                    )
                  : const Expanded(
                      child: Text('Row Create '),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

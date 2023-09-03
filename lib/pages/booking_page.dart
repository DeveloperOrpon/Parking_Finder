import 'dart:developer';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_finder/controller/ParkingController.dart';
import 'package:parking_finder/model/parking_model.dart';
import 'package:parking_finder/pages/select_vehicle_page.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../custom_widget/appbar_with_title.dart';
import '../model/booking_model.dart';
import '../model/garage_model.dart';
import '../providers/booking_provider.dart';
import '../services/Auth_service.dart';
import '../utilities/appConst.dart';
import '../utilities/helper_function.dart';

class BookingPage extends StatefulWidget {
  final SpotInformation slotInformation;
  final ParkingModel parkingModel;

  const BookingPage(
      {super.key, required this.slotInformation, required this.parkingModel});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  ParkingCategoryModel? parkingCategoryModel;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String? customCost;
  int s = 0;
  int e = 0;

  @override
  Widget build(BuildContext context) {
    final parkingController = Get.put(ParkingController());
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) => Scaffold(
        backgroundColor: Colors.white70,
        appBar: appBarWithTitleWhiteBG(context: context, title: "BOOK SLOT"),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animation/running_car.json',
                            width: Get.width - 20,
                            height: 110,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Your Car Information",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(SelectVehiclePage(),
                                    transition: Transition.leftToRightWithFade);
                              },
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                      Obx(() {
                        return ExpansionTile(
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          title: const Text(
                            "Car Name (Brand & Model) :",
                          ),
                          subtitle: Text(
                            parkingController.selectCar.value == null
                                ? 'No Car Select'
                                : parkingController.selectCar.value!.vehicle! +
                                    "," +
                                    parkingController.selectCar.value!.model!,
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                          childrenPadding: EdgeInsets.all(10),
                          children: parkingController.selectCar.value == null
                              ? []
                              : [
                                  Row(
                                    children: [
                                      const Text(
                                        "Car Name Plat:",
                                      ),
                                      Text(
                                        parkingController
                                            .selectCar.value!.plateNumber!,
                                        style: TextStyle(
                                            color: AppColors.primaryColor),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "vehicleType:",
                                      ),
                                      Text(
                                        parkingController
                                            .selectCar.value!.vehicleType!,
                                        style: TextStyle(
                                            color: AppColors.primaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                        );
                      }),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Parking Categories Available:"),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    widget.parkingModel.parkingCategorys.length,
                                itemBuilder: (BuildContext context, int index) {
                                  ParkingCategoryModel categoryModel = widget
                                      .parkingModel.parkingCategorys[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FilterChip(
                                      padding: EdgeInsets.all(8),
                                      label: Text(categoryModel.categoryName! +
                                          " | " +
                                          categoryModel.categoryRate
                                              .toString() +
                                          currencySymbol +
                                          " | " +
                                          getParkingTime(
                                              categoryModel.categoryDuration!)),
                                      onSelected: (bool value) {
                                        setState(() {
                                          customCost = null;
                                          if (categoryModel ==
                                              parkingCategoryModel) {
                                            parkingCategoryModel = null;
                                          } else {
                                            parkingCategoryModel =
                                                categoryModel;
                                          }
                                        });
                                      },
                                      selected:
                                          categoryModel == parkingCategoryModel,
                                      selectedColor: AppColors.primaryColor,
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      backgroundColor: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                      ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                        title: const Text(
                          "Select Custom Time(Day) Calender:",
                        ),
                        subtitle: Text(
                          "1 Day",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        children: [
                          SfDateRangePicker(
                            headerHeight: 40,
                            backgroundColor: Colors.grey.shade100,
                            enablePastDates: false,
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              setState(() {
                                parkingCategoryModel = null;
                                if (args.value is PickerDateRange) {
                                  s = num.parse(DateFormat('dd')
                                          .format(args.value.startDate))
                                      .toInt();
                                  e = num.parse(DateFormat('dd').format(
                                          args.value.endDate ??
                                              args.value.startDate))
                                      .toInt();

                                  if (s > e) {
                                    e = e + 30;
                                  }
                                  customCost = (num.parse(
                                              widget.parkingModel.parkingCost) *
                                          ((e - s) + 1))
                                      .toString();
                                  log("$s - $e : $customCost");
                                  _range =
                                      '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
                                      // ignore: lines_longer_than_80_chars
                                      ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
                                } else if (args.value is DateTime) {
                                  _selectedDate = args.value.toString();
                                } else if (args.value is List<DateTime>) {
                                  _dateCount = args.value.length.toString();
                                } else {
                                  _rangeCount = args.value.length.toString();
                                }
                              });
                            },
                            selectionMode: DateRangePickerSelectionMode.range,
                            initialSelectedRange: PickerDateRange(
                                DateTime.now()
                                    .subtract(const Duration(days: 4)),
                                DateTime.now().add(const Duration(days: 3))),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Start Time",
                                    style: continueBlackTextStyle),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    bookingProvider.showDatePickerDialog(
                                        context, true);
                                  },
                                  label: Text(
                                      bookingProvider.selectStartTime ?? "0.0"),
                                  icon: const Icon(Icons.alarm),
                                ),
                              ],
                            ),
                            const Text("_____"),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("End Time", style: continueBlackTextStyle),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    bookingProvider.showDatePickerDialog(
                                        context, false);
                                  },
                                  label: Text(
                                      bookingProvider.selectEndTime ?? "0.0"),
                                  icon: const Icon(Icons.alarm),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Select Slot",
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.slotInformation.spotName ?? "",
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Select Floor",
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${widget.slotInformation.floor}",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      GFAccordion(
                          collapsedTitleBackgroundColor: AppColors.primaryColor,
                          contentBackgroundColor:
                              AppColors.primaryColor.withOpacity(.2),
                          title: 'Apply Coupons',
                          collapsedIcon: Text('Appy'),
                          contentChild: Row(
                            children: [
                              const Expanded(child: TextField()),
                              GFButton(
                                onPressed: () => GFToast.showToast(
                                    'Coupons Is No Available Right Now',
                                    context,
                                    toastPosition: GFToastPosition.CENTER,
                                    backgroundColor: Colors.red),
                                text: "Apply",
                              ),
                            ],
                          ),
                          expandedIcon: Text('Hide')),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              DottedBorder(
                color: AppColors.primaryColor, //color of dotted/dash line
                strokeWidth: 1, //thickness of dash/dots
                dashPattern: const [10, 6],

                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text("Amount to Be Pay"),
                            ],
                          ),
                          AnimatedFlipCounter(
                            curve: Curves.bounceInOut,
                            duration: const Duration(milliseconds: 500),
                            prefix: currencySymbol,
                            textStyle: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                            value: customCost != null
                                ? num.parse(customCost!)
                                : (parkingCategoryModel == null)
                                    ? num.parse(widget.parkingModel.parkingCost)
                                    : num.parse(parkingCategoryModel!
                                        .categoryRate!), // pass in a value like 2014
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          _booking(parkingController);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 60, vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "PAY NOW",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  void _booking(ParkingController parkingController) {
    if (parkingController.selectCar.value == null) {
      GFToast.showToast(
        'Please Select Car Information',
        context,
        backgroundColor: Colors.red,
      );
      return;
    }
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String endTimeBooked = customCost != null
        ? (Duration(days: (e - s) + 1).inMilliseconds.toString())
        : (parkingCategoryModel == null)
            ? (const Duration(hours: 1).inMilliseconds.toString())
            : (parkingCategoryModel!.categoryDuration!);
    widget.slotInformation.bookedUserId = AuthService.currentUser!.uid;
    widget.slotInformation.isBooked = true;
    widget.slotInformation.bookedTime =
        DateTime.now().millisecondsSinceEpoch.toString();
    widget.slotInformation.expereTime = endTimeBooked;
    widget.slotInformation.bookedUserId = id;
    widget.slotInformation.carId = parkingController.selectCar.value!.vId;
    BookingModel bookingModel = BookingModel(
      bId: id,
      garageGId: widget.parkingModel.gId,
      spotInformation: widget.slotInformation,
      parkingPId: widget.parkingModel.parkId ?? '',
      userUId: AuthService.currentUser!.uid,
      duration: parkingCategoryModel != null
          ? parkingCategoryModel!.categoryDuration!
          : _range,
      cost: customCost != null
          ? (customCost!)
          : (parkingCategoryModel == null)
              ? (widget.parkingModel.parkingCost)
              : (parkingCategoryModel!.categoryRate!),
      bookingTime: Timestamp.now(),
      onlinePayment: false,
      selectVehicleType: parkingController.selectCar.value!,
      endTime: endTimeBooked,
    );
    // log(bookingModel.toMap().toString());
    parkingController.addBookingInfo(bookingModel);
  }
}

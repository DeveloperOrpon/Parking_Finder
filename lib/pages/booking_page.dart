import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_finder/pages/select_vehicle_page.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../custom_widget/appbar_with_title.dart';
import '../providers/booking_provider.dart';
import '../utilities/appConst.dart';

class BookingPage extends StatelessWidget {
  final String slotName;
  final String slotId;

  const BookingPage({super.key, required this.slotId, required this.slotName});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) => Scaffold(
        backgroundColor: Colors.white70,
        appBar: appBarWithTitleWhiteBG(context: context, title: "BOOK SLOT"),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animation/running_car.json',
                      width: Get.width - 20,
                      height: 130,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                          Get.to(const SelectVehiclePage(),
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
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                  title: const Text(
                    "Car Name (Brand & Model) :",
                  ),
                  subtitle: Text(
                    "Tesla X-12 2023",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Car Name Plat:",
                        ),
                        Text(
                          "X-122023",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Car Chassis Number:",
                        ),
                        Text(
                          "X-12267642023",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                  title: const Text(
                    "Select Time(Day) Calender:",
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
                          (dateRangePickerSelectionChangedArgs) {},
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 4)),
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
                          Text("Start Time", style: continueBlackTextStyle),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () {
                              bookingProvider.showDatePickerDialog(
                                  context, true);
                            },
                            label:
                                Text(bookingProvider.selectStartTime ?? "0.0"),
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
                            label: Text(bookingProvider.selectEndTime ?? "0.0"),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  slotName,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "1F",
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
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: const [
                            Text("Amount to Be Pay"),
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              '$currencySymbol 12',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 20),
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
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:dotted_border/dotted_border.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/utilities/app_colors.dart';

import '../pages/booking_page.dart';

class ParkingSlot extends StatelessWidget {
  final bool? isParked;
  final bool? isBooked;
  final String? slotName;
  final String slotId;
  final String time;

  const ParkingSlot({
    super.key,
    this.isParked,
    this.isBooked,
    this.slotName,
    this.slotId = "0.0",
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Entry(
      opacity: .5,
      scale: .5,
      delay: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 700),
      child: DottedBorder(
        color: AppColors.primaryColor, //color of dotted/dash line
        strokeWidth: 1, //thickness of dash/dots
        dashPattern: const [10, 6],
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 180,
          height: 120,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  time == "0.0" ? const SizedBox(width: 1) : Text(time),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.shade100,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      slotName.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Text("")
                ],
              ),
              const SizedBox(height: 10),
              if (isBooked == true && isParked == true)
                Expanded(
                  child: Transform.rotate(
                    angle: slotId == '2239' ? math.pi : 0,
                    child: Image.asset("assets/image/car.png"),
                  ),
                )
              else if (isBooked == true)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "BOOKED",
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(
                            const BookingPage(
                              slotId: '2239',
                              slotName: 'A1',
                            ),
                            transition: Transition.leftToRightWithFade);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 30),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "BOOK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

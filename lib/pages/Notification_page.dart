import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:shimmer/shimmer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWithTitleWhiteBG(context: context, title: "Notification"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text("Today", style: blackBoldText),
            Stack(
              children: [
                if (!isLoading)
                  Container(
                    height: 66,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            spreadRadius: 2,
                          )
                        ]),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Parking Booking Canceled!",
                                style: blackBoldText),
                            const Text("Your Parking Booking Canceled!",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                if (isLoading)
                  Shimmer(
                    period: const Duration(seconds: 1),
                    gradient: LinearGradient(
                      colors: [AppColors.primaryColor, Colors.transparent],
                    ),
                    child: Container(
                      height: 66,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Stack(
              children: [
                if (!isLoading)
                  Container(
                    height: 66,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            spreadRadius: 2,
                          )
                        ]),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment Successful!", style: blackBoldText),
                            const Text("Your Parking Booking Successful!",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                if (isLoading)
                  Shimmer(
                    period: const Duration(seconds: 1),
                    gradient: const LinearGradient(
                      colors: [Colors.grey, Colors.transparent],
                    ),
                    child: Container(
                      height: 66,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

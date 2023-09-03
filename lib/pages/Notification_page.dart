import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/GarageController.dart';
import '../utilities/app_colors.dart';
import '../utilities/helper_function.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  final garageController = Get.put(GarageController());
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 2),
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
        child: Obx(() {
          return Column(
            children: [
              garageController.allNotificationModel.isNotEmpty
                  ? Text("Notification History", style: blackBoldText)
                  : Expanded(
                      child: Text("No Notification", style: blackBoldText)),
              if (!isLoading)
                Expanded(
                  child: ListView.builder(
                    itemCount: garageController.allNotificationModel.length,
                    itemBuilder: (context, index) {
                      final notification =
                          garageController.allNotificationModel[index];
                      return Container(
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
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                FontAwesomeIcons.clipboardCheck,
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notification.title, style: blackBoldText),
                                Text(
                                    getNotificationTimeFormat(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            num.parse(notification.id)
                                                .toInt())),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    )),
                              ],
                            )
                          ],
                        ),
                      );
                    },
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
          );
        }),
      ),
    );
  }
}

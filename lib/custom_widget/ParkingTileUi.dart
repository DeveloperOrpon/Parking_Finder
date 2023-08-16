import 'package:flutter/material.dart';

import '../utilities/appConst.dart';
import '../utilities/app_colors.dart';
import '../utilities/testStyle.dart';

class ParkingTileUi extends StatelessWidget {
  const ParkingTileUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                child: Image.asset(
                  appLogo,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
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
                    "Mirput 10 Parking Spot ",
                    style: blackPrimaryText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "Mirput 10 Parking Spot ",
                    style: grayNoSpaceLowSmallColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "'\$5.80 ",
                          style: blackPrimaryText,
                        ),
                        TextSpan(
                          text: "12 spot Left",
                          style: grayNoSpaceLowSmallColor,
                        )
                      ]),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1)),
                      child: const Text("Available"),
                    )
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

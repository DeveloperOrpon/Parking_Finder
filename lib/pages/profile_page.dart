import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:parking_finder/pages/login_page.dart';
import 'package:parking_finder/pages/select_vehicle_page.dart';
import 'package:parking_finder/pages/setting_page.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../utilities/app_colors.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final UserProvider userProvider;

  const ProfilePage({Key? key, required this.userProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (userProvider.user == null)
              CupertinoButton.filled(
                child: Text("Login"),
                onPressed: () {
                  Get.to(LoginPage(), transition: Transition.fadeIn);
                },
              ),
            if (userProvider.user != null)
              RippleAnimation(
                color: AppColors.primaryColor,
                delay: const Duration(milliseconds: 300),
                repeat: true,
                minRadius: 50,
                ripplesCount: 6,
                duration: const Duration(milliseconds: 6 * 300),
                child: Entry(
                  opacity: .5,
                  angle: 3.1415,
                  scale: .5,
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.decelerate,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: userProvider.user!.profileUrl != null
                          ? CachedNetworkImage(
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageUrl: "${userProvider.user!.profileUrl}",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      SpinKitSpinningLines(
                                color: AppColors.primaryColor,
                                size: 50.0,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : const CircleAvatar(
                              radius: 40,
                            ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (userProvider.user != null)
              Text(
                "${userProvider.user!.name}",
                style: blackBoldText,
              ),
            if (userProvider.user != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userProvider.user!.email ?? "No Email Set Yet",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (userProvider.user!.isUserVerified!)
                    const Icon(
                      Icons.verified,
                      color: Colors.green,
                    )
                ],
              ),
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1,
                  )),
              child: Text(
                "AC : ${userProvider.user!.role!.toUpperCase()}",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (userProvider.user != null) const SizedBox(height: 20),
            if (userProvider.user != null)
              Entry(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 300),
                opacity: .2,
                curve: Curves.easeInOutCubic,
                child: CupertinoButton(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  onPressed: () {
                    startLoading("Wait");
                    userProvider.intController(context);

                    Get.to(const EditProfilePage(),
                        transition: Transition.rightToLeftWithFade,
                        arguments: userProvider);
                  },
                  child: Text(
                    "Edit Profile",
                    style: whiteBoldText,
                  ),
                ),
              ),
            if (userProvider.user == null) const SizedBox(height: 50),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Divider(
                color: Colors.grey,
                height: 2,
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              onTap: () {
                Get.to(const SettingPage(),
                    transition: Transition.leftToRightWithFade);
              },
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Entry(
                  opacity: .5,
                  angle: 3.1415,
                  scale: .5,
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  child: Icon(
                    Icons.settings,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              title: Entry(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 300),
                opacity: 0,
                curve: Curves.easeInOutCubic,
                child: Text(
                  "Settings",
                  style: blackBoldText,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Entry(
                  opacity: .5,
                  angle: 3.1415,
                  scale: .5,
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  child: Icon(
                    Icons.garage_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              title: Entry(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 300),
                opacity: 0,
                curve: Curves.easeInOutCubic,
                child: Text(
                  "Parking Details",
                  style: blackBoldText,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Entry(
                  opacity: .5,
                  angle: 3.1415,
                  scale: .5,
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  child: Icon(
                    Icons.verified_user,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              title: Entry(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 300),
                opacity: 0,
                curve: Curves.easeInOutCubic,
                child: Text(
                  "Booking Information",
                  style: blackBoldText,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Divider(
                color: Colors.grey,
                height: 2,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(SelectVehiclePage(), transition: Transition.fadeIn);
              },
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Entry(
                  opacity: .5,
                  angle: 3.1415,
                  scale: .5,
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  child: Icon(
                    Icons.car_repair_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              title: Entry(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 300),
                opacity: 0,
                curve: Curves.easeInOutCubic,
                child: Text(
                  "My Vehicle Information",
                  style: blackBoldText,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Entry(
                  opacity: .5,
                  angle: 3.1415,
                  scale: .5,
                  delay: const Duration(milliseconds: 700),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  child: Icon(
                    Icons.monetization_on,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              title: Entry(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 300),
                opacity: 0,
                curve: Curves.easeInOutCubic,
                child: Text(
                  "Transition Information",
                  style: blackBoldText,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          top: 20,
          child: Entry(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300),
            opacity: 0,
            child: SvgPicture.asset(
              'assets/image/bubbles.svg',
              color: AppColors.primaryColor,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 20,
          child: Entry(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300),
            opacity: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: SvgPicture.asset(
                'assets/image/bubbles.svg',
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

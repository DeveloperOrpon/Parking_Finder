import 'package:cached_network_image/cached_network_image.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:parking_finder/pages/home_page.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:provider/provider.dart';

import '../api/authenticate_service.dart';
import '../pages/Notification_page.dart';
import '../pages/support_page.dart';
import '../utilities/diaglog.dart';
import '../utilities/testStyle.dart';
import 'menu_item.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.version == '') {
          userProvider.getVersion();
        }
        return ZoomDrawer(
          menuBackgroundColor: Colors.white,
          controller: userProvider.drawerController,
          style: DrawerStyle.defaultStyle,
          menuScreen: Theme(
            data: ThemeData.dark(),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                height: Get.height,
                padding: const EdgeInsets.only(left: 25, top: 60),
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Entry(
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
                                child: userProvider.userModel!.userinfo![0]
                                            .profileImage !=
                                        null
                                    ? CachedNetworkImage(
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${userProvider.userModel!.userinfo![0].profileImage}",
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                SpinKitSpinningLines(
                                          color: AppColors.primaryColor,
                                          size: 40.0,
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
                          Positioned(
                            right: -Get.width * .56,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                userProvider.drawerController.close!();
                              },
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                color: AppColors.primaryColor,
                              )),
                              label: const Text(
                                "Slide Here To Back",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.green,
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        "${userProvider.userModel!.userinfo![0].username}",
                        style: blackBoldText,
                      ),
                      const SizedBox(height: 6),
                      Divider(
                        thickness: 4,
                        color: AppColors.primaryColor.withOpacity(.4),
                      ),
                      ...mainMenu
                          .map(
                            (item) => MenuItemWidget(
                              key: Key(item.index.toString()),
                              item: item,
                              callback: (index) {
                                userProvider.selectNavDrawer = index;
                                if (item.title == 'Notifications') {
                                  Get.to(const NotificationPage(),
                                          transition:
                                              Transition.rightToLeftWithFade)
                                      ?.then((value) {
                                    Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () {
                                        userProvider.drawerController.close!();
                                      },
                                    );
                                  });
                                } else if (item.title == 'Profile') {
                                  userProvider.drawerController.close!();
                                  userProvider.pageController.jumpToPage(3);
                                  userProvider.selectBottomBar = 3;
                                } else if (item.title == 'Support') {
                                  Get.to(const SupportPage(),
                                          transition:
                                              Transition.rightToLeftWithFade)
                                      ?.then((value) {
                                    Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () {
                                        userProvider.drawerController.close!();
                                      },
                                    );
                                  });
                                }
                              },
                              widthBox: const SizedBox(width: 16.0),
                              selected:
                                  userProvider.selectNavDrawer == item.index,
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 6),
                      Divider(
                        thickness: 4,
                        color: AppColors.primaryColor.withOpacity(.4),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            label: const Text("Logout"),
                            icon: const Icon(Icons.login_rounded),
                            onPressed: () {
                              startLoading('LogOut....');
                              AuthenticateService.logout();
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Version : ${userProvider.version}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          mainScreen: const HomePageMap(),
          borderRadius: 24.0,
          showShadow: true,
          angle: 0.0,
          drawerShadowsBackgroundColor: AppColors.primaryColor,
          slideWidth: MediaQuery.of(context).size.width * .7,
          openCurve: Curves.fastOutSlowIn,
          closeCurve: Curves.bounceIn,
        );
      },
    );
  }
}

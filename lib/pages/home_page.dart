import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/pages/parking_list_page.dart';
import 'package:parking_finder/pages/profile_page.dart';
import 'package:parking_finder/pages/search_page.dart';
import 'package:parking_finder/providers/map_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../custom_widget/map_parking_ui.dart';
import '../providers/user_provider.dart';
import '../utilities/testStyle.dart';
import 'GarageOwner/owner_garage_page.dart';
import 'home_page_content_map.dart';

class HomePageMap extends StatelessWidget {
  const HomePageMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("Home Page");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.primaryColor, // navigation bar color
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
    ));
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Consumer<MapProvider>(
          builder: (context, mapProvider, child) => Scaffold(
            backgroundColor: Colors.white,
            appBar: _homeAppBar(userProvider, mapProvider),
            body: Stack(
              children: [
                Container(
                  height: Get.height,
                ),
                PageView(
                  scrollBehavior: const ScrollBehavior(),
                  physics: const PageScrollPhysics(),
                  controller: userProvider.pageController,
                  onPageChanged: (value) {
                    userProvider.searchFocusNode.unfocus();
                    userProvider.selectBottomBar = value;
                  },
                  children: [
                    const HomePageContent(),
                    const SearchPage(),
                    ParkingListPage(userProvider: userProvider),
                    // if (userProvider.userModel!.email ==
                    //     "onlineadasalipi@gmail.com")
                    const OwnerGaragePage(),
                    ProfilePage(userProvider: userProvider),
                  ],
                ),
                _bottomNavigationBar(userProvider, mapProvider),
                if (userProvider.selectBottomBar == 0)
                  Positioned(
                    right: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: mapProvider.isShowAds ? 0 : 1,
                      child: ElevatedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          mapProvider.isShowAds = !mapProvider.isShowAds;
                        },
                        icon: const Icon(
                          FontAwesomeIcons.mapLocation,
                          color: Colors.white,
                        ),
                        label: const Text("Nearby"),
                      ),
                    ),
                  ),
                if (userProvider.selectBottomBar == 0 && mapProvider.isShowAds)
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: mapProvider.isShowAds ? 1 : 0,
                    child: Container(
                      height: 140,
                      padding: const EdgeInsets.only(
                          left: 22.0, right: 22, bottom: 4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              userProvider.pageController.jumpToPage(1);
                              userProvider.selectBottomBar = 1;
                            },
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                suffixIcon: const Icon(
                                  Icons.mic,
                                  color: Colors.grey,
                                ),
                                hintText: 'Search',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Recent Garages",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(6.0),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: Get.width * .4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          color: AppColors.primaryColor,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Sheikh Zayed",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "Downtown,10 min",
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: Get.width * .4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          color: AppColors.primaryColor,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Sheikh Zayed",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "Downtown,10 min",
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * .4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          color: AppColors.primaryColor,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Sheikh Zayed",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "Downtown,10 min",
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: Get.width * .4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          color: AppColors.primaryColor,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Sheikh Zayed",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "Downtown,10 min",
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _homeAppBar(UserProvider userProvider, MapProvider mapProvider) {
    return userProvider.selectBottomBar == 0
        ? AppBar(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                userProvider.searchFocusNode.unfocus();
                userProvider.drawerController.toggle!();
              },
              icon: Icon(
                Icons.menu,
                color: AppColors.primaryColor,
              ),
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userProvider.user != null)
                  Text(
                    "Hi, ${userProvider.user!.username}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                const Text(
                  "Where do you want to park?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    // Get.to(MapOfOpenApi());
                    mapProvider.gotoMyLocation();
                  },
                  icon: Icon(
                    Icons.my_location,
                    color: AppColors.primaryColor,
                  ))
            ],
          )
        : AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              userProvider.selectBottomBar == 1
                  ? "Search"
                  : userProvider.selectBottomBar == 2
                      ? "Parking Post"
                      : userProvider.selectBottomBar == 3
                          ? "Add Garage Places"
                          : "Profile",
              style: blackBoldText,
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                userProvider.searchFocusNode.unfocus();
                userProvider.drawerController.toggle!();
              },
              icon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.menu,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
            ));
  }

  Positioned _bottomNavigationBar(
      UserProvider userProvider, MapProvider mapProvider) {
    return Positioned(
      bottom: userProvider.selectBottomBar == 0 ? null : 8,
      child: Container(
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: userProvider.selectBottomBar == 0 && mapProvider.isShowAds
              ? Get.height - 313
              : Get.height - 173,
        ),
        child: Column(
          children: [
            if (userProvider.selectBottomBar == 0 && mapProvider.isShowAds)
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    MapParkingUi(),
                    MapParkingUi(),
                    MapParkingUi(),
                  ],
                ),
              ),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              width: mapProvider.isShowAds ? Get.width - 20 : Get.width - 20,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(1, 1),
                    )
                  ]),
              child: SalomonBottomBar(
                currentIndex: userProvider.selectBottomBar,
                onTap: (p0) {
                  userProvider.pageController.jumpToPage(p0);
                  userProvider.selectBottomBar = p0;
                },
                items: [
                  /// Home
                  SalomonBottomBarItem(
                    icon: const Icon(FontAwesomeIcons.houseChimney),
                    title: const Text("Home"),
                    selectedColor: AppColors.primaryColor,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(FontAwesomeIcons.search),
                    title: const Text("Search"),
                    selectedColor: AppColors.primaryColor,
                  ),

                  /// Search
                  SalomonBottomBarItem(
                    icon: const Icon(FontAwesomeIcons.parking),
                    title: const Text("Parking"),
                    selectedColor: AppColors.primaryColor,
                  ),

                  /// Garage Owner
                  // if (userProvider.userModel!.email ==
                  //     "onlineadasalipi@gmail.com")
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.add_location_alt_sharp),
                    title: const Text("Add"),
                    selectedColor: AppColors.primaryColor,
                  ),

                  /// Profile
                  SalomonBottomBarItem(
                    icon: const Icon(FontAwesomeIcons.userLarge),
                    title: const Text("Profile"),
                    selectedColor: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  BackdropFilter _buildExitDialog(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Please confirm',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Do you want to exit the app?',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'No',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text(
              'Yes',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

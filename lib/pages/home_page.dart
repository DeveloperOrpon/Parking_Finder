import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/controller/GarageController.dart';
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
import '../utilities/var_const.dart';
import 'GarageOwner/SingleGaragePreview.dart';
import 'GarageOwner/owner_garage_page.dart';
import 'home_page_content_map.dart';

class HomePageMap extends StatelessWidget {
  const HomePageMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
    log("Home Page");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.primaryColor, // navigation bar color
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
    ));
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return WillPopScope(
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
                      if (userProvider.user != null &&
                          userProvider.user!.role == appUser[1])
                        const OwnerGaragePage(),
                      ProfilePage(userProvider: userProvider),
                    ],
                  ),
                  _bottomNavigationBar(
                      userProvider, mapProvider, garageController),
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
                  if (userProvider.selectBottomBar == 0 &&
                      mapProvider.isShowAds)
                    SlideInDown(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.only(
                            left: 22.0, right: 22, bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor,
                              blurRadius: 0,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
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
                              "Recent Garages on Map",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              height: 60,
                              padding:
                                  const EdgeInsets.only(top: 6.0, bottom: 6),
                              child: Obx(() {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: garageController.garageList.length,
                                  itemBuilder: (context, index) {
                                    final garage =
                                        garageController.garageList[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                            SingleGaragePreview(
                                                garageModel: garage),
                                            transition: Transition.downToUp);
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 3, bottom: 3),
                                          width: Get.width * .4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: CachedNetworkImage(
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "${garage.coverImage[0]}",
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              SpinKitSpinningLines(
                                                        color: AppColors
                                                            .primaryColor,
                                                        size: 50.0,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      garage.name,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      garage.city +
                                                          garage.division,
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 10,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 2,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
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
                    "Hi, ${userProvider.user!.name}",
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

  Positioned _bottomNavigationBar(UserProvider userProvider,
      MapProvider mapProvider, GarageController garageController) {
    return Positioned(
      bottom: userProvider.selectBottomBar == 0 ? null : 8,
      child: SlideInUp(
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
                SlideInUp(
                  child: SizedBox(
                    height: 140,
                    child: Obx(() {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            garageController.allActiveParking.value.length,
                        itemBuilder: (context, index) {
                          final parkingAds =
                              garageController.allActiveParking.value[index];
                          return MapParkingUi(
                            parkingModel: parkingAds,
                          );
                        },
                      );
                    }),
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
                    if (userProvider.user != null &&
                        userProvider.user!.role == appUser[1])
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

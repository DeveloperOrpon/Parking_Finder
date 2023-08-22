import 'dart:convert' as convert;
import 'dart:developer';

import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:parking_finder/preference/user_preference.dart';
import 'package:parking_finder/utilities/appConst.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';

import '../custom_widget/navigation_drawer.dart';
import '../model/user_model.dart';
import '../providers/map_provider.dart';
import '../providers/user_provider.dart';
import '../utilities/diaglog.dart';
import 'login_page.dart';
import 'onboarding_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    startLoading("Loading...");
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        final provider = Provider.of<UserProvider>(context, listen: false);
        bool isShowOnboarding = await getOnboardingStatus();
        bool isLogin = await getLoginStatus();

        log("isLoginState : $isLogin");

        if (isLogin) {
          final jwtToken = await getJWTToken();
          final userInfo = await getUserInfo();
          final searchList = await provider.getSearchAllList();

          log("jwtToken : $jwtToken");
          log("SearchList : $searchList");
          log("UserInfo $userInfo");
          Provider.of<MapProvider>(context, listen: false).mapParkingIcon();
          Provider.of<MapProvider>(context, listen: false).getCurrentLocation();
          var jsonResponse =
              convert.jsonDecode(userInfo) as Map<String, dynamic>;
          log(jsonResponse.runtimeType.toString());
          UserModel userModel = UserModel.fromJson(jsonResponse);
          log("UserModel ${userModel.email}");
          provider.user = userModel;
          provider.jwtToken = jwtToken;
          EasyLoading.dismiss();
          Get.offAll(const CustomNavigationDrawer(),
              transition: Transition.fadeIn);
        } else {
          EasyLoading.dismiss();
          isShowOnboarding
              ? Get.offAll(const LoginPage(), transition: Transition.fadeIn)
              : Get.offAll(const OnboardingPage(),
                  transition: Transition.fadeIn);
        }
      },
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, .6]),
        ),
        child: Stack(
          children: [
            Image.asset(
              appBackgroundImage,
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
            Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 1]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Welcome to",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedEmoji(
                        AnimatedEmojis.wave(),
                        size: 36,
                        repeat: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'The best parking app of the county for all people in Bangladesh',
                    style: whiteText,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

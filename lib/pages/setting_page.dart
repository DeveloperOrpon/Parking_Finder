import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Setting",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryColor,
              size: 32,
            ),
          ),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  settingItem(
                    subTitle: "Notifications",
                    icon: CupertinoIcons.bell,
                    onTap: () {},
                    trailing: true,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey.shade300),
                  settingItem(
                    subTitle: "Your Location",
                    title: provider.user!.location!,
                    icon: CupertinoIcons.location_fill,
                    onTap: () {},
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey.shade300),
                  settingItem(
                    subTitle: "English",
                    title: "Select Language",
                    icon: Icons.language_rounded,
                    onTap: _changeLanguage,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey.shade300),
                  settingItem(
                    subTitle: "Terms & Conditions",
                    icon: CupertinoIcons.infinite,
                    onTap: () async {
                      const url = "https://flutter.io";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw "Could not launch $url";
                      }
                    },
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey.shade300),
                  settingItem(
                    subTitle: "privacy".tr,
                    icon: CupertinoIcons.hand_point_left,
                    onTap: () async {
                      const url = "https://flutter.io";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw "Could not launch $url";
                      }
                    },
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey.shade300),
                  settingItem(
                    subTitle: "Help & Support",
                    icon: Icons.question_mark_rounded,
                    onTap: () {
                      _contractAdmin(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile settingItem(
      {required IconData icon,
      required String subTitle,
      String title = '',
      required Function() onTap,
      bool trailing = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 30, color: Colors.black),
      title: Text(
        title == "" ? subTitle : title,
        style: TextStyle(
            color: title == "" ? Colors.black : Colors.grey.shade400,
            fontSize: title == "" ? 16 : 12,
            fontWeight: title == "" ? FontWeight.bold : null),
      ),
      subtitle: title == ""
          ? null
          : Text(
              subTitle,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
    );
  }

  _changeLanguage() {
    final List locale = [
      {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
      {'name': 'বাংলা', 'locale': const Locale('BD', 'IN')},
    ];
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Select Language"),
        actions: [
          CupertinoDialogAction(
            child: const Text("Bangla"),
            onPressed: () {
              Get.updateLocale(locale[1]['locale']);
              Get.back();
            },
          ),
          CupertinoDialogAction(
            child: const Text("English"),
            onPressed: () {
              Get.updateLocale(locale[0]['locale']);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _contractAdmin(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        height: Get.height / 2,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: ListView(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.chevron_down_circle_fill,
                color: Colors.orangeAccent,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "Contract Of Admin List :",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text("No Admin Fount Try Again later"),
            )
          ],
        ),
      ),
    );
  }
}

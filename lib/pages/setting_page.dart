import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/redirect_page.dart';
import 'package:parking_koi/provider/adminProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';
import '../provider/mapProvider.dart';
import '../services/Auth_service.dart';
import 'chat_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "setting_title".tr,
          style: const TextStyle(color: Colors.white),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
      body: Consumer<MapProvider>(
        builder: (context, provider, child) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  settingItem(
                    subTitle: "notification".tr,
                    icon: CupertinoIcons.bell,
                    onTap: () {},
                    trailing: true,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey.shade300),
                  settingItem(
                    subTitle: "your_location".tr,
                    title: provider.userModel!.location!,
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
                    subTitle: "terms".tr,
                    icon: CupertinoIcons.infinite,
                    onTap: () async {
                      const url = "https://flutter.io";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else
                        throw "Could not launch $url";
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
                      } else
                        throw "Could not launch $url";
                    },
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey.shade300),
                  settingItem(
                    subTitle: "help".tr,
                    icon: Icons.question_mark_rounded,
                    onTap: () {
                      _contractAdmin(context);
                    },
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 1,
                      color: Colors.grey.shade300),
                  settingItem(
                      subTitle: "logout".tr,
                      icon: Icons.logout_rounded,
                      onTap: () {
                        AuthService.logout().then((value) {
                          Get.to(() => const RedirectPage());
                        });
                      }),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding settingItem(
      {required IconData icon,
      required String subTitle,
      String title = '',
      required Function() onTap,
      bool trailing = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onTap,
        trailing: trailing
            ? GetX<HomeController>(
                builder: (controller) => CupertinoSwitch(
                  onChanged: (value) {
                    controller.saveNotiValue();
                  },
                  value: controller.notificationStatusValue.value,
                ),
              )
            : null,
        leading: Icon(icon, size: 40, color: Colors.grey),
        title: Text(
          title == "" ? subTitle : title,
          style: TextStyle(
              color: title == "" ? Colors.grey : Colors.grey.shade400,
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
      builder: (context) => Consumer<AdminProvider>(
        builder: (context, adminProvider, child) => Container(
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
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Contract Of Admin List :",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              adminProvider.adminUserList.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: adminProvider.adminUserList
                          .map((userModel) => Container(
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  onTap: () {
                                    Get.to(ChatPage(senderUseModel: userModel),
                                        transition:
                                            Transition.leftToRightWithFade);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                      userModel.name ?? userModel.phoneNumber),
                                  subtitle:
                                      Text(userModel.email ?? userModel.uid),
                                  leading: userModel.profileUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl: userModel.profileUrl!,
                                            width: 50,
                                            height: 50,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        )
                                      : TextAvatar(
                                          text: userModel.name,
                                        ),
                                  trailing: const Icon(
                                    Icons.message,
                                    color: Colors.blue,
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  : Center(
                      child: Text("No Admin Fount Try Again later"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

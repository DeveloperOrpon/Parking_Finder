import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWithTitleWhiteBG(
        context: context,
        title: "Support",
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Support", style: blackBoldText),
                  const SizedBox(height: 5),
                  const Text(
                    "Connect Us",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(10),
                height: Get.width * .4,
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        label: const Text("Call Us"),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 2,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        label: const Text("Mail Us"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Get.height * .09),
                height: Get.width * .7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text("Write Us", style: blackBoldText),
                      subtitle: const Text("Let us know your query"),
                    ),
                    ListTile(
                      title: Text("Phone Number/Email", style: blackBoldText),
                      subtitle: const TextField(
                        decoration:
                            InputDecoration(hintText: "Add Contact Info"),
                      ),
                    ),
                    ListTile(
                      title:
                          Text("Add your issue/feedback", style: blackBoldText),
                      subtitle: const TextField(
                        decoration:
                            InputDecoration(hintText: "Enter Your issue"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CupertinoButton(
              color: AppColors.primaryColor,
              child: const Text("SUBMIT"),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../custom_widget/sort_multi_choice.dart';
import '../providers/user_provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: TextField(
                controller: userProvider.searchController,
                focusNode: userProvider.searchFocusNode,
                onSubmitted: (value) async {
                  userProvider.setSearchAllList(value);
                  log('value text ; $value');
                  userProvider.searchController.text = '';
                  userProvider.searchFocusNode.unfocus();
                },
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      _showBottomSheet(context, userProvider);
                    },
                    icon: const Icon(
                      Icons.filter_list_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: ListView(
                children: [
                  Text(
                    "Recent",
                    style: blackBoldText,
                  ),
                  ...userProvider.searchPreference
                      .map((e) => _recentUi(e, userProvider, context)),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  InkWell _recentUi(String e, UserProvider userProvider, BuildContext context) {
    return InkWell(
      onTap: () {
        showSnackBar("Attenuation", "Wait Under Development");
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            e,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          IconButton(
            onPressed: () {
              userProvider.deleteSearchList(e);
            },
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, UserProvider userProvider) {
    showModalBottomSheet(
      elevation: 10,
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: Get.height * .5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                "Filter",
                style: blackBoldText,
              ),
              Divider(
                color: Colors.grey.shade300,
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sort by",
                    style: blackBoldText,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "See All",
                    ),
                  ),
                ],
              ),
              const MultipleChipChoiceWidget(reportList: [
                "Distance",
                "Sorts Available",
                'Lower Price',
                'Highest Price'
              ]),
              Row(
                children: [
                  Text("Distance (Km)", style: blackBoldText),
                ],
              ),
              SfSlider(
                min: 0.0,
                max: 20.0,
                interval: 2,
                stepSize: 2,
                showLabels: true,
                showTicks: true,
                showDividers: true,
                enableTooltip: true,
                shouldAlwaysShowTooltip: true,
                value: userProvider.distanceSlider,
                onChanged: (dynamic newValue) {
                  userProvider.distanceSlider = newValue;
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Valet Parking", style: blackBoldText),
                  CupertinoSwitch(
                    value: userProvider.isShowHomeParkingPost,
                    onChanged: (value) {
                      userProvider.isShowHomeParkingPost = value;
                      setState(() {});
                    },
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(8),
                        backgroundColor: AppColors.primaryColor.withOpacity(.5),
                      ),
                      child: const Text("Reset"),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                      ),
                      child: const Text("Apply Filter"),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

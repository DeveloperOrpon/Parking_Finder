import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/controller/ParkingController.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../custom_widget/sort_multi_choice.dart';
import '../model/searchModel.dart';
import '../providers/user_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchModel> allSearchList = [];
  List<SearchModel> suggestion = [];
  List<SearchModel> selectSearchList = [];
  final parkingController = Get.put(ParkingController());
  final garageController = Get.put(GarageController());
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    List<SearchModel> parkingSearchList = List.generate(
        parkingController!.activeParkingList.length,
        (index) => SearchModel(
            title: parkingController!.activeParkingList[index].title,
            id: parkingController!.activeParkingList[index].parkId!,
            imageUrl:
                parkingController!.activeParkingList[index].parkImageList[0],
            type: "parkingModel"));
    List<SearchModel> garageSearchList = List.generate(
        garageController!.activeGarageList.length,
        (index) => SearchModel(
            title: garageController.activeGarageList[index].name,
            id: garageController.activeGarageList[index].gId,
            imageUrl: garageController.activeGarageList[index].coverImage[0],
            type: "garageModel"));

    allSearchList.addAll(parkingSearchList);
    allSearchList.addAll(garageSearchList);
    allSearchList.shuffle();
  }

  searchSearchingList() {
    selectSearchList = [];
    for (SearchModel searchModel in allSearchList) {
      if (searchModel.title.contains(searchController.text) ||
          searchModel.id.contains(searchController.text) ||
          searchModel.type.contains(searchController.text)) {
        selectSearchList.add(searchModel);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) => Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: TextField(
                  onChanged: (value) {
                    searchSearchingList();
                  },
                  controller: searchController,
                  focusNode: userProvider.searchFocusNode,
                  onSubmitted: (value) async {
                    userProvider.setSearchAllList(value);
                    log('value text ; $value');
                    searchController.text = '';
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
                    hintText: 'Search ${allSearchList.length}',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent",
                      style: blackBoldText,
                    ),
                    if (userProvider.searchPreference.length > 2)
                      ...userProvider.searchPreference
                          .sublist(0, 2)
                          .map((e) => _recentUi(e, userProvider, context)),
                    if (userProvider.searchPreference.length <= 2)
                      ...userProvider.searchPreference
                          .map((e) => _recentUi(e, userProvider, context)),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: selectSearchList.length,
                itemBuilder: (context, index) {
                  final searchModel = selectSearchList[index];
                  return Card(
                    color: Colors.grey.shade200,
                    margin: EdgeInsets.all(10),
                    elevation: 6,
                    child: ListTile(
                      leading: CachedNetworkImage(
                          imageUrl: searchModel.imageUrl ?? "",
                          imageBuilder: (context, imageProvider) {
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage: imageProvider,
                            );
                          }),
                      title: Text(searchModel.title),
                      subtitle: Text(searchModel.id),
                      trailing: Text(searchModel.type),
                    ),
                  );
                },
              ))
            ],
          ),
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
                        FocusScope.of(context).unfocus();
                        selectSearchList = [];
                        allSearchList.shuffle();
                        allSearchList.length > 3
                            ? selectSearchList = allSearchList.sublist(0, 3)
                            : selectSearchList = allSearchList;
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

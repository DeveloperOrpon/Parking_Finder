import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:parking_finder/api/authenticate_service.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/diaglog.dart';
import 'package:provider/provider.dart';

import '../../database/dbhelper.dart';
import '../../model/garage_model.dart';
import '../../model/parking_model.dart';
import '../../providers/map_provider.dart';
import '../../services/Auth_service.dart';
import '../../utilities/appConst.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/testStyle.dart';

class AddParkingInfoPage extends StatefulWidget {
  final GarageModel garageModel;
  final ParkingModel? parkingModel;

  const AddParkingInfoPage(
      {Key? key, required this.garageModel, this.parkingModel})
      : super(key: key);

  @override
  State<AddParkingInfoPage> createState() => _AddParkingInfoPageState();
}

class _AddParkingInfoPageState extends State<AddParkingInfoPage> {
  String? selectStartTime;
  String? selectEndTime;
  var formKey = GlobalKey<FormState>();
  var formKeyCategory = GlobalKey<FormState>();
  bool buttonDisable = false;
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var capacityController = TextEditingController();
  var costController = TextEditingController();
  var categoryController = TextEditingController();
  ////
  var categoryNameController = TextEditingController();
  var categoryRateController = TextEditingController();
  var focusNode = FocusNode();
  var focusNode2 = FocusNode();
  var focusNode3 = FocusNode();
  late MapProvider provider;
  late UserProvider userProvider;
  String? parkingCategoryName;
  List selectImages = [];
  List selectFacility = [];
  List selectVehicleType = [];
  List<String> parkingVehicleType = [
    'MotorCycle',
    'Private Car',
    "Buss",
    "BiCycle",
    'Mini Bus',
    'Small Vehicle'
  ];
  List<ParkingCategoryModel> categoryList = [];
  int day = 00;
  int week = 00;
  int month = 00;
  List<SpotInformation> listOfSpot = [];
  List<SpotInformation> selectListOfSpot = [];
  @override
  void initState() {
    listOfSpot = [];
    for (FloorModel fm in widget.garageModel.floorDetails ?? []) {
      for (SpotInformation sp in fm.spotInformation ?? []) {
        listOfSpot.add(sp);
      }
      setState(() {});
    }
    if (widget.parkingModel != null) {
      controllerInit();
    }
    super.initState();
  }

  controllerInit() {
    nameController.text = widget.parkingModel!.title;
    addressController.text = widget.parkingModel!.address;
    capacityController.text = widget.parkingModel!.capacity;
    costController.text = widget.parkingModel!.parkingCost;
    for (SpotInformation spot in widget.parkingModel!.spotDetails ?? []) {
      selectListOfSpot.add(
          listOfSpot.firstWhere((element) => element.spotId == spot.spotId));
    }
    selectFacility = widget.parkingModel!.facilityList;
    selectVehicleType = widget.parkingModel!.availableVics;
    categoryList = widget.parkingModel!.parkingCategorys;
  }

  void _addItems() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, state) {
        return Form(
          key: formKeyCategory,
          child: Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.all(20),
            height: 520,
            width: Get.width * .4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  "Add Category Information",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: categoryNameController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "Enter Category Name",
                      helperStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Garage Name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: categoryRateController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "Rate Of This Category",
                      helperStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Rate Of This Category";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Time Duration Of This Package Category :-",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 160,
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Month",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryColor.withOpacity(.4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              state(() {
                                                month++;
                                              });
                                            },
                                            icon: const RotationTransition(
                                              turns: AlwaysStoppedAnimation(
                                                  90 / 360),
                                              child: Icon(Icons.arrow_back_ios),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                if (month > 0) {
                                                  state(() {
                                                    month--;
                                                  });
                                                }
                                              },
                                              icon: const RotationTransition(
                                                turns: AlwaysStoppedAnimation(
                                                    -90 / 360),
                                                child:
                                                    Icon(Icons.arrow_back_ios),
                                              ))
                                        ],
                                      ),
                                      Expanded(
                                        child: Text(
                                          "$month",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(
                              width: 10,
                              child: Text(":"),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Week",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryColor.withOpacity(.4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              state(() {
                                                week++;
                                              });
                                            },
                                            icon: const RotationTransition(
                                              turns: AlwaysStoppedAnimation(
                                                  90 / 360),
                                              child: Icon(Icons.arrow_back_ios),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                if (week > 0) {
                                                  state(() {
                                                    week--;
                                                  });
                                                }
                                              },
                                              icon: const RotationTransition(
                                                turns: AlwaysStoppedAnimation(
                                                    -90 / 360),
                                                child:
                                                    Icon(Icons.arrow_back_ios),
                                              ))
                                        ],
                                      ),
                                      Expanded(
                                        child: Text(
                                          "$week",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(
                              width: 10,
                              child: Text(":"),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Day",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryColor.withOpacity(.4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              state(() {
                                                day++;
                                              });
                                            },
                                            icon: const RotationTransition(
                                              turns: AlwaysStoppedAnimation(
                                                  90 / 360),
                                              child: Icon(Icons.arrow_back_ios),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                if (day > 0) {
                                                  state(() {
                                                    day--;
                                                  });
                                                }
                                              },
                                              icon: const RotationTransition(
                                                turns: AlwaysStoppedAnimation(
                                                    -90 / 360),
                                                child:
                                                    Icon(Icons.arrow_back_ios),
                                              ))
                                        ],
                                      ),
                                      Expanded(
                                        child: Text(
                                          "$day",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKeyCategory.currentState!.validate()) {
                        ParkingCategoryModel parkingCategoryModel =
                            ParkingCategoryModel(
                                categoryId: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                categoryName:
                                    categoryNameController.text.trim(),
                                categoryRate:
                                    categoryRateController.text.trim(),
                                isActive: true,
                                categoryDuration: (Duration(days: day)
                                            .inSeconds +
                                        Duration(days: week * 7).inSeconds +
                                        Duration(days: month * 30).inSeconds)
                                    .toString());
                        log("message: ${parkingCategoryModel.toJson()}");
                        categoryList.add(parkingCategoryModel);
                        Get.back();
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor),
                    child: const Text(
                      "Add Category/Package",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<MapProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Parking Additional Information",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor,
              )),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 14, right: 14),
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: InputBorder.none,
                          hintText: "Parking Title With Place Name",
                          helperStyle: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Fill Name";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: InputBorder.none,
                          hintText: "Enter Local Address",
                          helperStyle: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Fill Address";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: capacityController,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                border: InputBorder.none,
                                hintText: "Parking Capacity",
                                helperStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill Capacity";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: costController,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                border: InputBorder.none,
                                hintText: "Cost $currencySymbol per hour",
                                helperStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill Cost";
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Open Time", style: continueBlackTextStyle),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              onPressed: () {
                                showDatePickerDialog(context, true);
                              },
                              label: Text(selectStartTime ?? "0.0"),
                              icon: const Icon(Icons.alarm),
                            ),
                          ],
                        ),
                        Text(widget.parkingModel != null
                            ? widget.parkingModel!.openTime
                            : "_____"),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Close Time", style: continueBlackTextStyle),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              onPressed: () {
                                showDatePickerDialog(context, false);
                              },
                              label: Text(selectEndTime ?? "0.0"),
                              icon: const Icon(Icons.alarm),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MultipleSearchSelection<dynamic>(
                    selectAllButton: const Center(),
                    pickedItemsScrollbarColor: AppColors.primaryColor,
                    searchFieldInputDecoration: InputDecoration(
                        prefixIcon: const Icon(FontAwesomeIcons.criticalRole),
                        hintText: 'Select Facility',
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1))),
                    items: widget.garageModel.facilities ?? [],
                    // List<Country>
                    fieldToCheck: (c) {
                      return c; // String
                    },
                    itemBuilder: (p, p1) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.usersRays),
                            const SizedBox(width: 10),
                            Text(
                              p.toUpperCase(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      );
                    },
                    pickedItemBuilder: (role) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(role),
                        ),
                      );
                    },
                    initialPickedItems: selectFacility,
                    onPickedChange: (items) {
                      selectFacility = (items);
                      FocusScope.of(context).unfocus();
                      focusNode.unfocus();
                    },
                    onTapShowedItem: () {
                      FocusScope.of(context).unfocus();
                      focusNode.unfocus();
                    },
                    onItemAdded: (item) {
                      FocusScope.of(context).unfocus();
                      focusNode.unfocus();
                    },
                    onItemRemoved: (item) {},
                    sortShowedItems: true,
                    sortPickedItems: true,
                    fuzzySearch: FuzzySearch.jaro,
                    textFieldFocus: focusNode,
                    itemsVisibility: ShowedItemsVisibility.onType,
                    title: Text(
                      'Select Parking Facility',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    showSelectAllButton: true,
                    maximumShowItemsHeight: 100,
                  ),
                  const SizedBox(height: 10),
                  MultipleSearchSelection<dynamic>(
                    selectAllButton: const Center(),
                    pickedItemsScrollbarColor: AppColors.primaryColor,
                    searchFieldInputDecoration: InputDecoration(
                        prefixIcon: const Icon(FontAwesomeIcons.criticalRole),
                        hintText: 'Select Vehicle Type',
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1))),
                    items: parkingVehicleType,
                    // List<Country>
                    fieldToCheck: (c) {
                      return c; // String
                    },
                    itemBuilder: (p, p1) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.usersRays),
                            const SizedBox(width: 10),
                            Text(
                              p.toUpperCase(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      );
                    },
                    pickedItemBuilder: (role) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(role),
                        ),
                      );
                    },
                    initialPickedItems: selectVehicleType,
                    onPickedChange: (items) {
                      selectVehicleType = (items);
                      FocusScope.of(context).unfocus();
                      focusNode2.unfocus();
                    },
                    onTapShowedItem: () {
                      FocusScope.of(context).unfocus();
                      focusNode2.unfocus();
                    },
                    onItemAdded: (item) {
                      FocusScope.of(context).unfocus();
                      focusNode2.unfocus();
                    },
                    onItemRemoved: (item) {},
                    sortShowedItems: true,
                    sortPickedItems: true,
                    fuzzySearch: FuzzySearch.jaro,
                    textFieldFocus: focusNode2,
                    itemsVisibility: ShowedItemsVisibility.onType,
                    title: Text(
                      'Select Vehicle Type',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    showSelectAllButton: true,
                    maximumShowItemsHeight: 100,
                  ),
                  SizedBox(height: 10),
                  MultipleSearchSelection<SpotInformation>(
                    selectAllButton: const Center(),
                    pickedItemsScrollbarColor: AppColors.primaryColor,
                    initialPickedItems: selectListOfSpot,
                    searchFieldInputDecoration: InputDecoration(
                        prefixIcon: const Icon(FontAwesomeIcons.criticalRole),
                        hintText: 'Select Spot Details',
                        helperText: "Spot Name Search With Sp. Example: SP-F1",
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1))),
                    items: listOfSpot,
                    // List<Country>
                    fieldToCheck: (c) {
                      return "${c.spotName!}(${c.floor})"; // String
                    },
                    itemBuilder: (p, p1) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.usersRays),
                            const SizedBox(width: 10),
                            Text(
                              "${p.spotName!}(F${p.floor})",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      );
                    },
                    pickedItemBuilder: (p) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("${p.spotName!}(F${p.floor})"),
                        ),
                      );
                    },
                    onPickedChange: (items) {
                      selectListOfSpot = (items);
                      FocusScope.of(context).unfocus();
                      focusNode3.unfocus();
                    },
                    onTapShowedItem: () {
                      FocusScope.of(context).unfocus();
                      focusNode3.unfocus();
                    },
                    onItemAdded: (item) {
                      FocusScope.of(context).unfocus();
                      focusNode3.unfocus();
                    },
                    onItemRemoved: (item) {},
                    sortShowedItems: true,
                    sortPickedItems: true,
                    fuzzySearch: FuzzySearch.jaro,
                    textFieldFocus: focusNode3,
                    itemsVisibility: ShowedItemsVisibility.onType,
                    title: Text(
                      'Select Spot Type',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    showSelectAllButton: true,
                    maximumShowItemsHeight: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 110,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _addItems,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Add Category",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          categoryList.isNotEmpty
                              ? Expanded(
                                  child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: categoryList
                                      .map(
                                        (e) => Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(e.categoryName!),
                                              ),
                                            ),
                                            Positioned(
                                              right: -10,
                                              top: -10,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      categoryList.remove(e);
                                                    });
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons.delete,
                                                    color: Colors.red,
                                                    size: 22,
                                                  )),
                                            )
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ))
                              : const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text("No Category Select"),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text("Select Image Source"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Camera"),
                                    onPressed: () async {
                                      final ImagePicker _picker = ImagePicker();
                                      final pickedImage =
                                          await _picker.pickImage(
                                              source: ImageSource.camera);
                                      if (pickedImage != null) {
                                        setState(() {
                                          selectImages.add(pickedImage.path);
                                        });
                                      }
                                      Get.back();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                      child: const Text("Gallery"),
                                      onPressed: () async {
                                        final ImagePicker _picker =
                                            ImagePicker();
                                        final pickedImage =
                                            await _picker.pickImage(
                                                source: ImageSource.gallery);
                                        if (pickedImage != null) {
                                          setState(() {
                                            selectImages.add(pickedImage.path);
                                          });
                                        }
                                        Get.back();
                                      }),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1,
                                )),
                            child: const Icon(Icons.add),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: selectImages.map((e) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.orange,
                                      width: 1,
                                    )),
                                    child: Image.file(
                                      File(e),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                  Positioned(
                                    right: -15,
                                    top: -10,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            selectImages.remove(e);
                                          });
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.delete_solid,
                                          color: Colors.red,
                                          size: 32,
                                        )),
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CupertinoButton.filled(
                      onPressed: buttonDisable
                          ? null
                          : () {
                              widget.parkingModel == null
                                  ? _savePost()
                                  : _update();
                            },
                      child: const Text(
                        "Add Post For Review",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _savePost() async {
    if (formKey.currentState!.validate()) {
      log("message :${selectImages.isNotEmpty} ");
      if (selectImages.isEmpty &&
          num.parse(widget.garageModel.totalSpace).toInt() -
                  num.parse(capacityController.text.toString()).toInt() >=
              0) {
        Get.snackbar("Information", "Fill All The Information",
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
        return;
      }
      if (num.parse(widget.garageModel.totalSpace).toInt() -
              num.parse(capacityController.text.toString()).toInt() <
          0) {
        Get.snackbar("Information", "Not Enough Space In This Garage",
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
        return;
      }
      if (selectEndTime == null || selectStartTime == null) {
        Get.snackbar("Information", "Fill Start Time Information",
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
        return;
      }
      startLoading("Wait Data Uploading.....");
      setState(() {
        buttonDisable = true;
      });

      // bool isAdmin = await getAdminStatus();
      String title = nameController.text;
      String address = addressController.text;
      String capacity = capacityController.text;
      String parkingCost = costController.text;
      var parkingDownloadUrlList = [];
      log("selectImages : ${selectImages}");
      try {
        for (String url in selectImages) {
          String downloadUrl = await AuthenticateService.uploadImage(url);
          parkingDownloadUrlList.add(downloadUrl);
        }
        log("parkingDownloadUrlList $parkingDownloadUrlList");

        final parkingModel = ParkingModel(
          spotDetails: selectListOfSpot,
          openTime: '$selectStartTime - $selectEndTime',
          uId: AuthService.currentUser!.uid,
          parkId: DateTime.now().microsecondsSinceEpoch.toString(),
          address:
              widget.garageModel.city + widget.garageModel.division + address,
          phone: userProvider.user!.phoneNumber ?? "",
          parkingCost: parkingCost,
          facilityList: selectFacility,
          parkImageList: parkingDownloadUrlList,
          capacity: capacity,
          capacityRemaining: capacity,
          lon: widget.garageModel.lon,
          lat: ((num.parse(widget.garageModel.lat).toDouble()) + .000001)
              .toString(),
          title: title,
          gId: widget.garageModel.gId,
          selectVehicleTypeList: selectVehicleType,
          parkingCategorys: categoryList,
          createTime: Timestamp.fromDate(DateTime.now()),
          availableVics: selectVehicleType,
        );
        log("parkingModel : ${parkingModel.toMap()}");
        _clearForm();
        await DbHelper.addParkingLocation(parkingModel, widget.garageModel);
        EasyLoading.dismiss();
        setState(() {
          buttonDisable = false;
        });
        Get.snackbar(
          "Information",
          "Your Place Added Successfully",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );
      } catch (error) {
        EasyLoading.dismiss();
        Get.snackbar("Information", "${error.toString()}",
            duration: Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
        setState(() {
          buttonDisable = false;
        });
        log(error.toString());
      }
    } else {
      Get.snackbar("Information", "Please Select All Field",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red);
    }
  }

  void _clearForm() {
    nameController.clear();
    costController.clear();
    capacityController.clear();
    addressController.clear();
    selectFacility = [];
    selectImages = [];
    setState(() {});
  }

  showDatePickerDialog(BuildContext context, bool isSelectStartTime) async {
    log("showTimePicker");
    TimeOfDay? pickedTime = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
        initialEntryMode: TimePickerEntryMode.dialOnly);
    if (pickedTime != null) {
      var df = DateFormat("h:mm a");
      var dt = df.parse(pickedTime.format(context));
      isSelectStartTime
          ? selectStartTime = DateFormat('hh:mm a').format(dt)
          : selectEndTime = DateFormat('hh:mm a').format(dt);
      log("SelectDate : ${DateFormat('HH:mm').format(dt)}");
      setState(() {});
    }
  }

  _update() async {
    if (formKey.currentState!.validate()) {
      log("message :${selectImages.isNotEmpty} ");
      if (num.parse(widget.garageModel.totalSpace).toInt() -
              num.parse(capacityController.text.toString()).toInt() <
          0) {
        Get.snackbar("Information", "Not Enough Space In This Garage",
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
        return;
      }
      startLoading("Wait Data Uploading.....");
      setState(() {
        buttonDisable = true;
      });

      //update
      String title = nameController.text;
      String address = addressController.text;
      String capacity = capacityController.text;
      String parkingCost = costController.text;
      var parkingDownloadUrlList = [];
      log("selectImages : ${selectImages}");
      try {
        for (String url in selectImages) {
          String downloadUrl = await AuthenticateService.uploadImage(url);
          parkingDownloadUrlList.add(downloadUrl);
        }
        parkingDownloadUrlList
            .addAll((widget.parkingModel!.parkImageList ?? []));
        log("parkingDownloadUrlList $parkingDownloadUrlList");

        final parkingModel = {
          'spotDetails': selectListOfSpot.map((e) => e.toJson()).toList() ?? [],
          "openTime": (selectEndTime == null || selectStartTime == null)
              ? widget.parkingModel!.openTime
              : '$selectStartTime - $selectEndTime',
          "address": address,
          "phone": userProvider.user!.phoneNumber ?? "",
          "parkingCost": parkingCost,
          "facilityList": selectFacility ?? [],
          "parkImage": parkingDownloadUrlList ?? [],
          "capacity": capacity,
          "title": title,
          "selectVehicleTypeList": selectVehicleType ?? [],
          "parkingCategoryName":
              categoryList.map((e) => e.toJson()).toList() ?? [],
        };
        log("parkingModel : ${parkingModel}");
        _clearForm();
        await DbHelper.updateParkingField(
            widget.parkingModel!.parkId!, parkingModel);
        EasyLoading.dismiss();
        setState(() {
          buttonDisable = false;
        });
        Get.snackbar(
          "Information",
          "Your Place Update Successfully",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );
      } catch (error) {
        EasyLoading.dismiss();
        Get.snackbar("Information", "${error.toString()}",
            duration: Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
        setState(() {
          buttonDisable = false;
        });
        log(error.toString());
      }
    } else {
      Get.snackbar("Information", "Please Select All Field",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red);
    }
  }
}

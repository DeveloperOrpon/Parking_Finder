import 'package:cached_network_image/cached_network_image.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../custom_widget/appbar_with_title.dart';
import '../custom_widget/review_tile.dart';
import '../model/map.dart';
import '../providers/parking_provider.dart';
import 'avalable_parking_space_page.dart';
import 'review_page.dart';

class ParkingInformationPage extends StatelessWidget {
  const ParkingInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ParkingProvider>(
      builder: (context, parkingProvider, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWithTitleWhiteBG(
          context: context,
          title: 'Perdo Garage',
        ),
        body: Entry(
          opacity: .2,
          delay: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 900),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Hero(
                    tag: '1',
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        color: Colors.white,
                        child: PageView(
                          physics: const BouncingScrollPhysics(),
                          controller: parkingProvider.parkingImageSlider,
                          children: List.generate(
                            parkingProvider.listImages.length,
                            (index) => Stack(
                              alignment: Alignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: parkingProvider.listImages[index],
                                  fit: BoxFit.fitHeight,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          SpinKitPianoWave(
                                    color: AppColors.primaryColor,
                                    size: 50.0,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Shimmer(
                                  gradient: LinearGradient(
                                      stops: const [
                                        0.4,
                                        0.5,
                                        0.6
                                      ],
                                      colors: [
                                        Colors.white.withOpacity(0),
                                        Colors.white.withOpacity(.5),
                                        Colors.white.withOpacity(0),
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight),
                                  child: Container(
                                    height: 200,
                                    width: Get.width,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // indicator
                  Positioned(
                    bottom: 16,
                    child: SmoothPageIndicator(
                      controller: parkingProvider.parkingImageSlider,
                      count: parkingProvider.listImages.length,
                      effect: ExpandingDotsEffect(
                        dotColor: AppColors.primarySoft,
                        activeDotColor: AppColors.primaryColor,
                        dotHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: const [
                              TextSpan(
                                text: "Perdo Garage",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 18,
                            ),
                            Text(
                              "235 Zemblack Crest Apt 102",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "400 meters away",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 20,
                                child: Text("P", style: whiteBoldText),
                              ),
                              const SizedBox(width: 6),
                              Text("16 Slots", style: blackBoldText),
                              const SizedBox(width: 6),
                              const Icon(FontAwesomeIcons.carRear),
                              const SizedBox(width: 8),
                              Text(
                                  "12"
                                  "",
                                  style: appThemeTextStyle),
                              Icon(FontAwesomeIcons.bangladeshiTakaSign,
                                  color: AppColors.primaryColor)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.bookmark_border_rounded,
                              size: 40,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                            ),
                            onPressed: () {
                              Get.to(const AvailableParkingSpacePage(),
                                  transition: Transition.topLevel);
                            },
                            child: const Text("BOOK SPOT"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.phone,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: 2,
                      height: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(const MapOfOpenApi(),
                            transition: Transition.topLevel);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.locationArrow,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: 2,
                      height: 20,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.facebookMessenger,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: 2,
                      height: 20,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.share,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Working Hours",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "05:00 AM - 11.00 PM",
                      style: blackBoldText,
                    ),
                    Text(
                      "Open Now",
                      style: TextStyle(color: AppColors.primaryColor),
                    )
                  ],
                ),
              ),
              const Divider(color: Colors.grey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Parking Available On", style: blackBoldText),
                  const Icon(
                    FontAwesomeIcons.carSide,
                    color: Colors.black,
                  ),
                  const Icon(
                    FontAwesomeIcons.motorcycle,
                    color: Colors.black,
                  ),
                  const Icon(
                    FontAwesomeIcons.truck,
                    color: AppColors.primarySoft,
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Service Available", style: blackBoldText),
                    Text("Extra Charges", style: grayTextStyle),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.all(8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      height: 30,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Washing", style: whiteText),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      height: 30,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Washing", style: whiteText),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      height: 30,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Washing", style: whiteText),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      height: 30,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Washing", style: whiteText),
                    ),
                  ],
                ),
              ),
              //review
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      initiallyExpanded: true,
                      childrenPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 0),
                      tilePadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      title: const Text(
                        'Reviews',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                        ),
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        parkingProvider.ratings.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => ReviewTile(
                                    review: parkingProvider.ratings[index]),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                                itemCount: parkingProvider.ratings.length > 2
                                    ? 2
                                    : parkingProvider.ratings.length,
                              )
                            : Text("No Review or Rating", style: grayLowColor),
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 6),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(
                                  ReviewPage(
                                    reviews: parkingProvider.ratings,
                                  ),
                                  transition: Transition.leftToRightWithFade);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.primarySoft,
                              elevation: 0,
                              backgroundColor: AppColors.primarySoft,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'See More Reviews',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
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
}

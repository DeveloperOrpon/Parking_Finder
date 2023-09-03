import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/appConst.dart';

import '../utilities/app_colors.dart';
import '../utilities/testStyle.dart';

AppBar appBarWithTitle({
  required BuildContext context,
  required String title,
  bool isLeading = true,
}) {
  return AppBar(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(
      title,
      style: blackBoldText,
    ),
    centerTitle: true,
    leading: isLeading
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
          )
        : null,
  );
}

AppBar appBarWithTitleWhiteBG({
  required BuildContext context,
  required String title,
  bool isLeading = true,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
      title,
      style: blackBoldText,
    ),
    centerTitle: true,
    leading: isLeading
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
          )
        : null,
  );
}

AppBar appBarWithTitleSubTitleWhiteBG({
  required BuildContext context,
  required String title,
  required String subTitle,
  bool isLeading = true,
  bool isOnlineImage = false,
  String imageUrl = '',
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: blackBoldText,
        ),
        Text(
          subTitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
    leading: isLeading
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
          )
        : null,
    actions: [
      !isOnlineImage
          ? const Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                  appLogo,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                      radius: 20, backgroundImage: imageProvider);
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SpinKitSpinningLines(
                  color: AppColors.primaryColor,
                  size: 50.0,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )
    ],
  );
}

AppBar appBarWithDrawerTitle(
    {required BuildContext context,
    required String title,
    required UserProvider userProvider}) {
  return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
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

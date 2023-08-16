import 'package:flutter/material.dart';

import '../utilities/app_colors.dart';

AppBar simpleAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
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
    ),
  );
}

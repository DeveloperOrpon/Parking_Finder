import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:parking_finder/model/user_model.dart';

import '../services/Auth_service.dart';
import '../utilities/app_colors.dart';
import 'message/Conversation.dart';

class UserProfilePreviewPage extends StatelessWidget {
  final UserModel userModel;

  const UserProfilePreviewPage({Key? key, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SelectionArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: AppColors.primaryColor, width: 3)),
                child: Hero(
                  tag: userModel.uid!,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CachedNetworkImage(
                        width: 130,
                        height: 150,
                        fit: BoxFit.cover,
                        imageUrl: "${userModel.profileUrl}",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                SpinKitSpinningLines(
                          color: AppColors.primaryColor,
                          size: 50.0,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Positioned(
                        right: -15,
                        bottom: -15,
                        child: const Icon(
                          Icons.verified_rounded,
                          color: Colors.indigo,
                          size: 50,
                        ).animate().rotate(duration: 1000.ms, end: 1, begin: 2),
                      )
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text("Personal Information"),
              trailing: Text("${userModel.name}"),
            ),
            ListTile(
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text("${userModel.email}"),
              ),
            ),
            ListTile(
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: Text("${userModel.gender}"),
              ),
            ),
            ListTile(
              title: const Text("Phone Number"),
              trailing: Text(userModel.phoneNumber),
            ),
            if (AuthService.currentUser!.uid != userModel.uid)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                onPressed: () {
                  Get.to(ConversationPage(userModel: userModel),
                      transition: Transition.fadeIn);
                },
                child: const Text("Message Request"),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .shake(
                    duration: 700.ms,
                    delay: 1000.ms,
                  )
                  .scaleXY(begin: 1, end: 1.2)
          ],
        ),
      ),
    );
  }
}

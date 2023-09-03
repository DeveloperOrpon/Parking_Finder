import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PreviewFullScreenImages extends StatelessWidget {
  final List images;
  const PreviewFullScreenImages({Key? key, required this.images})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController parkingImageSlider = PageController();
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
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryColor,
            )),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: images[0],
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: Get.height,
              color: Colors.white,
              child: PageView(
                controller: parkingImageSlider,
                physics: const BouncingScrollPhysics(),
                children: List.generate(
                  images.length,
                  (index) => CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.fitHeight,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SpinKitPianoWave(
                      color: AppColors.primaryColor,
                      size: 50.0,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) {
                      return PhotoView(
                        imageProvider: imageProvider,
                        backgroundDecoration:
                            const BoxDecoration(color: Colors.transparent),
                        enableRotation: true,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            child: SmoothPageIndicator(
              controller: parkingImageSlider,
              count: images.length,
              effect: ExpandingDotsEffect(
                dotColor: AppColors.primarySoft,
                activeDotColor: AppColors.primaryColor,
                dotHeight: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

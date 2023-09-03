import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/providers/map_provider.dart';
import 'package:parking_finder/utilities/app_colors.dart';
import 'package:provider/provider.dart';

import '../controller/GarageController.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
    return Consumer<MapProvider>(builder: (context, mapProvider, child) {
      if (mapProvider.currentLocation == null) mapProvider.getCurrentLocation();

      return mapProvider.currentLocation == null ||
              mapProvider.parkingBitmap == null
          ? SpinKitCubeGrid(
              color: AppColors.primaryColor,
              size: 50.0,
            )
          : Obx(() {
              return GoogleMap(
                onCameraMoveStarted: () {
                  mapProvider.isShowAds = false;
                },
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                  ..add(Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer())),
                scrollGesturesEnabled: true,
                indoorViewEnabled: true,
                compassEnabled: true,
                markers: garageController.getMarkers(mapProvider.parkingBitmap!,
                    context, garageController.allActiveParking.value),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(mapProvider.currentLocation!.latitude!,
                      mapProvider.currentLocation!.longitude!),
                  zoom: 14.5,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapProvider.mapController.complete(controller);
                },
              );
            });
    });
  }
}

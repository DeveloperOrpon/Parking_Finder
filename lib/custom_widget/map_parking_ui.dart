import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/providers/map_provider.dart';
import 'package:parking_finder/utilities/appConst.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';

import '../model/parking_model.dart';
import '../utilities/app_colors.dart';

class MapParkingUi extends StatelessWidget {
  final ParkingModel parkingModel;
  const MapParkingUi({Key? key, required this.parkingModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final garageController = Get.put(GarageController());
    MapProvider mapProvider = Provider.of<MapProvider>(context, listen: false);
    return InkWell(
      onTap: () async {
        garageController.showParkingInfoInBottomSheet(context, parkingModel);
        final GoogleMapController controller =
            await mapProvider.mapController.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(num.parse(parkingModel.lat).toDouble(),
                num.parse(parkingModel.lon).toDouble()),
            zoom: 22,
          ),
        ));
      },
      child: Card(
        margin: const EdgeInsets.only(left: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 1, color: AppColors.primaryColor),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 140,
          width: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    width: 136,
                    height: 70,
                    fit: BoxFit.cover,
                    imageUrl: "${parkingModel.parkImageList[0]}",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            SpinKitSpinningLines(
                      color: AppColors.primaryColor,
                      size: 50.0,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          overflow: TextOverflow.ellipsis,
                          parkingModel.title ?? ''),
                    ),
                    Text("🧡 0.0"),
                  ],
                ),
              ),
              Divider(
                color: AppColors.primaryColor,
                height: 2,
              ),
              Row(
                children: [
                  Icon(
                    Icons.navigation_outlined,
                  ),
                  Text("10 Min"),
                  Spacer(),
                  Text(
                    "${parkingModel.parkingCost} $currencySymbol",
                    style: primarySmallBoldText,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

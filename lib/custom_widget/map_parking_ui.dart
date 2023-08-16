import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/providers/map_provider.dart';
import 'package:provider/provider.dart';

class MapParkingUi extends StatelessWidget {
  const MapParkingUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapProvider mapProvider = Provider.of<MapProvider>(context, listen: false);
    return InkWell(
      onTap: () async {
        final GoogleMapController controller =
            await mapProvider.mapController.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: mapProvider.myPosition2,
            zoom: 17.5,
          ),
        ));
      },
      child: Card(
        margin: const EdgeInsets.only(left: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
                child: Image.asset(
                  "assets/image/onboarding_carparking.png",
                  width: 136,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: const [
                  Text("6th October"),
                  Text("🧡 5.6"),
                ],
              ),
              const Divider(
                color: Colors.grey,
                height: 2,
              ),
              Row(
                children: const [
                  Icon(
                    Icons.navigation_outlined,
                  ),
                  Text("10 Min"),
                  Text("15\$ Min/hr"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

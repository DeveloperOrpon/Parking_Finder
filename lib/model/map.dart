import 'dart:convert' as convert;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as Http;

import '../utilities/app_colors.dart';
import 'map_route_response.dart';

class MapOfOpenApi extends StatefulWidget {
  const MapOfOpenApi({Key? key}) : super(key: key);

  @override
  State<MapOfOpenApi> createState() => _MapOfOpenApiState();
}

class _MapOfOpenApiState extends State<MapOfOpenApi> {
  late MapRouteResponse mapRouteResponse;
  List<LatLng> latLen = [];
  final Set<Polyline> _polyline = {};
  final Set<Marker> _markers = {};
  List map = [];
  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List : ${latLen.length}"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.navigation))],
      ),
      body: latLen.isEmpty
          ? Center(
              child: SpinKitCubeGrid(
                color: AppColors.primaryColor,
                size: 50.0,
              ),
            )
          : GoogleMap(
              indoorViewEnabled: true,
              //trafficEnabled: true,

              compassEnabled: true,
              polylines: _polyline,

              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: const CameraPosition(
                target: LatLng(23.778067, 90.352110),
                zoom: 16.5,
              ),
              onMapCreated: (GoogleMapController controller) {},
            ),
    );
  }

  Future<void> _getData() async {
    log("message");

    var url = Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/driving/90.351857,23.781999;90.352110,23.778067?annotations=maxspeed&overview=full&geometries=geojson&access_token=pk.eyJ1Ijoib3Jwb24zNjAiLCJhIjoiY2xkdm9jM2l6MGhxMjNzbzV6cTFiNzZjayJ9.ESm7M64bQjwhFs1pDztsuw");
    log("Uri :$url");
    var response = await Http.get(url).catchError((onError) {
      log("Error :$onError");
    }).then((value) {
      var jsonResponse = convert.jsonDecode(value.body) as Map<String, dynamic>;
      map = jsonResponse['routes'][0]['geometry']['coordinates'] as List;

      for (int i = 0; i < map.length; i++) {
        var lat = map[i][0];
        var lng = map[i][1];
        LatLng mark = LatLng(num.parse(lng.toString()).toDouble(),
            num.parse(lat.toString()).toDouble());
        latLen.add(mark);
        _markers.add(
          // added markers
          Marker(
            markerId: MarkerId('$i'),
            position: mark,
            infoWindow: const InfoWindow(
              title: 'HOTEL',
              snippet: '5 Star Hotel',
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      }

      _polyline.add(Polyline(
        consumeTapEvents: true,
        geodesic: true,
        jointType: JointType.round,
        endCap: Cap.roundCap,
        polylineId: PolylineId('1'),
        points: latLen,
        color: Colors.red,
      ));

      setState(() {});
    });
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:marker_icon/marker_icon.dart';

class MapProvider extends ChangeNotifier {
  List<String> garageImagesSelection = [];
  List<String> garageFacility = [];
  final PageController addGarageController = PageController();
  List<geocoding.Placemark>? placemarks;
  int _selectFloor = 0;
  bool _isShowAds = true;
  LocationData? currentLocation;
  BitmapDescriptor? parkingBitmap;
  LatLng selectPosition = const LatLng(0, 0);
  final Completer<GoogleMapController> mapController = Completer();
  LatLng myPosition = const LatLng(23.779680, 90.354103);
  LatLng myPosition2 = const LatLng(23.780446, 90.353255);
  LatLng myPosition3 = const LatLng(23.780711, 90.351909);

  bool get isShowAds => _isShowAds;

  set isShowAds(bool value) {
    _isShowAds = value;
    notifyListeners();
  }

  int get selectFloor => _selectFloor;

  set selectFloor(int value) {
    _selectFloor = value;
    notifyListeners();
  }

  void getCurrentLocation() async {
    log("Call getCurrentLocation");
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
        notifyListeners();
      },
    );
    GoogleMapController googleMapController = await mapController.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
      },
    );
  }

  mapParkingIcon() async {
    log("Call mapParkingIcon");
    parkingBitmap = await MarkerIcon.pictureAsset(
      width: 120,
      height: 220,
      assetPath: 'assets/image/markLogo.png',
    );
    notifyListeners();
  }

  void gotoMyLocation() async {
    log("Call gotoMyLocation");
    final GoogleMapController controller = await mapController.future;
    LocationData cLocation;
    var location = Location();
    try {
      cLocation = await location.getLocation();
    } on Exception {
      rethrow;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(cLocation.latitude!, cLocation.longitude!),
        zoom: 17.5,
      ),
    ));
  }

  getLatLngToAddress(LatLng latLng) async {
    placemarks = await geocoding.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude);
    log("Address ${placemarks!.last.street}");
    notifyListeners();
  }

  pickImageSelectForGarage() {}

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      cropImage(pickedImage.path).then((value) {
        garageImagesSelection.add(value);
        notifyListeners();
      });
    }
  }

  Future<String> cropImage(String filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      cropStyle: CropStyle.rectangle,
      uiSettings: [],
    );
    if (croppedImage != null) {
      return croppedImage.path;
    }
    return filePath;
  }

  deleteSelectImage(String value) {
    garageImagesSelection.remove(value);
    notifyListeners();
  }

  addFacilityFunction(String s) {
    if (garageFacility.contains(s)) {
      garageFacility.remove(s);
    } else {
      garageFacility.add(s);
    }
    notifyListeners();
  }
}

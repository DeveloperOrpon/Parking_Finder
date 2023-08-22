import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../api/api_const.dart';
import '../api/authenticate_service.dart';
import '../model/user_model.dart';
import '../preference/user_preference.dart';
import '../utilities/diaglog.dart';

class MapProvider extends ChangeNotifier {
  List<String> garageImagesSelection = [];
  List<String> garageFacility = [];
  final PageController addGarageController = PageController();
  List<geocoding.Placemark>? placemarks;
  int _selectFloor = 0;
  bool _isShowAds = true;
  bool _tramsCond = false;

  bool get tramsCond => _tramsCond;

  set tramsCond(bool value) {
    _tramsCond = value;
    notifyListeners();
  }

  LocationData? currentLocation;
  BitmapDescriptor? parkingBitmap;
  LatLng selectPosition = const LatLng(0, 0);
  final Completer<GoogleMapController> mapController = Completer();
  LatLng myPosition = const LatLng(23.779680, 90.354103);
  LatLng myPosition2 = const LatLng(23.780446, 90.353255);
  LatLng myPosition3 = const LatLng(23.780711, 90.351909);

  /// controller
  final garageNameController = TextEditingController();
  final garageAddressController = TextEditingController();
  final garageAddInfoController = TextEditingController();
  final totalSlotController = TextEditingController();
  final numberOfFloorController = TextEditingController();
  List<String> imagesOfGarage = [];
  final formKey = GlobalKey<FormState>();

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
      cropImage(pickedImage.path).then((value) async {
        ///image Upload
        String imageUrl = await AuthenticateService.uploadImage(value);
        imagesOfGarage.add(imageUrl);
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

  Future<void> createAGarage(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (garageFacility.isEmpty ||
        totalSlotController.text.isEmpty ||
        numberOfFloorController.text.isEmpty ||
        garageNameController.text.isEmpty ||
        imagesOfGarage.isEmpty ||
        garageAddressController.text.isEmpty ||
        totalSlotController.text.isEmpty ||
        garageAddInfoController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Input All The Information",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    final garageModel = GarageModel(
      facilities: garageFacility,
      availableSpace: totalSlotController.text,
      totalFloor: numberOfFloorController.text,
      gId: DateTime.now().millisecondsSinceEpoch.toString(),
      name: garageNameController.text,
      coverImage: imagesOfGarage,
      ownerUId: userProvider.user!.id!,
      address: garageAddressController.text,
      division: "${placemarks!.last.street},${placemarks?.first.subLocality}",
      city: placemarks?.first.administrativeArea ?? '',
      parkingCategoryList: [],
      totalSpace: totalSlotController.text,
      createTime: DateTime.now().millisecondsSinceEpoch.toString(),
      additionalInformation: garageAddInfoController.text,
    );
    log("garageModel : ${garageModel.toJson()}");

    //start
    startLoading("Please Wait");
    List<Map<String, dynamic>> myGarageMap = [];
    myGarageMap.add(garageModel.toJson());
    if (userProvider.user!.vicList!.isNotEmpty) {
      for (GarageModel garage in userProvider.user!.garazList!) {
        myGarageMap.add(garage.toJson());
      }
    }

    Map<String, dynamic> updateMap = {"garaz_list": myGarageMap};

    log("map : $updateMap");

    try {
      Response response = await Dio().patch(
          '$baseUrl/user/update/profile/${userProvider.user!.email}',
          data: updateMap);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = response.data;
        setUserInfo(convert.jsonEncode(jsonResponse['updatedUser']));
        userProvider.getUserFromSharePref();
        EasyLoading.dismiss();
        clear();
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Garage Added Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioException catch (error) {
      log("ERROR ${error.toString()}");
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  clear() {
    garageFacility = [];
    totalSlotController.text = '';
    numberOfFloorController.text = '';
    garageNameController.text = '';
    imagesOfGarage = [];
    garageAddressController.text = '';
    totalSlotController.text = '';
    garageAddInfoController.text = '';
  }
}

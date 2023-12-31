import 'dart:developer';

import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:package_info_plus/package_info_plus.dart';
import 'package:parking_finder/model/user_model.dart';

import '../database/dbhelper.dart';
import '../model/garage_model.dart';
import '../preference/search_preference.dart';
import '../services/Auth_service.dart';
import '../utilities/helper_function.dart';

class UserProvider extends ChangeNotifier {
  int _selectNumberOfTime = 1;
  final searchFocusNode = FocusNode();
  double _distanceSlider = 1.0;
  List _searchPreference = [];
  final searchController = TextEditingController();
  bool _isValetParking = false;
  final profileEditFormKey = GlobalKey<FormState>();
  final drawerController = ZoomDrawerController();
  String? dob;
  bool _isShowHomeParkingPost = true;
  String? pickImagePath;
  String? userLicenceImgUrl;
  String? selectGender;
  List<String> genderList = <String>['Male', 'Female', 'Others'];

  int _selectBottomBar = 0;
  int _selectNavDrawer = 0;
  String _version = '';
  UserModel? user;
  String? jwtToken;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late PhoneNumberInputController phoneController;
  late TextEditingController addressController;
  late TextEditingController nidController;
  final fullNameFocusNode = FocusNode();
  final emailNameFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final nidFocusNode = FocusNode();

  final PageController pageController = PageController();

  int get selectBottomBar => _selectBottomBar;

  set selectBottomBar(int value) {
    _selectBottomBar = value;
    notifyListeners();
  }

  int get selectNumberOfTime => _selectNumberOfTime;

  set selectNumberOfTime(int value) {
    _selectNumberOfTime = value;
    notifyListeners();
  }

  bool get isValetParking => _isValetParking;

  set isValetParking(bool value) {
    _isValetParking = value;
    notifyListeners();
  }

  List get searchPreference => _searchPreference;

  set searchPreference(List value) {
    _searchPreference = value;
    notifyListeners();
  }

  bool get isShowHomeParkingPost => _isShowHomeParkingPost;

  set isShowHomeParkingPost(bool value) {
    _isShowHomeParkingPost = value;
    notifyListeners();
  }

  int get selectNavDrawer => _selectNavDrawer;

  set selectNavDrawer(int value) {
    _selectNavDrawer = value;
    notifyListeners();
  }

  double get distanceSlider => _distanceSlider;

  set distanceSlider(double value) {
    _distanceSlider = value;
    notifyListeners();
  }

  String get version => _version = '1.0.0';

  set version(String value) {
    _version = value;
    notifyListeners();
  }

  getVersion() async {
    //  PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = '1.0.1';
    log("Version $version");
  }

  intController(BuildContext context) {
    userLicenceImgUrl = null;
    pickImagePath = null;
    fullNameController = TextEditingController(text: user!.name);
    addressController = TextEditingController(text: user!.location ?? "");
    emailController = TextEditingController(text: user!.email);
    phoneController = PhoneNumberInputController(context);
    phoneController.phoneNumber = user!.phoneNumber;
    dob = "DOB NOT SET";
    selectGender = user!.gender!;
    nidController = TextEditingController(text: user!.nId ?? '000');
  }

  getDatePicker(BuildContext context) async {
    DateTime? pickDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now());
    dob = getFormattedDate(pickDate!);
    notifyListeners();
  }

  pickImage({
    required bool isSaveProfile,
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: imageSource);
    if (pickedImage != null) {
      cropImage(pickedImage.path, isSaveProfile);
    }
  }

  cropImage(filePath, bool isSaveProfile) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      cropStyle: isSaveProfile ? CropStyle.circle : CropStyle.rectangle,
      uiSettings: [],
    );
    if (croppedImage != null) {
      if (isSaveProfile) pickImagePath = croppedImage.path;
      if (!isSaveProfile) userLicenceImgUrl = croppedImage.path;
      log("pickImagePath $pickImagePath -userLicenceImgUrl  $userLicenceImgUrl");
      notifyListeners();
    }
  }

  //search preference
  getSearchAllList() async {
    List<String> list = await getSearchList();
    searchPreference = list;
    notifyListeners();
    return list;
  }

  deleteSearchList(String value) async {
    List<String> list = await getSearchList();
    log(list.toString());
    list.remove(value);
    log(list.toString());

    await setSearchList(list).then((value) {
      getSearchAllList();
    });
  }

  setSearchAllList(String value) async {
    List<String> listString = await getSearchList();
    listString.add(value);
    await setSearchList(listString).then((value) {
      getSearchAllList();
    });
  }

  // getUserFromSharePref() async {
  //   final userInfo = await getUserInfo();
  //   var jsonResponse = convert.jsonDecode(userInfo) as Map<String, dynamic>;
  //   UserModel newUserModel = UserModel.fromMap(jsonResponse);
  //   user = newUserModel;
  //   notifyListeners();
  // }

  disposeController() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nidController.dispose();
  }

  clearController() {
    fullNameController.text = '';
    emailController.text = '';
    phoneController.phoneNumber = '';
    nidController.text = '';
    userLicenceImgUrl = null;
    pickImagePath = null;
    addressController.text = '';
  }
  Future<void> getUserInfo() async {
    log("message");
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      user = UserModel.fromMap(snapshot.data()!);
      notifyListeners();
      return;
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'coupon_model.dart';
import 'garage_model.dart';

const String collectionParkingPoint = 'ParkingPoint';
const String parkingFieldParkId = 'parkId';
const String parkingFieldAddress = 'address';
const String parkingFieldParkingCost = 'parkingCost';
const String parkingFieldFacilityList = 'facility';
const String parkingFieldParkImages = 'parkImage';
const String parkingFieldCapacity = 'capacity';
const String parkingFieldCapacityRemaining = 'capacityRemaining';
const String parkingFieldRating = 'rating';
const String parkingFieldLat = 'lat';
const String parkingFieldLon = 'lon';
const String parkingFieldPhone = 'phone';
const String parkingFieldTitle = 'title';
const String parkingFieldIsActive = 'isActive';
const String parkingFieldParkingCategoryName = 'parkingCategoryName';
const String parkingFieldUserId = 'uId';
const String parkingFieldGarageIdId = 'gId';
const String parkingFieldOpenTime = 'openTime';
const String parkingFieldCreateTime = 'createTime';
const String parkingFieldAcceptTime = 'acceptTime';
const String parkingFieldAcceptAdminUId = 'acceptAdminUId';
const String parkingFieldSelectVehicleTypeList = 'selectVehicleTypeList';

class ParkingModel {
  String? parkId;
  String gId;
  String uId;
  String title;
  String address;
  List<ParkingCategoryModel> parkingCategorys;
  List<SpotInformation>? spotDetails;
  List<CouponCode>? coupons;
  String phone;
  String parkingCost;
  List facilityList;
  List availableVics;
  List selectVehicleTypeList;
  List parkImageList;
  String capacity;
  String capacityRemaining;
  String rating;
  String lat;
  String lon;
  String openTime;
  bool isActive;
  bool isOpen;
  String? acceptAdminUId;
  Timestamp? acceptTime;
  Timestamp? createTime;

  ParkingModel(
      {this.parkId,
      required this.address,
      required this.gId,
      required this.uId,
      required this.phone,
      required this.availableVics,
      this.openTime = "24H",
      required this.parkingCost,
      required this.facilityList,
      required this.selectVehicleTypeList,
      required this.parkImageList,
      required this.capacity,
      required this.capacityRemaining,
      this.createTime,
      this.rating = '0.0',
      this.isActive = false,
      this.spotDetails,
      this.coupons,
      this.isOpen = true,
      required this.parkingCategorys,
      required this.lon,
      required this.lat,
      this.acceptAdminUId,
      this.acceptTime,
      required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      parkingFieldParkId: parkId,
      'spotDetails': spotDetails == null
          ? []
          : spotDetails!.map((e) => e.toJson()).toList(),
      'coupons': coupons == null ? [] : coupons!.map((e) => e.toMap()).toList(),
      'isOpen': isOpen,
      parkingFieldAddress: address,
      parkingFieldParkingCost: parkingCost,
      parkingFieldFacilityList: facilityList,
      parkingFieldParkImages: parkImageList,
      parkingFieldCapacity: capacity,
      parkingFieldCapacityRemaining: capacityRemaining,
      parkingFieldRating: rating,
      parkingFieldLat: lat,
      'availableVics': availableVics ?? [],
      parkingFieldLon: lon,
      parkingFieldPhone: phone,
      parkingFieldTitle: title,
      parkingFieldIsActive: isActive,
      parkingFieldParkingCategoryName:
          parkingCategorys.map((e) => e.toJson()).toList(),
      parkingFieldUserId: uId,
      parkingFieldGarageIdId: gId,
      parkingFieldOpenTime: openTime,
      parkingFieldCreateTime: createTime,
      parkingFieldAcceptTime: acceptTime,
      parkingFieldAcceptAdminUId: acceptAdminUId,
      parkingFieldSelectVehicleTypeList: selectVehicleTypeList,
    };
  }

  factory ParkingModel.fromMap(Map<String, dynamic> map) => ParkingModel(
      parkId: map[parkingFieldParkId],
      address: map[parkingFieldAddress],
      parkingCost: map[parkingFieldParkingCost],
      facilityList: map[parkingFieldFacilityList],
      parkImageList: map[parkingFieldParkImages],
      capacity: map[parkingFieldCapacity],
      capacityRemaining: map[parkingFieldCapacityRemaining],
      rating: map[parkingFieldRating],
      lon: map[parkingFieldLon],
      lat: map[parkingFieldLat],
      phone: map[parkingFieldPhone],
      availableVics: map['availableVics'] ?? [],
      isOpen: map['isOpen'],
      spotDetails: map['spotDetails'] == null
          ? []
          : (map['spotDetails'] as List)
              .map((e) => SpotInformation.fromJson(e))
              .toList(),
      coupons: map['coupons'] == null
          ? []
          : (map['coupons'] as List).map((e) => CouponCode.fromMap(e)).toList(),
      parkingCategorys: map[parkingFieldParkingCategoryName] != null
          ? (map[parkingFieldParkingCategoryName] as List)
              .map((e) => ParkingCategoryModel.fromJson(e))
              .toList()
          : [],
      isActive: map[parkingFieldIsActive],
      uId: map[parkingFieldUserId],
      gId: map[parkingFieldGarageIdId],
      openTime: map[parkingFieldOpenTime],
      createTime: map[parkingFieldCreateTime],
      acceptAdminUId: map[parkingFieldAcceptAdminUId],
      acceptTime: map[parkingFieldAcceptTime],
      selectVehicleTypeList: map[parkingFieldSelectVehicleTypeList],
      title: map[parkingFieldTitle]);
}

///category
class ParkingCategoryModel {
  String? categoryId;
  String? categoryName;
  String? categoryRate;
  String? categoryDuration;
  bool? isActive;

  ParkingCategoryModel(
      {this.categoryId,
      this.categoryName,
      this.categoryRate,
      this.categoryDuration,
      this.isActive});

  ParkingCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryRate = json['category_rate'];
    categoryDuration = json['category_duration'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_rate'] = this.categoryRate;
    data['category_duration'] = this.categoryDuration;
    data['is_active'] = this.isActive;
    return data;
  }
}

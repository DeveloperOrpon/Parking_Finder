import 'package:cloud_firestore/cloud_firestore.dart';

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
  String parkId;
  String gId;
  String uId;
  String title;
  String address;
  String parkingCategoryName;
  String phone;
  String parkingCost;
  List facilityList;
  List selectVehicleTypeList;
  List parkImageList;
  String capacity;
  String capacityRemaining;
  String rating;
  String lat;
  String lon;
  String openTime;
  bool isActive;
  String? acceptAdminUId;
  Timestamp? acceptTime;
  Timestamp createTime;

  ParkingModel(
      {required this.parkId,
      required this.address,
      required this.gId,
      required this.uId,
      required this.phone,
      this.openTime = "24H",
      required this.parkingCost,
      required this.facilityList,
      required this.selectVehicleTypeList,
      required this.parkImageList,
      required this.capacity,
      required this.capacityRemaining,
      required this.createTime,
      this.rating = '0.0',
      this.isActive = false,
      required this.parkingCategoryName,
      required this.lon,
      required this.lat,
      this.acceptAdminUId,
      this.acceptTime,
      required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      parkingFieldParkId: parkId,
      parkingFieldAddress: address,
      parkingFieldParkingCost: parkingCost,
      parkingFieldFacilityList: facilityList,
      parkingFieldParkImages: parkImageList,
      parkingFieldCapacity: capacity,
      parkingFieldCapacityRemaining: capacityRemaining,
      parkingFieldRating: rating,
      parkingFieldLat: lat,
      parkingFieldLon: lon,
      parkingFieldPhone: phone,
      parkingFieldTitle: title,
      parkingFieldIsActive: isActive,
      parkingFieldParkingCategoryName: parkingCategoryName,
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
      parkingCategoryName: map[parkingFieldParkingCategoryName],
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

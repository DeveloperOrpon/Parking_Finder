import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionGarage = 'Garages';
const String garageFieldGName = 'name';
const String garageFieldGId = 'gId';
const String garageFieldOwnerId = 'ownerUId';
const String garageFieldAddress = 'address';
const String garageFieldDivision = 'division';
const String garageFieldCity = 'city';
const String garageFieldAdsIds = 'parkingAdsPIds';
const String garageFieldRating = 'rating';
const String garageFieldTotalSpace = 'totalSpace';
const String garageFieldInfo = 'additionalInformation';
const String garageFieldIsActive = 'isActive';
const String garageFieldCoverImage = 'coverImage';
const String garageFieldAcceptAdminUId = 'acceptAdminUId';
const String garageFieldCreateTime = 'createTime';
const String garageFieldCategoryOfParking = 'parkingCategoryList';

class GarageModel {
  String gId;
  String acceptAdminUId;
  String name;
  List coverImage;
  String ownerUId;
  String address;
  String division;
  String availableSpace;
  String totalFloor;
  String city;
  List parkingCategoryList;
  List? parkingAdsPIds;
  List? facilities;
  String rating;
  String totalSpace;
  String additionalInformation;
  bool isActive;
  Timestamp createTime;
  String lat;
  String lon;
  List<FloorModel>? floorDetails;

  GarageModel(
      {required this.gId,
      required this.name,
      required this.lon,
      required this.lat,
      required this.totalFloor,
      required this.facilities,
      required this.coverImage,
      required this.availableSpace,
      required this.ownerUId,
      required this.address,
      required this.division,
      required this.city,
      this.parkingAdsPIds,
      this.floorDetails,
      this.rating = '0.0',
      required this.parkingCategoryList,
      this.acceptAdminUId = '',
      required this.totalSpace,
      required this.createTime,
      this.isActive = false,
      required this.additionalInformation});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      garageFieldGId: gId,
      'facilities': facilities,
      'lon': lon,
      'lat': lat,
      'floorDetails': floorDetails == null
          ? []
          : floorDetails!.map((e) => e.toJson()).toList(),
      garageFieldGName: name,
      'availableSpace': availableSpace,
      'totalFloor': totalFloor,
      garageFieldOwnerId: ownerUId,
      garageFieldAddress: address,
      garageFieldDivision: division,
      garageFieldCity: city,
      garageFieldAdsIds: parkingAdsPIds,
      garageFieldRating: rating,
      garageFieldTotalSpace: totalSpace,
      garageFieldInfo: additionalInformation,
      garageFieldIsActive: isActive,
      garageFieldCoverImage: coverImage,
      garageFieldAcceptAdminUId: acceptAdminUId,
      garageFieldCreateTime: createTime,
      garageFieldCategoryOfParking: parkingCategoryList,
    };
  }

  factory GarageModel.fromMap(Map<String, dynamic> map) => GarageModel(
        gId: map[garageFieldGId],
        name: map[garageFieldGName],
        ownerUId: map[garageFieldOwnerId],
        facilities: map['facilities'],
        lon: map['lon'],
        floorDetails: map['floorDetails'] != null
            ? (map['floorDetails'] as List)
                .map((e) => FloorModel.fromJson(e))
                .toList()
            : [],
        lat: map['lat'],
        availableSpace: map['availableSpace'],
        totalFloor: map['totalFloor'],
        address: map[garageFieldAddress],
        division: map[garageFieldDivision],
        city: map[garageFieldCity],
        parkingAdsPIds: map[garageFieldAdsIds] ?? [],
        rating: map[garageFieldRating],
        totalSpace: map[garageFieldTotalSpace],
        additionalInformation: map[garageFieldInfo],
        isActive: map[garageFieldIsActive],
        coverImage: map[garageFieldCoverImage],
        createTime: map[garageFieldCreateTime],
        acceptAdminUId: map[garageFieldAcceptAdminUId],
        parkingCategoryList: map[garageFieldCategoryOfParking],
      );

  bool operator ==(dynamic other) =>
      other != null && other is GarageModel && gId == other.gId;

  @override
  int get hashCode => super.hashCode;
}

class FloorModel {
  String? floorNumber;
  List<SpotInformation>? spotInformation;

  FloorModel({this.floorNumber, this.spotInformation});

  FloorModel.fromJson(Map<String, dynamic> json) {
    floorNumber = json['floor_number'];
    if (json['spot_Information'] != null) {
      spotInformation = <SpotInformation>[];
      json['spot_Information'].forEach((v) {
        spotInformation!.add(new SpotInformation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['floor_number'] = this.floorNumber;
    if (this.spotInformation != null) {
      data['spot_Information'] =
          this.spotInformation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpotInformation {
  String? spotId;
  String? floor;
  String? spotName;
  bool? isBooked;
  String? bookedTime;
  String? expereTime;
  String? carId;
  String? bookedUserId;

  SpotInformation(
      {this.spotId,
      this.floor,
      this.spotName,
      this.isBooked = false,
      this.bookedTime,
      this.expereTime,
      this.carId,
      this.bookedUserId});

  SpotInformation.fromJson(Map<String, dynamic> json) {
    spotId = json['spot_id'];
    floor = json['floor'];
    spotName = json['spot_name'];
    isBooked = json['is_booked'];
    bookedTime = json['booked_time'];
    expereTime = json['expereTime'];
    carId = json['car_id'];
    bookedUserId = json['booked_userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spot_id'] = this.spotId;
    data['floor'] = this.floor;
    data['spot_name'] = this.spotName;
    data['is_booked'] = this.isBooked;
    data['booked_time'] = this.bookedTime;
    data['expereTime'] = this.expereTime;
    data['car_id'] = this.carId;
    data['booked_userId'] = this.bookedUserId;
    return data;
  }
}

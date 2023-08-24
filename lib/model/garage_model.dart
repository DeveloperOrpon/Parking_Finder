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
  String coverImage;
  String ownerUId;
  String address;
  String division;
  String city;
  List parkingCategoryList;
  List? parkingAdsPIds;
  String rating;
  String totalSpace;
  String additionalInformation;
  bool isActive;
  Timestamp createTime;

  GarageModel(
      {required this.gId,
      required this.name,
      required this.coverImage,
      required this.ownerUId,
      required this.address,
      required this.division,
      required this.city,
      this.parkingAdsPIds,
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
      garageFieldGName: name,
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

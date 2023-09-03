import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionUser = 'Users';
const String userFieldUId = 'userId';
const String userFieldName = 'userName';
const String userFieldPhone = 'phoneNumber';
const String userFieldUProfileUrl = 'profileUrl';
const String userFieldBalance = 'balance';
const String userFieldEmail = 'email';
const String userFieldTotalParks = 'parks';
const String userFieldTotalReport = 'reports';
const String userFieldTotalViews = 'views';
const String userFieldLocation = 'location';
const String userFieldLat = 'lat';
const String userFieldLon = 'lon';
const String userFieldNId = 'nId';
const String userFieldCreateTime = 'createTime';
const String userFieldIsGarageOwner = 'isGarageOwner';
const String userFieldIsGarageNidUrl = 'nIdGarageOwnerUrl';
const String userFieldAccountIsActive = 'accountActive';

class UserModel {
  String? uid;
  String? fcm;
  String? name;
  String? gender;
  String phoneNumber;
  String? profileUrl;
  String? nIdGarageOwnerUrl;
  String balance;
  String? email;
  num totalParks;
  num totalReports;
  num totalViews;
  String? location;
  String? lat;
  String? lon;
  String? nId;
  String? licence;
  String? role;
  Timestamp? createTime;
  bool isGarageOwner;
  bool accountActive;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  bool? isUserVerified;

  UserModel({
    this.uid,
    this.fcm,
    this.role = 'General User',
    this.name,
    this.gender = "Male",
    this.createdAt,
    this.updatedAt,
    this.isUserVerified = false,
    this.licence,
    required this.phoneNumber,
    this.createTime,
    this.isGarageOwner = false,
    this.accountActive = true,
    this.profileUrl,
    this.balance = '0.0',
    this.email,
    this.totalParks = 0,
    this.totalReports = 0,
    this.totalViews = 0,
    this.location,
    this.lat,
    this.lon,
    this.nId,
    this.nIdGarageOwnerUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      userFieldUId: uid,
      userFieldName: name,
      'gender': gender,
      'fcm': fcm,
      'createdAt': createdAt,
      'isUserVerified': isUserVerified,
      'updatedAt': updatedAt,
      userFieldPhone: phoneNumber,
      userFieldUProfileUrl: profileUrl,
      userFieldBalance: balance,
      userFieldEmail: email,
      userFieldTotalParks: totalParks,
      userFieldTotalReport: totalReports,
      userFieldTotalViews: totalViews,
      userFieldLocation: location,
      userFieldLat: lat,
      'licence': licence,
      'role': role,
      userFieldLon: lon,
      userFieldCreateTime: createTime,
      userFieldIsGarageOwner: isGarageOwner,
      userFieldNId: nId,
      userFieldIsGarageNidUrl: nIdGarageOwnerUrl,
      userFieldAccountIsActive: accountActive,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        licence: map['licence'],
        role: map['role'],
        gender: map['gender'],
        fcm: map['fcm'],
        isUserVerified: map['isUserVerified'],
        updatedAt: map['updatedAt'],
        createdAt: map['createdAt'],
        uid: map[userFieldUId],
        name: map[userFieldName] ?? "No Name Set Yet",
        phoneNumber: map[userFieldPhone],
        profileUrl: map[userFieldUProfileUrl],
        balance: map[userFieldBalance],
        email: map[userFieldEmail],
        totalParks: map[userFieldTotalParks],
        totalViews: map[userFieldTotalViews],
        totalReports: map[userFieldTotalReport],
        location: map[userFieldLocation] ?? "No Location Set Yet",
        lat: map[userFieldLat],
        lon: map[userFieldLon],
        nId: map[userFieldNId],
        createTime: map[userFieldCreateTime],
        isGarageOwner: map[userFieldIsGarageOwner],
        nIdGarageOwnerUrl: map[userFieldIsGarageNidUrl],
        accountActive: map[userFieldAccountIsActive],
      );
}

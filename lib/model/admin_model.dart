import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionAdmin = 'admins';
const String adminFieldUId = 'uId';
const String adminFieldName = 'name';
const String adminFieldBalance = 'balance';
const String adminFieldEmail = 'email';
const String adminFieldImageUrl = 'image_url';
const String adminFieldPassword = 'password';
const String adminFieldRole = 'role';
const String adminFieldCreateTime = 'createTime';
const String adminFieldIsGarage = 'isGarage';

class AdminModel {
  String uId;
  String name;
  String balance;
  String email;
  String imageUrl;
  String password;
  int role;
  bool isGarage;
  Timestamp createTime;

  AdminModel(
      {required this.uId,
      required this.name,
      required this.balance,
      required this.email,
      required this.imageUrl,
      required this.password,
      this.isGarage = false,
      required this.role,
      required this.createTime});

  factory AdminModel.fromMap(Map<String, dynamic> map) => AdminModel(
        uId: map[adminFieldUId],
        name: map[adminFieldName],
        email: map[adminFieldEmail],
        password: map[adminFieldPassword],
        imageUrl: map[adminFieldImageUrl],
        role: map[adminFieldRole],
        balance: map[adminFieldBalance],
        createTime: map[adminFieldCreateTime],
        isGarage: map[adminFieldIsGarage],
      );
}

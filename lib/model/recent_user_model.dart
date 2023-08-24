import 'package:cloud_firestore/cloud_firestore.dart';

class RecentUser {
  String name, email, id;
  Timestamp createTime;

  RecentUser(
      {required this.name,
      required this.id,
      required this.email,
      required this.createTime});
}

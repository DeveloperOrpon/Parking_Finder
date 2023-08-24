import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionNotification = 'Notification';
const String notificationFieldId = 'id';
const String notificationFieldTitle = 'title';
const String notificationFieldOtherId = 'otherId';
const String notificationFieldIsShowUser = 'isShowUser';
const String notificationFieldType = 'type';
const String notificationFieldTime = 'notificationTime';

class NotificationModelOfUser {
  String title;
  String id;
  String otherId;
  String type;
  bool isShowUser;
  Timestamp notificationTime;

  NotificationModelOfUser({
    required this.title,
    required this.id,
    required this.otherId,
    required this.type,
    this.isShowUser = false,
    required this.notificationTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      notificationFieldId: id,
      notificationFieldTitle: title,
      notificationFieldOtherId: otherId,
      notificationFieldType: type,
      notificationFieldTime: notificationTime,
      notificationFieldIsShowUser: isShowUser,
    };
  }

  factory NotificationModelOfUser.fromMap(Map<String, dynamic> map) =>
      NotificationModelOfUser(
        title: map[notificationFieldTitle],
        id: map[notificationFieldId],
        otherId: map[notificationFieldOtherId],
        type: map[notificationFieldType],
        notificationTime: map[notificationFieldTime],
        isShowUser: map[notificationFieldIsShowUser],
      );
}

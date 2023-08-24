import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionMessages = 'Messages';
const String messageFieldMId = 'mId';
const String messageFieldSenderId = 'senderId';
const String messageFieldRevivedId = 'revivedId';
const String messageFieldMessage = 'message';
const String messageFieldSentTime = 'sentTime';
const String messageFieldRevivedTime = 'revivedTime';

class MessageModel {
  String mId;
  String senderId;
  String revivedId;
  String message;
  Timestamp sentTime;
  Timestamp? revivedTime;

  MessageModel(
      {required this.mId,
      required this.senderId,
      required this.revivedId,
      required this.message,
      required this.sentTime,
      this.revivedTime});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      messageFieldMId: mId,
      messageFieldSenderId: senderId,
      messageFieldRevivedId: revivedId,
      messageFieldMessage: message,
      messageFieldSentTime: sentTime,
      messageFieldRevivedTime: revivedTime,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        mId: map[messageFieldMId],
        senderId: map[messageFieldSenderId],
        revivedId: map[messageFieldRevivedId],
        message: map[messageFieldMessage],
        sentTime: map[messageFieldSentTime],
        revivedTime: map[messageFieldRevivedTime],
      );
}

import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionWithDrawRequests = 'withDrawRequests';
const String withDrawFieldTId = 'tId';
const String withDrawFieldGarageOwnerId = 'garageOwnerId';
const String withDrawFieldWithDrawBalance = 'withDrawBalance';
const String withDrawFieldPaymentMethod = 'paymentMethod';
const String withDrawFieldPaymentNumber = 'paymentNumber';
const String withDrawFieldWithdrawStatus = 'withdrawStatus';
const String withDrawFieldAcceptAdminId = 'acceptAdminId';
const String withDrawFieldWithdrawRequestTime = 'withdrawRequestTime';
const String withDrawFieldAcceptTime = 'acceptTime';
const String withDrawFieldComment = 'comment';
const String withDrawFieldRejectStatus = 'rejectStatus';

class WithDrawMoneyModel {
  String tId;
  String garageOwnerId;
  String withDrawBalance;
  String paymentMethod;
  String paymentNumber;
  bool withdrawStatus;
  bool rejectStatus;
  String? acceptAdminId;
  Timestamp withdrawRequestTime;
  Timestamp? acceptTime;
  String? comment;

  WithDrawMoneyModel({
    required this.tId,
    required this.garageOwnerId,
    required this.withDrawBalance,
    required this.paymentMethod,
    required this.paymentNumber,
    this.withdrawStatus = false,
    this.rejectStatus = false,
    this.acceptAdminId,
    required this.withdrawRequestTime,
    this.acceptTime,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      withDrawFieldTId: tId,
      withDrawFieldGarageOwnerId: garageOwnerId,
      withDrawFieldWithDrawBalance: withDrawBalance,
      withDrawFieldPaymentMethod: paymentMethod,
      withDrawFieldPaymentNumber: paymentNumber,
      withDrawFieldWithdrawStatus: withdrawStatus,
      withDrawFieldAcceptAdminId: acceptAdminId,
      withDrawFieldWithdrawRequestTime: withdrawRequestTime,
      withDrawFieldAcceptTime: acceptTime,
      withDrawFieldComment: comment,
      withDrawFieldRejectStatus: rejectStatus,
    };
  }

  factory WithDrawMoneyModel.fromMap(Map<String, dynamic> map) =>
      WithDrawMoneyModel(
          tId: map[withDrawFieldTId],
          garageOwnerId: map[withDrawFieldGarageOwnerId],
          withDrawBalance: map[withDrawFieldWithDrawBalance],
          paymentMethod: map[withDrawFieldPaymentMethod],
          paymentNumber: map[withDrawFieldPaymentNumber],
          withdrawStatus: map[withDrawFieldWithdrawStatus],
          withdrawRequestTime: map[withDrawFieldWithdrawRequestTime],
          acceptAdminId: map[withDrawFieldAcceptAdminId],
          comment: map[withDrawFieldComment],
          rejectStatus: map[withDrawFieldRejectStatus],
          acceptTime: map[withDrawFieldAcceptTime]);
}

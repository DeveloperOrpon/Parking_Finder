import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionTransaction = 'Transactions';
const String transactionFieldTId = 'tId';
const String transactionFieldBId = 'bId';
const String transactionFieldPId = 'pId';
const String transactionFieldTType = 'tType';
const String transactionFieldAmount = 'amount';
const String transactionFieldVat = 'vat';
const String transactionFieldUserId = 'userId';
const String transactionFieldGOwnerId = 'gOwnerId';
const String transactionFieldTGenerateTime = 'tGenerateTime';

class MoneyTransactionModel {
  String tId;
  String bId;
  String pId;
  String tType;
  String amount;
  String vat;
  String userId;
  String gOwnerId;
  Timestamp tGenerateTime;

  MoneyTransactionModel({
    required this.tId,
    required this.bId,
    required this.pId,
    required this.tType,
    required this.amount,
    required this.vat,
    required this.userId,
    required this.gOwnerId,
    required this.tGenerateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      transactionFieldTId: tId,
      transactionFieldBId: bId,
      transactionFieldPId: pId,
      transactionFieldTType: tType,
      transactionFieldAmount: amount,
      transactionFieldVat: vat,
      transactionFieldUserId: userId,
      transactionFieldGOwnerId: gOwnerId,
      transactionFieldTGenerateTime: tGenerateTime,
    };
  }

  factory MoneyTransactionModel.fromMap(Map<String, dynamic> map) =>
      MoneyTransactionModel(
        tId: map[transactionFieldTId],
        bId: map[transactionFieldBId],
        pId: map[transactionFieldPId],
        tType: map[transactionFieldTType],
        amount: map[transactionFieldAmount],
        vat: map[transactionFieldVat],
        userId: map[transactionFieldUserId],
        gOwnerId: map[transactionFieldGOwnerId],
        tGenerateTime: map[transactionFieldTGenerateTime],
      );
}

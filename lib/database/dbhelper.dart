import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parking_koi/model/notification_model.dart';
import 'package:parking_koi/services/Auth_service.dart';

import '../model/admin_model.dart';
import '../model/booking_model.dart';
import '../model/garage_model.dart';
import '../model/message_model.dart';
import '../model/money_transsion_model.dart';
import '../model/parking_model.dart';
import '../model/parking_rating_model.dart';
import '../model/user_model.dart';
import '../model/withdraw_money_model.dart';
import '../pages/admin/models/vat_model.dart';

class DbHelper {
  static final _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addUser(UserModel userModel) {
    return _db
        .collection(collectionUser)
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
          String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfoMap(
          String uid) =>
      _db.collection(collectionUser).doc(uid).get();

  static Future<void> updateUserProfileField(
      String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllParkingPoint() =>
      _db.collection(collectionParkingPoint).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getParkingById(
          String pId) =>
      _db.collection(collectionParkingPoint).doc(pId).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getParkingInfoById(
          String pId) =>
      _db.collection(collectionParkingPoint).doc(pId).get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() =>
      _db.collection(collectionUser).snapshots();

  static Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child("PostImages/${DateTime.now().microsecondsSinceEpoch}");
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() {
      //show msg
    });
    return snapshot.ref.getDownloadURL();
  }

//parking db
  static Future<void> addParkingLocation(
      ParkingModel parkingModel, GarageModel garageModel) {
    final wb = _db.batch();
    final parkDoc =
        _db.collection(collectionParkingPoint).doc(parkingModel.parkId);
    wb.set(parkDoc, parkingModel.toMap());

    final garageDoc = _db.collection(collectionGarage).doc(parkingModel.gId);
    garageModel.parkingAdsPIds?.add(parkingModel.parkId);
    garageModel.totalSpace =
        (num.parse(garageModel.totalSpace) - num.parse(parkingModel.capacity))
            .toString();
    wb.update(garageDoc, {
      garageFieldAdsIds: FieldValue.arrayUnion(garageModel.parkingAdsPIds!),
      garageFieldTotalSpace: garageModel.totalSpace,
    });

    return wb.commit();
  }

  static Future<void> updateParkingField(
      String parkId, Map<String, dynamic> map) {
    return _db.collection(collectionParkingPoint).doc(parkId).update(map);
  }

  static Future<void> deleteParking(String parkId) {
    return _db.collection(collectionParkingPoint).doc(parkId).delete();
  }

  //booking place

  static Future<void> bookingRequestForParking(BookingModel bookingModel,
      ParkingModel parkingModel, UserModel userModel) async {
    final wb = _db.batch();
    final bookDoc = _db.collection(collectionBooking).doc(bookingModel.bId);
    wb.set(bookDoc, bookingModel.toMap());
    //update parking ads
    final parkDoc =
        _db.collection(collectionParkingPoint).doc(bookingModel.parkingPId);

    wb.update(parkDoc, {
      parkingFieldCapacityRemaining:
          (num.parse(parkingModel.capacityRemaining).toInt() - 1).toString(),
    });
    //user balance
    final userDoc = _db.collection(collectionUser).doc(bookingModel.userUId);

    if (bookingModel.onlinePayment) {
      wb.update(userDoc, {
        userFieldBalance: (num.parse(userModel.balance.toString()).toInt() -
                num.parse(bookingModel.cost).toInt())
            .toString(),
      });
    }
    return wb.commit();
  }

  static Future<void> updateBookingField(String bId, Map<String, dynamic> map) {
    return _db.collection(collectionBooking).doc(bId).update(map);
  }

  static Future<void> bookingRequestAccept(
      Map<String, dynamic> map,
      BookingModel bookingModel,
      UserModel garageOwner,
      Map<String, dynamic> mapUser,
      MoneyTransactionModel transactionModel,
      NotificationModelOfUser notificationModel) {
    final wb = _db.batch();

    ///update booking info
    final bookDoc = _db.collection(collectionBooking).doc(bookingModel.bId);
    wb.update(bookDoc, map);

    //add money in parking owner account
    final userOwnerDoc = _db.collection(collectionUser).doc(garageOwner.uid);
    wb.update(userOwnerDoc, mapUser);
    //set data in Transactions model
    final tranDoc =
        _db.collection(collectionTransaction).doc(transactionModel.tId);
    wb.set(tranDoc, transactionModel.toMap());

    //setNotification
    final notificationDoc = _db
        .collection(collectionUser)
        .doc(bookingModel.userUId)
        .collection(collectionNotification)
        .doc(notificationModel.id);
    wb.set(notificationDoc, notificationModel.toMap());
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllTransactionList() =>
      _db.collection(collectionTransaction).snapshots();

  static Future<bool> doesAdminExist(String uid) async {
    final snapshot = await _db.collection(collectionAdmin).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getAdminInfo(
          String uid) =>
      _db.collection(collectionAdmin).doc(uid).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAdminInfoMap(
          String uid) =>
      _db.collection(collectionAdmin).doc(uid).get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllBookedParking() =>
      _db.collection(collectionBooking).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getBookedInfoById(
          String bId) =>
      _db.collection(collectionBooking).doc(bId).get();

  //garage
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGarageInfo() =>
      _db.collection(collectionGarage).snapshots();

  static Future<void> addGarageInfo(GarageModel garageModel) {
    return _db
        .collection(collectionGarage)
        .doc(garageModel.gId)
        .set(garageModel.toMap());
  }

  static Future<void> updateGarageInfo(String gId, Map<String, dynamic> map) {
    return _db.collection(collectionGarage).doc(gId).update(map);
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getGarageInfoById(
          String gId) =>
      _db.collection(collectionGarage).doc(gId).get();

  static Future<void> createAdminUser(UserModel userModel) {
    final wb = _db.batch();
    final userDoc = _db.collection(collectionUser).doc(userModel.uid);
    final adminDoc = _db.collection(collectionAdmin).doc(userModel.uid);

    wb.set(userDoc, userModel.toMap());
    wb.update(adminDoc, {
      adminFieldIsGarage: true,
    });
    return wb.commit();
  }

  static Future<void> deleteBookingInfo(String bId, ParkingModel parkingModel) {
    final wb = _db.batch();
    final bookDoc = _db.collection(collectionBooking).doc(bId);
    wb.delete(bookDoc);
    //parkingInfo Update
    final parkingDoc =
        _db.collection(collectionParkingPoint).doc(parkingModel.parkId);
    wb.update(parkingDoc, {
      parkingFieldCapacityRemaining:
          (num.parse(parkingModel.capacityRemaining).toInt() + 1).toString()
    });
    return wb.commit();
  }

  //rating Query

  static Future<void> createRatingInParking(ParkingRatingModel ratingModel) {
    final wb = _db.batch();
    final parkDoc = _db
        .collection(collectionParkingPoint)
        .doc(ratingModel.parkingId)
        .collection(collectionRatings)
        .doc(ratingModel.ratingId);
    wb.set(parkDoc, ratingModel.toMap());

    final requestDoc =
        _db.collection("RatingRequest").doc(ratingModel.ratingId);
    wb.set(requestDoc, ratingModel.toMap());
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRatingOfAParking(
          String pId) =>
      _db
          .collection(collectionParkingPoint)
          .doc(pId)
          .collection(collectionRatings)
          .snapshots();

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllActiveRatingByIdInfo(
          String pId) =>
      _db
          .collection(collectionParkingPoint)
          .doc(pId)
          .collection(collectionRatings)
          .get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRatingRequest() =>
      _db.collection("RatingRequest").snapshots();

  static Future<void> publishRating(ParkingRatingModel ratingModel,
      NotificationModelOfUser notificationModel) {
    final wb = _db.batch();

    final parkDoc = _db
        .collection(collectionParkingPoint)
        .doc(ratingModel.parkingId)
        .collection(collectionRatings)
        .doc(ratingModel.ratingId);
    wb.update(parkDoc, {
      ratingFieldRatingIsAccept: true,
    });

    final requestDoc =
        _db.collection("RatingRequest").doc(ratingModel.ratingId);
    wb.delete(requestDoc);
    //add notification of user

    final notiDoc = _db
        .collection(collectionUser)
        .doc(ratingModel.userId)
        .collection(collectionNotification)
        .doc(notificationModel.id);
    wb.set(notiDoc, notificationModel.toMap());
    return wb.commit();
  }

  static Future<void> deleteRating(ParkingRatingModel ratingModel) {
    final wb = _db.batch();

    final parkDoc = _db
        .collection(collectionParkingPoint)
        .doc(ratingModel.parkingId)
        .collection(collectionRatings)
        .doc(ratingModel.ratingId);
    wb.delete(parkDoc);

    final requestDoc =
        _db.collection("RatingRequest").doc(ratingModel.ratingId);
    wb.delete(requestDoc);
    return wb.commit();
  }

//service
  static Future<void> saveServiceInfo(ServiceCost serviceModel) async {
    if (!await doesServiceInfoExist()) {
      return _db
          .collection(collectionServiceCost)
          .doc("costMap")
          .set(serviceModel.toMap());
    }
    return _db
        .collection(collectionServiceCost)
        .doc("costMap")
        .update(serviceModel.toMap());
  }

  static Future<bool> doesServiceInfoExist() async {
    final snapshot =
        await _db.collection(collectionServiceCost).doc("costMap").get();
    return snapshot.exists;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getServiceCost() =>
      _db.collection(collectionServiceCost).doc("costMap").get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserNotification(
      String uId) {
    return _db
        .collection(collectionUser)
        .doc(uId)
        .collection(collectionNotification)
        .snapshots();
  }

  static Future<void> updateNotificationDoc(String id) {
    return _db
        .collection(collectionUser)
        .doc(AuthService.currentUser!.uid)
        .collection(collectionNotification)
        .doc(id)
        .update({notificationFieldIsShowUser: true});
  }

//message app
  static Future<void> sentMessage({required MessageModel messageModel}) {
    final wb = _db.batch();
    final userSentDoc = _db
        .collection(collectionUser)
        .doc(messageModel.senderId)
        .collection(collectionMessages)
        .doc(messageModel.mId);
    final userReviverDoc = _db
        .collection(collectionUser)
        .doc(messageModel.revivedId)
        .collection(collectionMessages)
        .doc(messageModel.mId);
    wb.set(userReviverDoc, messageModel.toMap());
    wb.set(userSentDoc, messageModel.toMap());
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserMessages(
      String uId) {
    return _db
        .collection(collectionUser)
        .doc(uId)
        .collection(collectionMessages)
        .snapshots();
  }

  static Future<void> deleteMessage(MessageModel message, String uId) {
    return _db
        .collection(collectionUser)
        .doc(uId)
        .collection(collectionMessages)
        .doc(message.mId)
        .delete();
  }

  // help admin dask
  static Stream<QuerySnapshot<Map<String, dynamic>>> listOfAdmin() {
    return _db.collection(collectionAdmin).snapshots();
  }

  static Future<void> withDrawRequest(
      WithDrawMoneyModel withDrawMoneyModel, UserModel userModel) {
    final wb = _db.batch();

    final withDoc =
        _db.collection(collectionWithDrawRequests).doc(withDrawMoneyModel.tId);
    wb.set(withDoc, withDrawMoneyModel.toMap());

    final userDoc = _db.collection(collectionUser).doc(userModel.uid);
    int userBalance = (num.parse(userModel.balance).toInt() -
        num.parse(withDrawMoneyModel.withDrawBalance).toInt());
    wb.update(userDoc, {userFieldBalance: userBalance.toString()});
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllWithDrawRequest() {
    return _db.collection(collectionWithDrawRequests).snapshots();
  }

  static Future<void> updateWithDrawInfo(String tId, Map<String, Object> map) {
    return _db.collection(collectionWithDrawRequests).doc(tId).update(map);
  }

  static Future<void> deleteWithDrawInfo(
      WithDrawMoneyModel moneyModel, String balance) {
    final wb = _db.batch();

    final withDoc =
        _db.collection(collectionWithDrawRequests).doc(moneyModel.tId);
    wb.delete(withDoc);

    if (moneyModel.rejectStatus) {
      final userDoc =
          _db.collection(collectionUser).doc(moneyModel.garageOwnerId);
      wb.update(userDoc, {
        userFieldBalance: balance,
      });
    }
    return wb.commit();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_finder/model/vicModel.dart';

import 'garage_model.dart';

const String collectionBooking = 'ParkingBook';
const String bookingFieldBId = 'bId';
const String bookingFieldParkingUId = 'parkingUId';
const String bookingFieldUserUId = 'userUId';
const String bookingFieldDuration = 'duration';
const String bookingFieldCost = 'cost';
const String bookingFieldBookingTime = 'bookingTime';
const String bookingFieldIsAccept = 'isAccept';
const String bookingFieldStartTime = 'startTime';
const String bookingFieldEndTime = 'endTime';
const String bookingFieldAcceptAdminUId = 'acceptAdminUId';
const String bookingFieldIsBookedUserShow = 'showBookedUser';
const String bookingFieldIsOnlinePayment = 'onlinePayment';
const String bookingFieldSelectVehicleType = 'selectVehicleType';

class BookingModel {
  String bId;
  String parkingPId;
  String garageGId;
  String userUId;
  String duration;
  String cost;
  Timestamp bookingTime;
  String startTime;
  String endTime;
  SpotInformation spotInformation;
  VicModel selectVehicleType;
  String? acceptAdminUId;
  bool isAccept;
  bool showBookedUser;
  bool onlinePayment;

  BookingModel({
    required this.bId,
    required this.garageGId,
    required this.spotInformation,
    required this.parkingPId,
    required this.userUId,
    required this.duration,
    required this.cost,
    required this.bookingTime,
    required this.onlinePayment,
    required this.selectVehicleType,
    this.isAccept = false,
    this.showBookedUser = false,
    this.startTime = '0',
    this.endTime = '0',
    this.acceptAdminUId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      bookingFieldBId: bId,
      'spotInformation': spotInformation.toJson(),
      'garageGId': garageGId,
      bookingFieldParkingUId: parkingPId,
      bookingFieldUserUId: userUId,
      bookingFieldDuration: duration,
      bookingFieldCost: cost,
      bookingFieldBookingTime: bookingTime,
      bookingFieldIsAccept: isAccept,
      bookingFieldStartTime: startTime,
      bookingFieldEndTime: endTime,
      bookingFieldAcceptAdminUId: acceptAdminUId,
      bookingFieldIsBookedUserShow: showBookedUser,
      bookingFieldIsOnlinePayment: onlinePayment,
      bookingFieldSelectVehicleType: selectVehicleType.toJson(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) => BookingModel(
        bId: map[bookingFieldBId],
        spotInformation: SpotInformation.fromJson(map['spotInformation']),
        garageGId: map['garageGId'],
        parkingPId: map[bookingFieldParkingUId],
        userUId: map[bookingFieldUserUId],
        duration: map[bookingFieldDuration],
        cost: map[bookingFieldCost],
        bookingTime: map[bookingFieldBookingTime],
        isAccept: map[bookingFieldIsAccept],
        startTime: map[bookingFieldStartTime],
        endTime: map[bookingFieldEndTime],
        acceptAdminUId: map[bookingFieldAcceptAdminUId],
        showBookedUser: map[bookingFieldIsBookedUserShow],
        onlinePayment: map[bookingFieldIsOnlinePayment],
        selectVehicleType:
            VicModel.fromJson(map[bookingFieldSelectVehicleType]),
      );
}

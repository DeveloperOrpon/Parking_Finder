import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionRatings = 'ParkingRatings';
const String ratingFieldRatingId = 'ratingId';
const String ratingFieldRating = 'rating';
const String ratingFieldRatingComment = 'comment';
const String ratingFieldRatingUid = 'userId';
const String ratingFieldRatingParkId = 'parkingId';
const String ratingFieldAcceptsAdminId = 'acceptsAdminId';
const String ratingFieldRatingTime = 'ratingTime';
const String ratingFieldRatingIsAccept = 'adminAccept';
const String ratingFieldRatingTotalLike = 'totalLikeComment';

class ParkingRatingModel {
  String ratingId;
  String rating;
  String comment;
  String userId;
  String parkingId;
  String? acceptsAdminId;
  Timestamp ratingTime;
  bool adminAccept;
  String totalLikeComment;

  ParkingRatingModel({
    required this.ratingId,
    required this.rating,
    required this.comment,
    required this.userId,
    required this.parkingId,
    required this.ratingTime,
    this.adminAccept = false,
    this.acceptsAdminId,
    this.totalLikeComment = '0',
  });

  Map<String, dynamic> toMap() {
    return {
      ratingFieldRatingId: ratingId,
      ratingFieldRating: rating,
      ratingFieldRatingComment: comment,
      ratingFieldRatingUid: userId,
      ratingFieldRatingParkId: parkingId,
      ratingFieldRatingTime: ratingTime,
      ratingFieldRatingIsAccept: adminAccept,
      ratingFieldAcceptsAdminId: acceptsAdminId,
      ratingFieldRatingTotalLike: totalLikeComment,
    };
  }

  static ParkingRatingModel fromMap(Map<String, dynamic> map) {
    return ParkingRatingModel(
      ratingId: map[ratingFieldRatingId],
      rating: map[ratingFieldRating],
      comment: map[ratingFieldRatingComment],
      userId: map[ratingFieldRatingUid],
      parkingId: map[ratingFieldRatingParkId],
      ratingTime: map[ratingFieldRatingTime],
      adminAccept: map[ratingFieldRatingIsAccept],
      acceptsAdminId: map[ratingFieldAcceptsAdminId],
      totalLikeComment: map[ratingFieldRatingTotalLike],
    );
  }
}

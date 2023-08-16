const String collectionRating = 'Rating';
const String ratingFieldId = 'rId';
const String ratingFieldUserModel = 'userModel';
const String ratingFieldProductId = 'productId';
const String ratingFieldRating = 'rating';
const String ratingFieldReview = 'review';

class RatingModel {
  String rId;
  String userId;
  String productId;
  String rating;
  String review;

  RatingModel({
    required this.rId,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ratingFieldId: rId,
      ratingFieldUserModel: userId,
      ratingFieldProductId: productId,
      ratingFieldRating: rating,
      ratingFieldReview: review
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) => RatingModel(
      rId: map[ratingFieldId],
      userId: map[ratingFieldUserModel],
      rating: map[ratingFieldRating],
      review: map[ratingFieldReview],
      productId: map[ratingFieldProductId]);
}

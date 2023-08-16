import 'package:flutter/material.dart';

import '../model/Review_Model.dart';

class ParkingProvider extends ChangeNotifier {
  PageController parkingImageSlider = PageController();
  List<RatingModel> filterRating = [];
  List<String> listImages = [
    'https://firebasestorage.googleapis.com/v0/b/parking-koi-42e64.appspot.com/o/PostImages%2F1678946478182377?alt=media&token=b1e81edf-904f-4ba3-8e49-63163440dce8',
    'https://firebasestorage.googleapis.com/v0/b/parking-koi-42e64.appspot.com/o/PostImages%2F1678946478182377?alt=media&token=b1e81edf-904f-4ba3-8e49-63163440dce8',
    'https://firebasestorage.googleapis.com/v0/b/parking-koi-42e64.appspot.com/o/PostImages%2F1678946478182377?alt=media&token=b1e81edf-904f-4ba3-8e49-63163440dce8',
  ];
  List<RatingModel> ratings = [
    RatingModel(
        rId: '33',
        userId: '44',
        productId: '33',
        rating: '3.4',
        review: "It's Good")
  ];
}

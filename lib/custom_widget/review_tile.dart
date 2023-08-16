import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parking_finder/model/Review_Model.dart';
import 'package:parking_finder/utilities/app_colors.dart';

class ReviewTile extends StatelessWidget {
  final RatingModel review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Photo
          Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: review.userId == '1'
                  ? CachedNetworkImage(
                      imageUrl: review.userId,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const SpinKitPianoWave(
                        color: AppColors.primarySoft,
                        size: 20.0,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : TextAvatar(
                      text: 'Orpon',
                      size: 30,
                    )),
          // Username - Rating - Comments
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username - Rating
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Flexible(
                            flex: 8,
                            child: Text(
                              'Orpon',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: 'poppins'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            review.review,
                            style: const TextStyle(
                                color: Colors.black26, height: 150 / 100),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 4,
                            child: RatingBar.builder(
                                allowHalfRating: false,
                                itemSize: 16,
                                glowColor: Colors.orange[400],
                                initialRating:
                                    num.parse(review.rating).toDouble(),
                                unratedColor: AppColors.primarySoft,
                                onRatingUpdate: (double value) {},
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Comments
              ],
            ),
          ),
        ],
      ),
    );
  }
}

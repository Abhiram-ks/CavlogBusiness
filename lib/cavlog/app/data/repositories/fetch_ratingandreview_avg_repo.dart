import 'package:cloud_firestore/cloud_firestore.dart';

class RatingServiceUsecase {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Stream<double> fetchAverageRating(String barberId) {
    return _firebase
        .collection('reviews')
        .doc(barberId)
        .collection('shop_reviews')
        .snapshots()
        .map((snapshot) {
          final reviews = snapshot.docs;

          if (reviews.isEmpty) return 0.0;

          final starList = reviews.map((doc) => (doc.data()['starCount'] as num?)?.toDouble() ?? 0.0).toList();
          final totalStars = starList.reduce((a, b) => a + b);

          return totalStars / starList.length;
        });
  }
}



import 'package:barber_pannel/cavlog/app/data/models/post_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_barberdata_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../models/post_with_barber.dart';

class PostService {
  final FetchBarberRepository _barberRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PostService(this._barberRepository);

  Stream<List<PostWithBarberModel>> fetchABarberPost({required String barberId}) {
    return _barberRepository.streamBarberData(barberId).switchMap((barber) {
      if (barber == null) return Stream.value([]);

      final postsRef = _firestore
          .collection('posts')
          .doc(barber.uid)
          .collection('Post')
          .orderBy('createdAt', descending: true);

      return postsRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final post = PostModel.fromDocument(barber.uid, doc);
          return PostWithBarberModel(post: post, barber: barber);
        }).toList();
      });
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/banner_model.dart';


abstract class FetchBannerRepository {
  Stream<BannerModels> streamBanners(); 
}

class FetchBannerRepositoryImpl implements FetchBannerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<BannerModels> streamBanners() {
    try {
      return _firestore
          .collection('banner_images')
          .doc('barber_doc')
          .snapshots()
          .map((snapshot) {
        final data = snapshot.data() ?? {};
        return BannerModels.fromMap(data);
      });
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:barber_pannel/cavlog/app/data/models/wallet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FetchBarberWalletRepository {
  Stream<BarberWalletModel> fetchWalletData(String barberId);
}

class FetchBarberWalletRepositoryImpl implements FetchBarberWalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<BarberWalletModel> fetchWalletData(String barberId) {
    try {
      final docRef = _firestore.collection('shop_wallet').doc(barberId);

      return docRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          return BarberWalletModel.fromMap(snapshot.data()!);
        } else {
          throw Exception('Wallet data not found');
        }
      });
    } catch (e) {
      return Stream.error('Failed to fetch wallet data: $e');
    }
  }
}
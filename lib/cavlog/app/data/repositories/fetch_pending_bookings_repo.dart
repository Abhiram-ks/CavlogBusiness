import 'package:barber_pannel/cavlog/app/data/models/booking_with_user_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_booking_with_user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FetchPendingBookingsRepository {
  Stream<List<BookingWithUserModel>> streamBookingsWithUser({required String barberId});
}

class FetchPendingBookingsRepositoryImpl implements FetchPendingBookingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserServices _services;

  FetchPendingBookingsRepositoryImpl(this._services);

  @override
  Stream<List<BookingWithUserModel>> streamBookingsWithUser({required String barberId}) {
    return _firestore
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('service_status',isEqualTo: 'Pending')
        .snapshots()
        .asyncMap((snapshot) => _services.attachUserToBookings(snapshot));
  }
}
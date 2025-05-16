import 'dart:developer';

import 'package:barber_pannel/cavlog/app/data/models/booking_model.dart';
import 'package:barber_pannel/cavlog/app/data/models/booking_with_user_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_users_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FetchBookingAndUserRepository {
  Stream<List<BookingWithUserModel>> streamBookingsWithUser({required String barberID});
}

class FetchBookingWithUserRepositoryImpl implements FetchBookingAndUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserServices _userServices;

  FetchBookingWithUserRepositoryImpl(this._userServices);

  @override
  Stream<List<BookingWithUserModel>> streamBookingsWithUser({required String barberID}) {
    return _firestore
        .collection('bookings')
        .where('barberId', isEqualTo: barberID)
        .snapshots()
        .asyncMap((snapshot) => _userServices.attachUserToBookings(snapshot));
  }
}



class UserServices {
  final FetchUserRepository _fetchUserRepository;

  UserServices(this._fetchUserRepository);

  Future<List<BookingWithUserModel>> attachUserToBookings(QuerySnapshot snapshot) async {
    final futures = snapshot.docs.map((doc) async {
      try {
        final booking = BookingModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        final user = await _fetchUserRepository.streamUserData(booking.userId).first;
        if (user != null) {
          return BookingWithUserModel(booking: booking, user: user);
        }
        return null;
      } catch (e) {
        log('Error fetching user for booking ID ${doc.id}: $e');
        return null;
      }
    });

    final results = await Future.wait(futures);
    final validBookings = results.whereType<BookingWithUserModel>().toList();
    validBookings.sort((a, b) => b.booking.createdAt.compareTo(a.booking.createdAt));
    return validBookings;
  }
}

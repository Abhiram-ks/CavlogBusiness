import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart' show BookingModel;


abstract class FetchBookingTransactionRepository {
  Stream<List<BookingModel>> streamBookings({required String barberId});
}

class FetchBookingRepositoryImpl implements FetchBookingTransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<BookingModel>> streamBookings({required String barberId}) {
final bookingQuery = _firestore
    .collection('bookings')
    .where('barberId', isEqualTo: barberId);

   return bookingQuery.snapshots().map((snapshot) {
  try {
    final bookings = snapshot.docs.map((doc) {
      final booking = BookingModel.fromMap(doc.id, doc.data());
      return booking;
    }).toList();
    
    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bookings;
    
  } catch (e, stacktrace) {
    log('Error parsing booking: $e\n$stacktrace');
    return <BookingModel>[]; 
  }
});
  }
}

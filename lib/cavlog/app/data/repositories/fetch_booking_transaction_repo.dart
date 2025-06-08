
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart' show BookingModel;

abstract class FetchBookingTransactionRepository {
  Stream<List<BookingModel>> streamBookings({required String barberId});
  Stream<List<BookingModel>> streamBookingFiltering({required String barberId, required String status});
  Stream<List<BookingModel>> streamBookingTransaction({required String barberId, required String status});
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
      } catch (e) {
        return <BookingModel>[];
      }
    });
  }

  @override
  Stream<List<BookingModel>> streamBookingFiltering(
      {required String barberId, required String status}) {
    final bookingQuery = _firestore
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('service_status', isEqualTo: status);

    return bookingQuery.snapshots().map((snapshot) {
      try {
        final bookings = snapshot.docs.map((doc) {
          final booking = BookingModel.fromMap(doc.id, doc.data());
          return booking;
        }).toList();

        bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return bookings;
      } catch (e) {
        return <BookingModel>[];
      }
    });
  }

    @override
  Stream<List<BookingModel>> streamBookingTransaction(
      {required String barberId, required String status}) {
    final bookingQuery = _firestore
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('transaction', isEqualTo: status);

    return bookingQuery.snapshots().map((snapshot) {
      try {
        final bookings = snapshot.docs.map((doc) {
          final booking = BookingModel.fromMap(doc.id, doc.data());
          return booking;
        }).toList();

        bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return bookings;
      } catch (e) {
        return <BookingModel>[];
      }
    });
  }
}

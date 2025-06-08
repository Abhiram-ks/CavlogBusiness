import 'package:barber_pannel/cavlog/app/data/models/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FetchBookingUserRepository {
  Stream<List<BookingModel>> streamBookings({required String userId,required String barberId});
  Stream<List<BookingModel>> streamBookingsFilter({required String userId, required String barberId, required String status});
}

class FetchBookingUserRepositoryImpl implements FetchBookingUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<BookingModel>> streamBookings({required String userId,required String barberId}) {
    final bookingQuery = _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
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
   Stream<List<BookingModel>> streamBookingsFilter({required String userId, required String barberId, required String status}) {
    final bookingQuery = _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('barberId', isEqualTo: barberId)
        .where('service_status', isEqualTo:  status);

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

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart';

abstract class FetchRevenueDayRepository {
  Stream<List<BookingModel>> fetchByDay({
    required String barberId,
    required DateTime startDate,
    required DateTime endDate,
  });
}


class FetchRevenueDayRepositoryImpl implements FetchRevenueDayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<BookingModel>> fetchByDay({
    required String barberId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    log('start date is to : $startDate and end date is to $endDate');
    return _firestore
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThan: endDate)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => BookingModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}


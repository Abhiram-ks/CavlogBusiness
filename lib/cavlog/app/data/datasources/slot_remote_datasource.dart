import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../domain/usecases/generate_slot_usecase.dart';
import '../../presentation/provider/cubit/booking_generate_cubit/duration_picker/duration_picker_cubit.dart';
import '../models/slot_model.dart';



abstract class SlotRepository  {
  Future<bool> uploadSlots({required String barberUid,required DurationTime duration ,required DateTime selectedDate,required List<Map<String, dynamic>> slotTime});
}

class SlotRepositoryImpl implements SlotRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  @override
  Future<bool> uploadSlots({
    required String barberUid,
    required DateTime selectedDate,
    required List<Map<String, dynamic>> slotTime,
    required DurationTime duration,
  }) async {
    try {
      String formattedDateForDoc = DateFormat('dd-MM-yyyy').format(selectedDate);
      String formattedDateForField = DateFormat('dd/MM/yyyy').format(selectedDate);
      IntravelConverter converter = IntravelConverter(duration);
      Duration slotDuration = converter.getDurationType();

     final dateDocRef = _firestore
          .collection('slots')
          .doc(barberUid)
          .collection('dates')
          .doc(formattedDateForDoc);

      return await _firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(dateDocRef);

      if (docSnapshot.exists) {
        log('Slot already exists for this date.');
        return false;
      }

        transaction.set(dateDocRef, {'createdAt': FieldValue.serverTimestamp()});

      for (Map<String, dynamic> slot in slotTime) {
        
        final DateTime startDateTime = slot['startDateTime'];
        final DateTime endDateTime = slot['endDateTime'];

        final slotRef = dateDocRef.collection('slot').doc();

        final slotModel = SlotModel(
          docId: dateDocRef.id,
          subDocId: slotRef.id,
          shopId: barberUid,
          startTime: startDateTime,
          endTime: endDateTime,
          date: formattedDateForField,
          booked: false,
          available: true,
          duration: slotDuration,
        );
        
        transaction.set(slotRef, slotModel.toMap());
      }

      return true;
    });
  } catch (e) {
    log('Error: $e');
    return false;
  }
}
}
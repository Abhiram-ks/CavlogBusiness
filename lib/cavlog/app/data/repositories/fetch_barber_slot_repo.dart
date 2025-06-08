
import 'package:barber_pannel/cavlog/app/data/models/slot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/date_model.dart'; 

abstract class FetchSlotsRepository {
  Stream<List<DateModel>> streamDates(String barberUid);
  Stream<List<SlotModel>> streamSlots({required String barberUid,required DateTime selectedDate});
  
}

class FetchSlotsRepositoryImpl implements FetchSlotsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  
  @override
  Stream<List<DateModel>> streamDates(String barberUid) {
    final datesCollection = _firestore
        .collection('slots')
        .doc(barberUid)
        .collection('dates');

    return datesCollection.snapshots().map((datesSnapshot) {
      try {
        return datesSnapshot.docs.map((doc) {
          return DateModel.fromDocument(doc);
        }).toList();
      } catch (e) {
        return <DateModel>[];  
      }
    });
  }

  @override
  Stream<List<SlotModel>> streamSlots({required String barberUid, required DateTime selectedDate }) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    final datesCollection = _firestore
        .collection('slots')
        .doc(barberUid)
        .collection('dates')
        .doc(formattedDate)
        .collection('slot')
        .orderBy('startTime');

    return datesCollection.snapshots().map((slotSnapshot) {
      try {

        final List<SlotModel> allSlots = slotSnapshot.docs.map((doc) => SlotModel.fromMap(doc.data())).toList();

        allSlots.sort((a,b) => a.startTime.compareTo(b.startTime));
        return allSlots;
      } catch (e) {
        return <SlotModel>[];
      }
    });
  }
}


import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DeleteOldSlotsService {
  Future<void> deleteOldSlotsWithIsolate(String barberUid) async {

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final dateCollectionRef = FirebaseFirestore.instance
          .collection('slots')
          .doc(barberUid)
          .collection('dates');

      final dateDocs = await dateCollectionRef.get();
      final List<String> docIds = dateDocs.docs.map((doc) => doc.id.trim()).toList();

      if (docIds.isEmpty) {
        return;
      }

      final receivePort = ReceivePort();

      await Isolate.spawn<_DeleteSlotParams>(
          _isolateEntry,
          _DeleteSlotParams(docIds, today, receivePort.sendPort));

      final List<String> oldDocIds = await receivePort.first;

      for (String docId in oldDocIds) {
        final docRef = dateCollectionRef.doc(docId);

     
       try {
          final slotSubcollection = await docRef.collection('slot').get();
          WriteBatch batch = FirebaseFirestore.instance.batch();
          
          for (var slotDoc in slotSubcollection.docs) {
            batch.delete(slotDoc.reference);
          }
          
          await batch.commit();
          
          await docRef.delete();
        } catch (e) {
          rethrow;
        }
      }
      
      return;
    } catch (e) {
      rethrow; 
    }
  }

  static void _isolateEntry(_DeleteSlotParams params) {
    List<String> oldDocIds = [];
     final dateFormat = DateFormat('dd-MM-yyyy');

    for (String docId in params.docIds) {
      try {
        DateTime docDate = dateFormat.parse(docId);
        final docDateOnly = DateTime(docDate.year, docDate.month, docDate.day);

        if (docDateOnly.isBefore(params.today)) {
          oldDocIds.add(docId);
        }
      } catch (e) {
        continue; 
      }
    }

    params.sendPort.send(oldDocIds);
  }
}

class _DeleteSlotParams {
  final List<String> docIds;
  final DateTime today;
  final SendPort sendPort;

  _DeleteSlotParams(this.docIds, this.today, this.sendPort);
}
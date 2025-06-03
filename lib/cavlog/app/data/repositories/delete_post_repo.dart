import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DeletePostRepository {
  Future<bool> deletePost({required String barberId, required String docId}); 
}

class DeletePostRepositoryImpl implements DeletePostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> deletePost({required String barberId, required String docId}) async {
    try {
      final docRef = _firestore
          .collection('posts')
          .doc(barberId)
          .collection('Post')
          .doc(docId);

      await docRef.delete(); 
      return true;
    } catch (e) {
      return false;
    }
  }
}


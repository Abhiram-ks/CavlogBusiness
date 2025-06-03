import 'dart:developer';

import 'package:barber_pannel/cavlog/app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'fetch_users_repo.dart';

abstract class FetchMessageAndBarberRepo {
  Stream<List<UserModel>> streamChat({required String barberId});
}

class MessageRepositoryImpl implements FetchMessageAndBarberRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FetchUserRepository _repository;

  MessageRepositoryImpl(this._repository);

  @override
Stream<List<UserModel>> streamChat({required String barberId}) {
  return _firestore
      .collection('chat')
      .where('barberId', isEqualTo: barberId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .switchMap((querySnapshot) {
    final userIds = querySnapshot.docs
        .map((doc) => doc.data()['userId'] as String?)
        .whereType<String>()
        .toSet()
        .toList();

    if (userIds.isEmpty) {
      return Stream.value(<UserModel>[]);
    }

    final userStreams = userIds
        .map((id) => _repository.streamUserData(id)
            .handleError((e) {
              log('Error streaming barber $id: $e');
            }))
        .toList();

    return Rx.combineLatestList<UserModel?>(userStreams).map(
      (barbers) => barbers.whereType<UserModel>().toList(),
    );
  });
}

}
import 'package:barber_pannel/cavlog/app/data/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatRemoteDatasources {
  Future<bool>sendMessage({required ChatModel message});
}

class ChatRemoteDatasourcesImpl implements ChatRemoteDatasources {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ChatRemoteDatasourcesImpl();

  @override
  Future<bool> sendMessage({required ChatModel message}) async {
    try {
      await firestore.collection('chat').add(message.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}

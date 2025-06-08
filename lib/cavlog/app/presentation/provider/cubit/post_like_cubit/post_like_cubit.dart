
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikePostCubit extends Cubit<void> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LikePostCubit() : super(null);

  Future<void> toggleLike({
    required String barberId,
    required String postId,
    required List<String> currentLikes,
  }) async {
    final postRef = _firestore
        .collection('posts')
        .doc(barberId)
        .collection('Post')
        .doc(postId);
    

    final isLiked = currentLikes.contains(barberId);
    
    try {
      await postRef.update({
        'likes': isLiked
            ? FieldValue.arrayRemove([barberId])
            : FieldValue.arrayUnion([barberId]),
      });
    } catch (e) {
      rethrow;
    }
  }
}

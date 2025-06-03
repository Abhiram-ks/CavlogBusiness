import 'package:barber_pannel/cavlog/app/data/repositories/delete_post_repo.dart';
import 'package:bloc/bloc.dart';
part 'delete_post_state.dart';

class DeletePostCubit extends Cubit<DeletePostState> {
  final DeletePostRepository _repo;

  DeletePostCubit(this._repo) : super(DeletePostInitial());

  void deletePost({required String barberId, required String docId}) async {
    emit(DeletePostLoading());
    try {
      final bool response = await _repo.deletePost(barberId: barberId, docId: docId);
      if (!response) {
        emit(DeletePostFailure());
        return;
      }
      emit(DeletePostSuccess());
    } catch (e) {
      emit(DeletePostFailure());
    }
  }
}


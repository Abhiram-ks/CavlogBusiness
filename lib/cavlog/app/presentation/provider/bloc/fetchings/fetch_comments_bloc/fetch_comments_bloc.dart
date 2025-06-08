import 'package:barber_pannel/cavlog/app/data/models/comment_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_comment_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'fetch_comments_event.dart';
part 'fetch_comments_state.dart';


class FetchCommentsBloc extends Bloc<FetchCommentsEvent, FetchCommentsState> {
  final SendCommentRepository _repository;
  FetchCommentsBloc(this._repository) : super(FetchCommentsInitial()) {
    on<FetchCommentRequst>(_onFetchCommentsRequst);
  }

  Future<void> _onFetchCommentsRequst(
    FetchCommentRequst event,
    Emitter<FetchCommentsState> emit,
  ) async {
    emit(FetchCommentsLoading());

    try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchCommentsFailure());
        return;
      }
      await emit.forEach(
        _repository.fetchComments(barberId: barberUid, docId: event.docId), 
        onData: (comments) {
          if (comments.isEmpty) {
            return FetchCommentsEmpty();
          } else {
            return FetchCommentsSuccess(comments: comments,barberID: barberUid);
          }
        },
        onError:  (_, __) => FetchCommentsFailure()
      );
    } catch (e) {
      emit(FetchCommentsFailure());
    }
  }

}

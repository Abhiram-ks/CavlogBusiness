import 'package:barber_pannel/cavlog/app/data/repositories/fetch_post_with_barber_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../data/models/post_with_barber.dart';
part 'fetch_post_with_barber_event.dart';
part 'fetch_post_with_barber_state.dart';

class FetchPostWithBarberBloc extends Bloc<FetchPostWithBarberEvent, FetchPostWithBarberState> {
  final PostService _postService;

  FetchPostWithBarberBloc(this._postService) : super(FetchPostWithBarberInitial()) {
    on<FetchPostWithBarberRequest>(_onFetchPostWithBarber);
  }

  Future<void> _onFetchPostWithBarber(
    FetchPostWithBarberRequest event,
    Emitter<FetchPostWithBarberState> emit,
  ) async {
    emit(FetchPostWithBarberLoading());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchPostWithBarberFailure('Barber Not found!'));
        return;
      }
    await emit.forEach<List<PostWithBarberModel>>(
      
      _postService.fetchABarberPost(barberId: barberUid),
      onData: (posts) {
        if (posts.isEmpty) {
          return FetchPostWithBarberEmpty();
        } else {
          return FetchPostWithBarberLoaded(model: posts,barberId: barberUid);
        }
      },
      onError: (error, _) => FetchPostWithBarberFailure(error.toString()),
    );
  }
}

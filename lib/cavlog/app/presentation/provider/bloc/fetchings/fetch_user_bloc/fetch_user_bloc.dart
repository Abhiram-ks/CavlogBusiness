import 'dart:async';

import 'package:barber_pannel/cavlog/app/data/repositories/fetch_users_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../../../data/models/user_model.dart';

part 'fetch_user_event.dart';
part 'fetch_user_state.dart';

class FetchUserBloc extends Bloc<FetchUserEvent, FetchUserState> {
  final FetchUserRepository _repository;

  FetchUserBloc(this._repository) : super(FetchUserInitial()) {
    on<FetchUserRequest>(_onFetchUserDetailsRequest);
  }

  Future<void> _onFetchUserDetailsRequest(
    FetchUserRequest event,
    Emitter<FetchUserState> emit,
  ) async {
    emit(FatchUserLoading()); 
    await emit.forEach<UserModel?>(
      _repository.streamUserData(event.userID),
      onData: (user) {
        if (user != null) {
          return FetchUserLoaded(users: user);
        } else {
          return  FetchUserFailure("User not found");
        }
      },
      onError: (error, _) => FetchUserFailure(error.toString()),
    );
  }
}

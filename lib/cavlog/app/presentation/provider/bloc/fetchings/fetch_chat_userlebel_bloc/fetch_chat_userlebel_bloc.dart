import 'dart:developer';
import 'package:barber_pannel/cavlog/app/data/models/user_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_message_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'fetch_chat_userlebel_event.dart';
part 'fetch_chat_userlebel_state.dart';

class FetchChatUserlebelBloc extends Bloc<FetchChatUserlebelEvent, FetchChatUserlebelState> {
  final FetchMessageAndBarberRepo _repository;
  FetchChatUserlebelBloc(this._repository) : super(FetchChatUserlebelInitial()) {
    on<FetchChatLebelUserRequst>(_onFetchchatWithUserRequest);
    on<FetchChatLebelUserSearch>(_onFetchchatwithBarberSerch);
  }
  

  Future<void> _onFetchchatWithUserRequest(
    FetchChatLebelUserRequst event,
    Emitter<FetchChatUserlebelState> emit,   
  ) async {  
    emit(FetchChatUserlebelLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchChatUserlebelFailure());
        return;
      }

      await emit.forEach<List<UserModel>>(
        _repository.streamChat(barberId: barberUid), 
        onData: (chat) {
          if (chat.isEmpty) {
            return FetchChatUserlebelEmpty();
          } else {
            return FetchChatUserlebelSuccess(chat);
          }
        },
           onError: (error, stackTrace) {
          log('Stream error: $error\n$stackTrace');
          return FetchChatUserlebelFailure();
        },
        );
    } catch (e) {
      emit(FetchChatUserlebelFailure());
    }
  }


  
  void _onFetchchatwithBarberSerch(
    FetchChatLebelUserSearch event,
    Emitter<FetchChatUserlebelState> emit,
  )async{
    emit(FetchChatUserlebelLoading());
     final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchChatUserlebelFailure());
        return;
      }
    await emit.forEach<List<UserModel>>(
      _repository.streamChat(barberId: barberUid),
      onData: (users){
        final filteredBarbers = users.where((user) => (user.userName ?? 'Unknow user').toLowerCase().contains(event.searchController.toLowerCase())).toList();

        if (filteredBarbers.isEmpty) {
           return FetchChatUserlebelEmpty();
        }else {
           return FetchChatUserlebelSuccess(filteredBarbers);
        }
      },
       onError: (error, stackTrace) {
        return FetchChatUserlebelFailure();
      },
    );

  }

}

import 'package:barber_pannel/cavlog/app/data/models/booking_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../data/repositories/fetch_booking_user_repo.dart';
part 'fetch_booking_user_event.dart';
part 'fetch_booking_user_state.dart';

class FetchBookingUserBloc extends Bloc<FetchBookingUserEvent, FetchBookingUserState> {
  final FetchBookingUserRepository _repository;
  FetchBookingUserBloc(this._repository) : super(FetchBookingUserInitial()) {
    on<FetchBookingUserRequest>(_onFetchingBookingUserRequest);
    on<FetchBookingUserFiltering>(_onFetchingBookingUserFiltering);
  }


  Future<void> _onFetchingBookingUserRequest(
    FetchBookingUserRequest event,
    Emitter<FetchBookingUserState> emit,
  ) async {
    emit(FetchBookingUserLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchBookingUserFailure('Shop ID not found. Please log in again.'));
        return;
      }
      await emit.forEach<List<BookingModel>>(
        _repository.streamBookings(userId: event.userId,barberId: barberUid),
        onData: (booking) {
          if (booking.isEmpty) {
            return FetchBookingUserEmptys();
          } else {
            return FetchBookingUserLoaded(combo: booking);
          }
        },
        onError: (error, stackTrace) {
          return FetchBookingUserFailure('could not load booking data. Please try again leter.');
        },
      );
    } catch (e) {
      emit(FetchBookingUserFailure('An unexpected error occurred. Please check your connection. $e'));
    }
  }

  Future<void> _onFetchingBookingUserFiltering(
    FetchBookingUserFiltering event,
    Emitter<FetchBookingUserState> emit,
  ) async {
    emit(FetchBookingUserLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchBookingUserFailure('Shop ID not found. Please log in again.'));
        return;
      }
      await emit.forEach<List<BookingModel>>(
        _repository.streamBookingsFilter(userId: event.userId,barberId: barberUid,status: event.filter),
        onData: (booking) {
          if (booking.isEmpty) {
            return FetchBookingUserEmptys();
          } else {
            return FetchBookingUserLoaded(combo: booking);
          }
        },
        onError: (error, stackTrace) {
          return FetchBookingUserFailure('could not load booking data. Please try again leter.');
        },
      );
    } catch (e) {
      emit(FetchBookingUserFailure('An unexpected error occurred. Please check your connection. $e'));
    }
  }
}

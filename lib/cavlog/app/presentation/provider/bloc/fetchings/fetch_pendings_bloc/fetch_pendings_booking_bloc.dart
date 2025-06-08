import 'package:barber_pannel/cavlog/app/data/models/booking_with_user_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_pending_bookings_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fetch_pendings_booking_event.dart';
part 'fetch_pendings_booking_state.dart';

class FetchPendingsBookingBloc extends Bloc<FetchPendingsBookingEvent, FetchPendingsBookingState> {
  final FetchPendingBookingsRepository _repo;
  FetchPendingsBookingBloc(this._repo) : super(FetchPendingsBookingInitial()) {
    on<FetchPendingsBookingRequest>(_onFetchPendingBookingRequest);
  }

  Future<void> _onFetchPendingBookingRequest(
    FetchPendingsBookingRequest event,
    Emitter<FetchPendingsBookingState> emit,
  ) async {
    emit(FetchPendingsBookingLoading());
    try {
       final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchPendingsBookingFailure());
        return;
      }
      await emit.forEach<List<BookingWithUserModel>>(
        _repo.streamBookingsWithUser(barberId: barberUid),
        onData: (booking) {
          if (booking.isEmpty) {
            return FetchPendingsBookingEmpty();
          }else{
            return FetchPendingsBookingLoaded(combo: booking);
          }
        },
        onError: (error, stackTrace) {
          return FetchPendingsBookingFailure();
        },
      );
    } catch (e) {
      emit(FetchPendingsBookingFailure());
    }
  }
}

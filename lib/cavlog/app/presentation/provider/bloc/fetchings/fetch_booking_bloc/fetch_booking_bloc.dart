

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../data/models/booking_model.dart';
import '../../../../../data/repositories/fetch_booking_transaction_repo.dart';
part 'fetch_booking_event.dart';
part 'fetch_booking_state.dart';

class FetchBookingBloc extends Bloc<FetchBookingEvent, FetchBookingState> {
  final FetchBookingTransactionRepository _bookingTransactionRepository;
  FetchBookingBloc(this._bookingTransactionRepository)
  : super(FetchBookingInitial()) {
    on<FetchBookingDatsRequest>(_onFetchBookingDatsRequest);
    on<FetchBookingDatasFilteringTransaction>(_onFilterBookingTransaction);
    on<FetchBookingDatasFilteringStatus>(_onFilterBookingStatus);
  }

  Future<void> _onFetchBookingDatsRequest(
    FetchBookingDatsRequest event,
    Emitter<FetchBookingState> emit,
  ) async {
    emit(FetchBookingLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchBookingFailure('Shop ID not found. Please log in again.'));
        return;
      }

      await emit.forEach<List<BookingModel>>(
        _bookingTransactionRepository.streamBookings(barberId: barberUid),
        onData: (bookings) {
          if (bookings.isEmpty) {
            return FetchBookingEmpty();
          } else {
            return FetchBookingSuccess(bookings: bookings);
          }
        },
        onError: (error, stackTrace) {
          return FetchBookingFailure('Could not load booking data. Please try again later.');
        },
      );
    } catch (e) {
      emit(FetchBookingFailure('An unexpected error occurred. Please check your connection.'));
    }
  }
   

  Future<void> _onFilterBookingStatus(
    FetchBookingDatasFilteringStatus event,
    Emitter<FetchBookingState> emit,
  ) async {
    emit(FetchBookingLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchBookingFailure('Shop ID not found. Please log in again.'));
        return;
      }

      await emit.forEach<List<BookingModel>>(
        _bookingTransactionRepository.streamBookingFiltering(barberId: barberUid,status: event.status),
        onData: (datas) {

          if (datas.isEmpty) {
            return FetchBookingEmpty();
          } else {
            return FetchBookingSuccess(bookings: datas);
          }
        },
        onError: (error, stackTrace) {
          return FetchBookingFailure('Filtering failed: $error');
        },
      );
    } catch (e) {
      emit(FetchBookingFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  
  Future<void> _onFilterBookingTransaction(
    FetchBookingDatasFilteringTransaction event,
    Emitter<FetchBookingState> emit,
  ) async {
    emit(FetchBookingLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchBookingFailure('Shop ID not found. Please log in again.'));
        return;
      }

      await emit.forEach<List<BookingModel>>(
        _bookingTransactionRepository.streamBookingTransaction(barberId: barberUid,status: event.fillterText),
        onData: (datas) {

          if (datas.isEmpty) {
            return FetchBookingEmpty();
          } else {
            return FetchBookingSuccess(bookings: datas);
          }
        },
        onError: (error, stackTrace) {
          return FetchBookingFailure('Filtering failed: $error');
        },
      );
    } catch (e) {
      emit(FetchBookingFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

 
}

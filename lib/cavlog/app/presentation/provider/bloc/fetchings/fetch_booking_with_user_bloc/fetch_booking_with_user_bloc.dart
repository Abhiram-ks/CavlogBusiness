import 'package:barber_pannel/cavlog/app/data/models/booking_with_user_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_booking_with_user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fetch_booking_with_user_event.dart';
part 'fetch_booking_with_user_state.dart';

class FetchBookingWithBarberBloc extends Bloc<FetchBookingWithUserEvent, FetchBookingWithUserStateBase> {
  final FetchBookingAndUserRepository _repository;
  FetchBookingWithBarberBloc(this._repository) : super(FetchBookingWithUserInitial()) {
  
    on<FetchBookingWithUserRequest>(_onFetchingBookingWithUserRequest);
    on<FetchBookingWithUserFileterRequest>(_onFetchingBookingWithBarberFiltering);
  }

  Future<void> _onFetchingBookingWithUserRequest(
    FetchBookingWithUserRequest event,
    Emitter<FetchBookingWithUserStateBase> emit,
  )async {
    emit(FetchBookingWithUserLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchBookingWithUserFailure('Shop ID not found. Please log in again.'));
        return;
      }

      await emit.forEach<List<BookingWithUserModel>>(
        _repository.streamBookingsWithUser(barberID: barberUid), 
        onData: (booking) {
          if (booking.isEmpty) {
            return FetchBookingWithUserEmpty();
          }else {
            return FetchBookingWithUserLoaded(combo: booking);
          }
        },
        onError: (error, stackTrace) {
          return FetchBookingWithUserFailure('could not load booking data. Please try again leter.');
        },
        );
    } catch (e) {
      emit(FetchBookingWithUserFailure('An unexpected error occurred. Please check your connection. $e'));
    }
  }

  Future<void> _onFetchingBookingWithBarberFiltering(
    FetchBookingWithUserFileterRequest event,
    Emitter<FetchBookingWithUserStateBase> emit,
  )async {
    emit(FetchBookingWithUserLoading());

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      if (barberUid == null) {
        emit(FetchBookingWithUserFailure('Shop ID not found. Please log in again.'));
        return;
      }

         await emit.forEach<List<BookingWithUserModel>>(
       _repository.streamBookingsWithUser(barberID: barberUid),
       onData: (bookings) {
        final filteredBooking = bookings.where((booking) => booking.booking.serviceStatus.toLowerCase().contains(event.filtering.toLowerCase())).toList();

        if (filteredBooking.isEmpty) {
          return FetchBookingWithUserEmpty();
        }else {
          return FetchBookingWithUserLoaded(combo: filteredBooking);
        }
       },
        onError: (error, stackTrace) {
        return FetchBookingWithUserFailure('Filtering failed: $error');
      },
       );

    } catch (e) {
       emit(FetchBookingWithUserFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}

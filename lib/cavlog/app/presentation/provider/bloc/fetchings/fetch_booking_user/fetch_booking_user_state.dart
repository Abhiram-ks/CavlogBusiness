part of 'fetch_booking_user_bloc.dart';


@immutable
abstract class FetchBookingUserState{}

final class FetchBookingUserInitial extends FetchBookingUserState {}
final class FetchBookingUserLoading extends FetchBookingUserState {}
final class FetchBookingUserEmptys extends FetchBookingUserState {}
final class FetchBookingUserLoaded extends FetchBookingUserState {
  final List<BookingModel> combo;
  FetchBookingUserLoaded({required this.combo});
}
final class FetchBookingUserFailure extends FetchBookingUserState {
  final String error;
  FetchBookingUserFailure(this.error);
}
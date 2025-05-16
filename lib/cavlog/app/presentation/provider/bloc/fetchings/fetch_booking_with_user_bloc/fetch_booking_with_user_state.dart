part of 'fetch_booking_with_user_bloc.dart';

@immutable
abstract class FetchBookingWithUserStateBase{}

final class FetchBookingWithUserInitial extends FetchBookingWithUserStateBase {}
final class FetchBookingWithUserLoading extends FetchBookingWithUserStateBase {}
final class FetchBookingWithUserEmpty extends FetchBookingWithUserStateBase {}
final class FetchBookingWithUserLoaded extends FetchBookingWithUserStateBase {
  final List<BookingWithUserModel> combo;

  FetchBookingWithUserLoaded({required this.combo});
}


final class FetchBookingWithUserFailure extends FetchBookingWithUserStateBase {
  final String errorMessage;

  FetchBookingWithUserFailure(this.errorMessage);
}
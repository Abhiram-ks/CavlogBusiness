part of 'fetch_pendings_booking_bloc.dart';

@immutable
abstract class FetchPendingsBookingState {}

final class FetchPendingsBookingInitial extends FetchPendingsBookingState {}
final class FetchPendingsBookingLoading extends FetchPendingsBookingState {}
final class FetchPendingsBookingEmpty   extends FetchPendingsBookingState {}
final class FetchPendingsBookingLoaded  extends FetchPendingsBookingState {
  final List<BookingWithUserModel> combo;
  FetchPendingsBookingLoaded({required this.combo});
}

final class FetchPendingsBookingFailure extends FetchPendingsBookingState {}

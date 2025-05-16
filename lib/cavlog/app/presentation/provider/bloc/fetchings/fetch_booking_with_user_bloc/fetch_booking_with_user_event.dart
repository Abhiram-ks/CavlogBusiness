part of 'fetch_booking_with_user_bloc.dart';


@immutable
abstract class FetchBookingWithUserEvent{}

final class FetchBookingWithUserRequest  extends FetchBookingWithUserEvent{}

final class FetchBookingWithUserFileterRequest extends FetchBookingWithUserEvent{
  final String  filtering;

  FetchBookingWithUserFileterRequest({required this.filtering});
}
part of 'fetch_booking_user_bloc.dart';


@immutable
abstract class FetchBookingUserEvent{}
class FetchBookingUserRequest extends FetchBookingUserEvent{
  final String userId;

  FetchBookingUserRequest({required this.userId});
}
class FetchBookingUserFiltering extends FetchBookingUserEvent{
  final String userId;
  final String filter;

  FetchBookingUserFiltering({required this.filter,required this.userId});
}

part of 'fetch_user_bloc.dart';


@immutable
abstract class FetchUserEvent  {}

final class FetchUserRequest extends FetchUserEvent {
  final String userID;
  FetchUserRequest({required this.userID});
}
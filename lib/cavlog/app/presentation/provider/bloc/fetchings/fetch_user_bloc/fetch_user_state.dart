part of 'fetch_user_bloc.dart';


@immutable
abstract class FetchUserState {}

final class FetchUserInitial extends FetchUserState {}
final class FatchUserLoading extends FetchUserState {}
final class FetchUserLoaded extends FetchUserState {
  final UserModel users;
  final String barberId;
  FetchUserLoaded({required this.users,required this.barberId});
}

final class FetchUserFailure extends FetchUserState {
  final String error;
  FetchUserFailure(this.error);
}  

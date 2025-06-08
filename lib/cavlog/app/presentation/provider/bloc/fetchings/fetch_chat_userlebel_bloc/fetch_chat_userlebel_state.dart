part of 'fetch_chat_userlebel_bloc.dart';


@immutable
abstract class FetchChatUserlebelState {}

final class FetchChatUserlebelInitial extends FetchChatUserlebelState {}
final class FetchChatUserlebelLoading extends FetchChatUserlebelState {}
final class FetchChatUserlebelEmpty extends FetchChatUserlebelState {}
final class FetchChatUserlebelSuccess extends FetchChatUserlebelState {
  final List<UserModel> users;
  final String barberId;

  FetchChatUserlebelSuccess({required this.users, required this.barberId});
}
final class FetchChatUserlebelFailure  extends FetchChatUserlebelState {}

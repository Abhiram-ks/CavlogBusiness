part of 'fetch_comments_bloc.dart';

@immutable
abstract class FetchCommentsEvent {}

final class FetchCommentRequst extends FetchCommentsEvent {
  final String docId;

  FetchCommentRequst({required this.docId});
}
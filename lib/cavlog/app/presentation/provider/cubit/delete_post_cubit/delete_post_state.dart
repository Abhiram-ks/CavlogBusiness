part of 'delete_post_cubit.dart';

abstract class DeletePostState {}

final class DeletePostInitial extends DeletePostState {}
final class DeletePostLoading extends DeletePostState {}
final class DeletePostSuccess extends DeletePostState {}
final class DeletePostFailure extends DeletePostState {}

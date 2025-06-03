part of 'fetch_post_with_barber_bloc.dart';


@immutable
abstract class FetchPostWithBarberState {}
final class FetchPostWithBarberInitial extends FetchPostWithBarberState {}
final class FetchPostWithBarberLoading extends FetchPostWithBarberState {}
final class FetchPostWithBarberEmpty extends FetchPostWithBarberState {}
final class FetchPostWithBarberLoaded extends FetchPostWithBarberState {
  final List<PostWithBarberModel> model;
  final String barberId;

  FetchPostWithBarberLoaded({required this.model,required this.barberId});
}

final class FetchPostWithBarberFailure extends FetchPostWithBarberState {
  final String errorMessage;

  FetchPostWithBarberFailure( this.errorMessage);
}

part of 'fetch_rating_avg_cubit.dart';

abstract class FetchRatingAvgState {}

final class FetchRatingAvgInitial extends FetchRatingAvgState {}
final class FetchRatingAvgLoading extends FetchRatingAvgState {}
final class FetchRatingAvgSuccess extends FetchRatingAvgState {
  final double avg;
  FetchRatingAvgSuccess(this.avg);
}
final class FetchRatingAvgFailure extends FetchRatingAvgState {}

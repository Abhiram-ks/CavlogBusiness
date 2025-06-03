import 'package:barber_pannel/cavlog/app/data/repositories/fetch_ratingandreview_avg_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'fetch_rating_avg_state.dart';

class FetchRatingAvgCubit extends Cubit<FetchRatingAvgState> {
  final RatingServiceUsecase _repo = RatingServiceUsecase();

  FetchRatingAvgCubit() : super(FetchRatingAvgInitial());

  Future<void> avgRatingAndReview() async {
    emit(FetchRatingAvgLoading());

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');

      if (barberUid == null) {
        emit(FetchRatingAvgFailure());
        return;
      }

      final double avg = await _repo.fetchAverageRating(barberUid).first;
      emit(FetchRatingAvgSuccess(avg));
      
    } catch (e) {
      emit(FetchRatingAvgFailure());
    }
  }
}

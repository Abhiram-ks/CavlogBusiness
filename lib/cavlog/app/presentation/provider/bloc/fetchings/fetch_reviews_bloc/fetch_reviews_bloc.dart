import 'package:barber_pannel/cavlog/app/data/models/review_model.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../data/repositories/fetch_reviews_repo.dart';
part 'fetch_reviews_event.dart';
part 'fetch_reviews_state.dart';

class FetchReviewsBloc extends Bloc<FetchReviewsEvent, FetchReviewsState> {
  final FetchReviewsDetailsRepository _repository;
  FetchReviewsBloc(this._repository) : super(FetchReviewsInitial()) {
    on<FetchReviewRequest>(_onFetchReviewRequest);
  }

  Future<void> _onFetchReviewRequest (
    FetchReviewRequest event, Emitter<FetchReviewsState> emit,
  ) async {
    emit(FetchReviewsLoadingState());

    try {
       final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');

      if (barberUid == null) {
        emit(FetchReviewFailureState('Barber not found!'));
        return;
      }
      await emit.forEach<List<ReviewModel>>(
        _repository.streamReviewsWithUser(barberUid), 
        onData: (reviews) {
          if (reviews.isEmpty) {
            return FetchReviewsEmptyState();
          } else {
            return FetchReviewsSuccesState(reviews);
          }
        },
         onError: (_, __) => FetchReviewFailureState('Failed to fetch reviews'),
        );
    } catch (e) {
      emit(FetchReviewFailureState('Error ocuured: $e'));
    }
  }
}

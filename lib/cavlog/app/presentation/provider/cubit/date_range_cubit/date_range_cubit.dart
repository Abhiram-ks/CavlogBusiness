import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/date_range_cubit/date_range_state.dart';
import 'package:bloc/bloc.dart';

class DateRangeCubit extends Cubit<DateRangeState> {
  DateRangeCubit()
      : super(DateRangeState(
          focusedDay: DateTime.now(),
          isStartSelection: true,
        ));

  void onDaySelected(DateTime selectedDay) {
    if (state.isStartSelection) {
      emit(state.copyWith(
        startDate: selectedDay,
        endDate: null,
        isStartSelection: false,
        focusedDay: selectedDay,
      ));
    } else {
      if (state.startDate != null && selectedDay.isBefore(state.startDate!)) {
        emit(state.copyWith(
          startDate: selectedDay,
          endDate: null,
          isStartSelection: false,
          focusedDay: selectedDay,
        ));
      } else {
        emit(state.copyWith(
          endDate: selectedDay,
          isStartSelection: true,
          focusedDay: selectedDay,
        ));
      }
    }
  }

  void reset() {
    emit(DateRangeState(
      focusedDay: DateTime.now(),
      isStartSelection: true,
    ));
  }
}

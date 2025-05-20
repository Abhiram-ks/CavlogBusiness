// date_range_state.dart
class DateRangeState {
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime focusedDay;
  final bool isStartSelection;

  const DateRangeState({
    this.startDate,
    this.endDate,
    required this.focusedDay,
    required this.isStartSelection,
  });

  DateRangeState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    DateTime? focusedDay,
    bool? isStartSelection,
  }) {
    return DateRangeState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      focusedDay: focusedDay ?? this.focusedDay,
      isStartSelection: isStartSelection ?? this.isStartSelection,
    );
  }
}

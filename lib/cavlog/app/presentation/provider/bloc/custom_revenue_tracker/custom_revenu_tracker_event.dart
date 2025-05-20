part of 'custom_revenu_tracker_bloc.dart';


@immutable
abstract class CustomRevenuTrackerEvent {}
final class RequstforTrackingRevenue extends CustomRevenuTrackerEvent{
 final DateTime startTime;
 final DateTime endTime;

 RequstforTrackingRevenue({required this.startTime, required this.endTime});
}
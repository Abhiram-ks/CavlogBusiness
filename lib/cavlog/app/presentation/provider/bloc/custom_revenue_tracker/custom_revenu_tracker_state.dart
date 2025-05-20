part of 'custom_revenu_tracker_bloc.dart';

sealed class CustomRevenuTrackerState {}
final class CustomRevenuTrackerInitial extends CustomRevenuTrackerState {}
final class CustomRevenuTrackerLoading extends CustomRevenuTrackerState {}
final class CustomRevenuTrackerEmptys extends CustomRevenuTrackerState {}
final class CustomRevenuTrackerLoaded extends CustomRevenuTrackerState {
  final double totalEarnings;
  final String workingMinutes;
  final String completedSessions; 
  final List<double> segmentValues;
  final List<String> topServices;
  final List<String> topServicesAmount;
  final List<String> graphLabels;
  final List<double> graphValues;
  final double maxY;
  final double minY; 

  CustomRevenuTrackerLoaded({required this.totalEarnings, required this.workingMinutes, required this.completedSessions,required this.segmentValues, required this.topServices, required this.topServicesAmount, required this.graphValues,required this.graphLabels, required this.maxY, required this.minY});
}
final class CustomRevenuTrackerFailure extends CustomRevenuTrackerState {
  final String errorMessage;

  CustomRevenuTrackerFailure(this.errorMessage);
}

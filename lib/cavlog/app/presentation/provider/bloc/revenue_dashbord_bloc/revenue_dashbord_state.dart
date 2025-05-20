part of 'revenue_dashbord_bloc.dart';

abstract class RevenueDashbordState {}

final class RevenueDashbordInitial extends RevenueDashbordState {}
final class RevenueDashbordLoading extends RevenueDashbordState {}
final class RevenueDashbordEmpty extends RevenueDashbordState {}
final class RevenuDahsbordLoaded extends RevenueDashbordState {
  final double totalEarnings;
  final double percentageGrowth;
  final String workingMinutes;
  final String completedSessions; 
  final List<double> segmentValues;
  final List<String> topServices;
  final List<String> topServicesAmount;
  final List<String> graphLabels;
  final List<double> graphValues;
  final bool isGrowth;
  final double maxY;
  final double minY; 

  RevenuDahsbordLoaded({required this.totalEarnings, required this.percentageGrowth, required this.workingMinutes, required this.completedSessions,required this.segmentValues, required this.topServices, required this.topServicesAmount, required this.graphValues,required this.graphLabels, required this.maxY, required this.minY,required this.isGrowth});

}


final class RevenuDahsbordFailure extends RevenueDashbordState{
  final String errorMessage;

  RevenuDahsbordFailure(this.errorMessage);
}


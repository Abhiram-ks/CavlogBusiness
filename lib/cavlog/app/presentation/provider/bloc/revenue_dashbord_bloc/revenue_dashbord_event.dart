part of 'revenue_dashbord_bloc.dart';

abstract class RevenueDashbordEvent{}
final class LoadRevenueData extends RevenueDashbordEvent{
  final RevenueFilter filter;

  LoadRevenueData({required this.filter});
}

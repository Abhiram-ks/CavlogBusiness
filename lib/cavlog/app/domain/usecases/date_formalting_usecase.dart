
import 'package:flutter/material.dart';
import '../../presentation/provider/cubit/revenue_dashbord_cubit/revenue_dashbord_cubit.dart';

class RevenueDateCalculater {
  static DateTimeRange getDateRange(RevenueFilter filter) {
    final now = DateTime.now();

    switch (filter) {
      case RevenueFilter.today:
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        return DateTimeRange(start: start, end: end);

      case RevenueFilter.weekly:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final end = start.add(const Duration(days: 7));
        return DateTimeRange(start: start, end: end);

      case RevenueFilter.mothely:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 1); 
        return DateTimeRange(start: start, end: end);

      case RevenueFilter.yearly:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year + 1, 1, 1); 
        return DateTimeRange(start: start, end: end);
    }
  }

  static DateTimeRange getPreviousPeriodRange(RevenueFilter filter) {
    final now = DateTime.now();

    switch (filter) {
      case RevenueFilter.today:
        final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
        final end = start.add(const Duration(days: 1));
        return DateTimeRange(start: start, end: end);

      case RevenueFilter.weekly:
        final start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1 + 7)); 
        final end = start.add(const Duration(days: 7));
        return DateTimeRange(start: start, end: end);

      case RevenueFilter.mothely:
        final thisMonthStart = DateTime(now.year, now.month, 1);
        final lastMonthEnd = thisMonthStart.subtract(const Duration(days: 1));
        final start = DateTime(lastMonthEnd.year, lastMonthEnd.month, 1);
        final end = DateTime(lastMonthEnd.year, lastMonthEnd.month + 1, 1);
        return DateTimeRange(start: start, end: end);

      case RevenueFilter.yearly:
        final start = DateTime(now.year - 1, 1, 1);
        final end = DateTime(now.year, 1, 1);
        return DateTimeRange(start: start, end: end);
    }
  }
}
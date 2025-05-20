import 'package:barber_pannel/cavlog/app/data/models/booking_model.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/revenue_dashbord_cubit/revenue_dashbord_cubit.dart';
import 'package:intl/intl.dart';

class RevenueFilteringUsecase {
  List<BookingModel> todayBooking(List<BookingModel> bookings) {
    final todayDateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final todayBookings = bookings.where((bookings) {
      return bookings.slotDate == todayDateStr;
    }).toList();

    return todayBookings;
  }
  
  //It is the algorthem or helper of the top services finding
  Map<String, double> aggregateServiceRevenue(List<BookingModel> bookings) {
    final Map<String, double> serviceRevenue = {};

    for (var booking in bookings) {
      if (booking.serviceStatus.toLowerCase() == 'completed') {
        booking.serviceType.forEach((service, price) {
          serviceRevenue[service] = (serviceRevenue[service] ?? 0.0) + price;
        });
      }
    }

    return serviceRevenue;
  }
 
 ///Fetching the top 5 services in the services list 5th one is the (others) all balanced services calculated and emit the 
 ///last one (others)
  Map<String, dynamic> extractTopServices(List<BookingModel> bookings,
      {int maxCount = 5}) {
    final revenueMap = aggregateServiceRevenue(bookings);

    final sortedServices = revenueMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topServices = sortedServices.take(maxCount).toList();

    final others = sortedServices.skip(maxCount).toList();
    final double othersTotal =
        others.fold(0.0, (sum, entry) => sum + entry.value);

    final List<MapEntry<String, double>> finalServices = [...topServices];
    if (othersTotal > 0) {
      finalServices.add(MapEntry('Others', othersTotal));
    }

    final double totalRevenue =
        finalServices.fold(0.0, (sum, entry) => sum + entry.value);

    final List<double> segmentValues = finalServices.map((e) {
      if (totalRevenue == 0) return 0.0;
      return ((e.value / totalRevenue) * 100);
    }).toList();

    final List<String> topServiceNames =
        finalServices.map((e) => e.key).toList();
    final List<String> topServicesAmount =
        finalServices.map((e) => '₹${e.value.toStringAsFixed(0)}').toList();

    return {
      'segmentValues': segmentValues,
      'topServices': topServiceNames,
      'topServicesAmount': topServicesAmount,
    };
  }

  double calculateEarningsForPeriod(List<BookingModel> bookings) {
    final completedBookings = bookings
        .where((booking) => booking.serviceStatus.toLowerCase() == 'completed')
        .toList();
    final double totalEarnings = completedBookings.fold(
        0.0, (prev, booking) => prev + booking.amountPaid);

    return totalEarnings;
  }
  

  //!calculating earnings algorithem it working on the bookings model depend
  double calculateTodayEarnings(List<BookingModel> bookings) {
    final todayDateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final completedBookings = bookings.where((booking) {
      return booking.serviceStatus.toLowerCase() == 'completed' &&
          booking.slotDate == todayDateStr;
    }).toList();

    final double totalEarnings = completedBookings
        .map((b) => b.amountPaid)
        .fold(0.0, (prev, amount) => prev + amount);

    return totalEarnings;
  }


  int calculateCustomerBookings(List<BookingModel> bookings) {
    return bookings
        .where((b) => b.serviceStatus.toLowerCase() == 'completed')
        .map((b) => b.userId)
        .toSet()
        .length;
  }

  /// This method filters the bookings to get the completed bookings and calculates the total working hours

  String calculateTotalWorkingHours(List<BookingModel> bookings) {
    final completedBookings = bookings
        .where((b) => b.serviceStatus.toLowerCase() == 'completed')
        .toList();

    if (completedBookings.isEmpty) {
      return '0 hrs 0 mins';
    }

    final totalDuration =
        completedBookings.fold<int>(0, (sum, b) => sum + b.duration);
    final int hours = totalDuration ~/ 60;
    final int minutes = totalDuration % 60;

    if (hours == 0 && minutes == 0) {
      return '0 hrs 0 mins';
    } else if (hours == 0) {
      return '$minutes mins';
    } else if (minutes == 0) {
      return '$hours hrs';
    }

    return '$hours hrs $minutes mins';
  }

  /// This method filters the bookings to get the completed bookings and calculates the total number of bookings
  /// and returns the total number of bookings as a string
  String totalBookings(List<BookingModel> booking) {
    final completedBookings = booking
        .where((b) => b.serviceStatus.toLowerCase() == 'completed')
        .toList();
    return completedBookings.length.toString();
  }
}


///Importent module for the line chart algorithems
///Depent on the date range it week be generating so and return the corresponding filters
class RevenueGraphGenerator {
  static Map<String, dynamic> generateGraphData({
    required List<BookingModel> bookings,
    required RevenueFilter filter,
  }) {
    final completedBookings = bookings
        .where((b) => b.serviceStatus.toLowerCase() == 'completed')
        .toList();

    if (completedBookings.isEmpty) {
      return {
        'graphValues': [0.0, 0.0, 0.0, 0.0, 0.0],
        'graphLabels': ['No Data', 'No Data', 'No Data', 'No Data', 'No Data'],
        'maxY': 100.0,
        'minY': 0.0,
      };
    }

    final now = DateTime.now();
    List<String> graphLabels = [];
    List<double> graphValues = [];

    switch (filter) {
      case RevenueFilter.today:
        for (int hour = 0; hour < 24; hour += 3) {
          final startHour = hour;
          final endHour = hour + 2 >= 24 ? 23 : hour + 2;

          final hourLabel = '$startHour:00';
          graphLabels.add(hourLabel);

          final hourlyTotal = completedBookings.where((b) {
            final bookingHour = b.createdAt.hour;
            return b.slotDate == DateFormat('dd-MM-yyyy').format(now) &&
                bookingHour >= startHour &&
                bookingHour <= endHour;
          }).fold(0.0, (sum, b) => sum + b.amountPaid);

          graphValues.add(hourlyTotal);
        }
        break;

      case RevenueFilter.weekly:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

        for (int i = 0; i < 7; i++) {
          final date = startOfWeek.add(Duration(days: i));
          final dateStr = DateFormat('dd-MM-yyyy').format(date);

          graphLabels.add(DateFormat('EEE').format(date));

          final dailyTotal = completedBookings
              .where((b) => b.slotDate == dateStr)
              .fold(0.0, (sum, b) => sum + b.amountPaid);

          graphValues.add(dailyTotal);
        }
        break;

      case RevenueFilter.mothely:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        final weeksInMonth = ((endOfMonth.day - startOfMonth.day) / 7).ceil();

        for (int i = 0; i < weeksInMonth; i++) {
          final weekStart = startOfMonth.add(Duration(days: i * 7));
          final weekEnd = weekStart.add(Duration(days: 6));

          if (weekStart.isAfter(endOfMonth)) break;

          final weekLabel = 'Week ${i + 1}';
          graphLabels.add(weekLabel);

          final weekTotal = completedBookings.where((b) {
            try {
              final bookingDate = DateFormat('dd-MM-yyyy').parse(b.slotDate);
              return bookingDate
                      .isAfter(weekStart.subtract(Duration(days: 1))) &&
                  bookingDate.isBefore(weekEnd.add(Duration(days: 1)));
            } catch (e) {
              return false;
            }
          }).fold(0.0, (sum, b) => sum + b.amountPaid);

          graphValues.add(weekTotal);
        }
        break;

      case RevenueFilter.yearly:
        for (int month = 1; month <= 12; month++) {
          final monthName = DateFormat('MMM').format(DateTime(now.year, month));
          graphLabels.add(monthName);

          final monthTotal = completedBookings.where((b) {
            try {
              final bookingDate = DateFormat('dd-MM-yyyy').parse(b.slotDate);
              return bookingDate.year == now.year && bookingDate.month == month;
            } catch (e) {
              return false;
            }
          }).fold(0.0, (sum, b) => sum + b.amountPaid);

          graphValues.add(monthTotal);
        }
        break;
    }

    final double maxY = graphValues.isEmpty
        ? 100.0
        : (graphValues.reduce((a, b) => a > b ? a : b) * 1.2).ceil().toDouble();

    final double minY = 0.0;

    return {
      'graphValues': graphValues,
      'graphLabels': graphLabels,
      'maxY': maxY,
      'minY': minY,
    };
  }
}

//! calculating growth percentage -> compraing to privious periods
/// It is a future function return the percentage of growth
Future<double> calculateGrowthPercentage(
  List<BookingModel> currentPeriodBookings,
  List<BookingModel> previousPeriodBookings,
) async {
  final revenueUseCase = RevenueFilteringUsecase();

  final double currentEarnings =
      revenueUseCase.calculateEarningsForPeriod(currentPeriodBookings);
  final double previousEarnings =
      revenueUseCase.calculateEarningsForPeriod(previousPeriodBookings);

  double percentageChange = 0.0;
  if (previousEarnings > 0) {
    percentageChange =
        ((currentEarnings - previousEarnings) / previousEarnings) * 100;
  } else if (currentEarnings > 0) {
    percentageChange = 100.0;
  }

  return percentageChange;
}


class RevenueGraphGeneratorCustom {
  static Map<String, dynamic> generateGraphDataFromRangeCustom({
    required List<BookingModel> bookings,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final completedBookings = bookings
        .where((b) => b.serviceStatus.toLowerCase() == 'completed')
        .toList();

    if (completedBookings.isEmpty) {
      final noDataLabels = List.generate(5, (_) => 'No Data');
      final noDataValues = List.generate(5, (_) => 0.0);
      return {
        'graphLabels': noDataLabels,
        'graphValues': noDataValues,
        'maxY': 100.0,
        'minY': 0.0,
      };
    }

    final difference = endDate.difference(startDate).inDays + 1;
    List<String> fullGraphLabels = [];
    List<double> graphValues = [];

    for (int i = 0; i < difference; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);
      final displayLabel = DateFormat('dd MMM').format(currentDate);

      final dailyTotal = completedBookings
          .where((b) => b.slotDate == formattedDate)
          .fold(0.0, (sum, b) => sum + b.amountPaid);

      fullGraphLabels.add(displayLabel);
      graphValues.add(dailyTotal);
    }

    // Smart label selection
    List<String> smartLabels = List.filled(difference, '');
    if (difference <= 5) {
      smartLabels = fullGraphLabels;
    } else {
      final selectedIndexes = <int>{0, difference - 1}; // start & end
      final interval = (difference / 4).floor();
      for (int i = 1; i < 4; i++) {
        selectedIndexes.add(i * interval);
      }
      for (int i = 0; i < difference; i++) {
        smartLabels[i] = selectedIndexes.contains(i) ? fullGraphLabels[i] : '';
      }
    }

    final double maxY = graphValues.isEmpty
        ? 100.0
        : (graphValues.reduce((a, b) => a > b ? a : b) * 1.2).ceilToDouble();

    return {
      'graphLabels': smartLabels,
      'graphValues': graphValues,
      'maxY': maxY,
      'minY': 0.0,
    };
  }
}

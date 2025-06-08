import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTimeRange(DateTime startTime) {
  final String time = DateFormat.jm().format(startTime);
  return time;
}

String formatDate(DateTime dateTime) {
  final dateFormat = DateFormat('dd MMM yyyy');
  return dateFormat.format(dateTime);
}
DateTime convertToDateTime(String dateString) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.parse(dateString);
}


double getTotalServiceAmount(List<Map<String, dynamic>> services) {
  return services.fold(
      0.0, (sum, item) => sum + (item['serviceAmount'] as double));
}

double calculatePlatformFee(double totalAmount) {
  return (totalAmount * 0.01);
}

const double exchangeRateINRtoUSD = 0.0118;
double convertINRtoUSD(double amountInINR) {
  return amountInINR * exchangeRateINRtoUSD;
}

String formatIndianCurrency(double amount) {
  final formatCurrency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );
  return formatCurrency.format(amount);
}

// Converts "dd-MM-yyyy" string to "dd/MM/yyyy - HH:mm" format
/// This is useful for displaying the date in a more readable format and for open ai conversation
String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

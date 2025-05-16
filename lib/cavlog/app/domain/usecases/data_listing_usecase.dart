
import 'package:intl/intl.dart';

String formatTimeRange(DateTime startTime) {
  final String time = DateFormat.jm().format(startTime);
  return time;
}
String formatDate(DateTime dateTime) {
  final dateFormat = DateFormat('dd-MMM-yyyy');
  return dateFormat.format(dateTime);
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
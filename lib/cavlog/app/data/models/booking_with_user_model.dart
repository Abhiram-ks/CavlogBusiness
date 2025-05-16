import 'package:barber_pannel/cavlog/app/data/models/booking_model.dart';
import 'package:barber_pannel/cavlog/app/data/models/user_model.dart';

class BookingWithUserModel {
  final BookingModel booking;
  final UserModel user;

  BookingWithUserModel ({
    required this.booking,
    required this.user,
  });
}
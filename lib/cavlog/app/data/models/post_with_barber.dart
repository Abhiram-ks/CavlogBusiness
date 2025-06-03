import 'package:barber_pannel/cavlog/app/data/models/barber_model.dart';
import 'package:barber_pannel/cavlog/app/data/models/post_model.dart';

class PostWithBarberModel {
  final PostModel post;
  final BarberModel barber;

  PostWithBarberModel({
    required this.post,
    required this.barber,
  });
}
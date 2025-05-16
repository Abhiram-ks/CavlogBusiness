import 'package:barber_pannel/cavlog/app/data/models/barber_model.dart';

class BarberManger {
  static final BarberManger _instance = BarberManger._internal();

  BarberModel? _currentBarber;

  factory BarberManger(){
    return _instance;
  }

  BarberManger._internal();

  BarberModel? get currentBarber => _currentBarber;
  
  BarberModel? getUser() => _currentBarber;


  void setUser(BarberModel barber){
    _currentBarber = barber;
  }

  void clearUser(){
    _currentBarber = null;
  }
}
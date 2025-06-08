
import 'package:barber_pannel/cavlog/app/data/models/barber_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FirebaseFirestore _firestore;
  SplashBloc(this._firestore) : super(SplashInitial()) {
      on<StartSplashEvent>(_onStartSplash);
  }
   Future<void> _onStartSplash(StartSplashEvent event, Emitter<SplashState> emit) async {
      try {
    const duration =  Duration(milliseconds: 1000);
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < duration) {
    for (double progress = 0.0; progress <= 1.0; progress += 0.02) {
        emit(SplashAnimating(progress));
        await Future.delayed(const Duration(milliseconds: 20));
      }
   }
 
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final bool? isLoggedIn = prefs.getBool('isLoggedIn');
     final String? barberUid = prefs.getString('barberUid');

     if (isLoggedIn == true && barberUid != null && barberUid.isNotEmpty) {
       DocumentSnapshot barberDoc = await _firestore.collection('barbers').doc(barberUid).get();

       if (barberDoc.exists) {
         BarberModel barberModel = BarberModel.fromMap(barberUid, barberDoc.data() as Map<String, dynamic>);
         if (!barberModel.isblok) {
           emit(GoToHomePage(barberModel));
         }else {
          emit(GoToLoginPage());
         }
       }else {
         emit(GoToLoginPage());
       }
     }else {
      emit(GoToLoginPage());
     }
   } catch (e) {
     emit(GoToLoginPage());
   } finally {
    emit (SplashAnimationCompleted());
   }
  }
}

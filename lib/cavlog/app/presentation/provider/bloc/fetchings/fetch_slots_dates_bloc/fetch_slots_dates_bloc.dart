import 'dart:async';
import 'package:barber_pannel/cavlog/app/data/models/date_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../data/repositories/fetch_barber_slot_repo.dart';

part 'fetch_slots_dates_event.dart';
part 'fetch_slots_dates_state.dart';

class FetchSlotsDatesBloc extends Bloc<FetchSlotsDatesEvent, FetchSlotsDatesState> {
  final FetchSlotsRepository _fetchSlotsRepository;
  StreamSubscription<List<DateModel>>? _slotSubscription;

  FetchSlotsDatesBloc(this._fetchSlotsRepository) : super(FetchSlotsDatesInitial()) {
    on<FetchSlotsDateRequest>(_onFetchSlotsDatesRequest);
  }

Future<void> _onFetchSlotsDatesRequest(
   FetchSlotsDateRequest event, Emitter<FetchSlotsDatesState> emit) async {
   emit(FetchSlotsDateLoading());
   try {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final String? barberUid = prefs.getString('barberUid');

     if (barberUid == null) {
       emit(FetchSlotsDateFailure('Barber UID not found'));
       return;
     }

     await _fetchSlotsRepository.streamDates(barberUid).forEach((dates) {
       emit(FetchSlotsDatesSuccess(dates));
     });
   } catch (e) {
     emit(FetchSlotsDateFailure('An error occurred'));
   }
 }


  @override
  Future<void> close() {
    _slotSubscription?.cancel();
    return super.close();
  }
}

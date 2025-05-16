import 'package:barber_pannel/cavlog/app/data/models/wallet_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../data/repositories/fetch_barber_wallet_repo.dart';

part 'fetch_wallet_event.dart';
part 'fetch_wallet_state.dart';

class FetchWalletBloc extends Bloc<FetchWalletEvent, FetchWalletState> {
  final FetchBarberWalletRepository walletRepository;

  FetchWalletBloc(this.walletRepository) : super(FetchWalletInitial()) {
    on<FetchWalletEventRequest>(_onFetchWalletEventRequest);
  }

  Future<void> _onFetchWalletEventRequest(
    FetchWalletEventRequest event,
    Emitter<FetchWalletState> emit,
  ) async {
    emit(FetchWalletLoading());
    try {
       final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');

      if (barberUid == null) {
        emit(FetchWlletFilure('Barber ID not found. Please log in again.'));
        return;
      }

      await emit.forEach<BarberWalletModel>(
        walletRepository.fetchWalletData(barberUid),
        onData: (walletModel) {
          return FetchWalletLoaded(walletModel);
        },
        onError: (error, stackTrace) {
          return FetchWlletFilure('Could not load wallet data. Please try again later.');
        },
      );
    } catch (e) {
      emit(FetchWlletFilure('An unexpected error occurred. Please check your connection.'));
    }         
  }
}

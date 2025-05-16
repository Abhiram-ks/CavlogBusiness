part of 'fetch_wallet_bloc.dart';


@immutable
abstract class FetchWalletState{}

final class FetchWalletInitial extends FetchWalletState {}
final class FetchWalletLoading extends FetchWalletState {}
final class FetchWalletLoaded extends  FetchWalletState {
    final BarberWalletModel walletModel;

    FetchWalletLoaded(this.walletModel);
}

final class FetchWlletFilure extends FetchWalletState {
 final String errorMessage;
 FetchWlletFilure(this.errorMessage);
}


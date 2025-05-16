
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/wallet_widget/wallet_balance_widget.dart' show walletBalanceWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetchings/fetch_wallet_bloc/fetch_wallet_bloc.dart';

class WalletOverviewCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const WalletOverviewCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenWidth * 0.3,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            ConstantWidgets.hight10(context),
            BlocBuilder<FetchWalletBloc, FetchWalletState>(
              builder: (context, state) {
                if (state is FetchWalletLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: walletBalanceWidget(
                      iconColor: AppPalette.greyClr,
                      context: context,
                      balance: '₹ 0.00',
                      balanceColor: AppPalette.greyClr,
                    ),
                  );
                } else if(state is FetchWalletLoaded) {
                  final walletModel = state.walletModel;
                  final balance = walletModel.lifetimeAmount < 2000;

                  return walletBalanceWidget(
                    iconColor: balance
                        ? AppPalette.redClr
                        : AppPalette.orengeClr,
                    context: context,
                    balance: '₹ ${walletModel.lifetimeAmount.toStringAsFixed(2)}',
                    balanceColor: balance
                        ? AppPalette.redClr
                        : AppPalette.greenClr,
                  );
                  
                }
                return walletBalanceWidget(
                    iconColor: AppPalette.orengeClr,
                    context: context,
                    balance: '₹ 0.00',
                    balanceColor: AppPalette.blackClr);
              },
            ),
            ConstantWidgets.hight10(context),
          ],
        ),
      ),
    );
  }
}

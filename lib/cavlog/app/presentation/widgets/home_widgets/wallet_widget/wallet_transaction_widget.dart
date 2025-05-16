
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/wallet_widget/wallet_filter_buttons_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/wallet_widget/wallet_transaction_builder.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/constant/constant.dart';

class WalletTransctionWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const WalletTransctionWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: SizedBox(
            height: screenHeight * 0.04,
            child: Row(
              children: [
                WalletFilterButton(
                  label: 'All Transfers',
                  icon: Icons.swap_horiz,
                  colors: AppPalette.blackClr,
                  onTap: () => context
                      .read<FetchBookingBloc>()
                      .add(FetchBookingDatsRequest()),
                ),
                VerticalDivider(color: AppPalette.hintClr),
                WalletFilterButton(
                  label: 'Credited',
                  icon: Icons.arrow_upward_rounded,
                  colors: AppPalette.greenClr,
                  onTap: () => context.read<FetchBookingBloc>().add(
                      FetchBookingDatasFilteringTransaction(
                          fillterText: 'debited')),
                ),
                VerticalDivider(color: AppPalette.hintClr),
                WalletFilterButton(
                    label: 'Debited',
                    colors: AppPalette.redClr,
                    icon: Icons.arrow_downward_rounded,
                    onTap: () => context.read<FetchBookingBloc>().add(
                        FetchBookingDatasFilteringTransaction(
                            fillterText: 'credited'))),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight20(context),
        Expanded( child: walletTransactionWidgetBuilder(context, screenHeight, screenWidth))
      ],
    );
  }
}

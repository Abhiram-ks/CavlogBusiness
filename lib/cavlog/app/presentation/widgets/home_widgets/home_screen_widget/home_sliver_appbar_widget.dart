
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetchbarber/fetch_barber_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/profile_widgets/profile_helper_widget/profile_tabbar_widget.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/routes/routes.dart';
import '../../../screens/pages/home/home_screen.dart';

class HomeScreenSliverAppBar extends StatelessWidget {
  const HomeScreenSliverAppBar({
    super.key,
    required this.widget,
  });

  final HomePageCustomScrollViewWidget widget;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppPalette.blackClr,
      expandedHeight: widget.screenHeight * 0.13,
      pinned: true,
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        bool isCollapsed = constraints.biggest.height <=
            kToolbarHeight + MediaQuery.of(context).padding.top;
        return FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          title: isCollapsed
              ? Text(
                  'C Λ V L O G',
                  style: TextStyle(color: AppPalette.whiteClr),
                )
              : Text(''),
          background: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.04),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: BlocBuilder<FetchBarberBloc, FetchBarberState>(
                    builder: (context, state) {
                      if (state is FetchBarbeLoading) {
                        return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileviewWidget(
                            widget.screenWidth,
                            context,
                            Icons.location_on,
                            'Loading...',
                            AppPalette.redClr,
                          ),
                          ConstantWidgets.hight10(context),
                          Text(
                            'Loading...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppPalette.whiteClr,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                      } else if (state is FetchBarberLoaded) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileviewWidget(
                              widget.screenWidth,
                              context,
                              Icons.location_on,
                              state.barber.address,
                              AppPalette.redClr,
                            ),
                            ConstantWidgets.hight10(context),
                            Text(
                              state.barber.ventureName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color:AppPalette.whiteClr,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileviewWidget(
                            widget.screenWidth,
                            context,
                            Icons.location_on,
                            'Location not found.',
                            AppPalette.redClr,
                          ),
                          ConstantWidgets.hight10(context),
                          Text(
                            'Details not found.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppPalette.whiteClr,
                        ),
                        icon: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppPalette.blackClr,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.walletScreen);
                        },
                      ),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppPalette.whiteClr,
                        ),
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.notifications_active_rounded,
                              color: AppPalette.blackClr,
                            ),
                            BlocBuilder<FetchBookingBloc, FetchBookingState>(
                              builder: (context, state) {
                                if (state is FetchBookingLoading) {
                                  return Positioned(
                                    right: -4,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: AppPalette.redClr,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                    ),
                                  );
                                } else if (state is FetchBookingSuccess) {
                                  final bookingCount = state.bookings.length;
                                  return Positioned(
                                    right: -4,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: AppPalette.redClr,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Center(
                                        child: Text(
                                          bookingCount.toString(),
                                          style: const TextStyle(
                                            color: AppPalette.whiteClr,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.notificationScreen);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

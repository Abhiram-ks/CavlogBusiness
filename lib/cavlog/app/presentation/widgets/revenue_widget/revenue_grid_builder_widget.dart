import 'package:barber_pannel/cavlog/app/domain/usecases/data_listing_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/pages/revenue/revenue_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/routes.dart';
import '../../../domain/usecases/revenue_filtering_usecase.dart';
import 'revenue_cards_custom_widget.dart';

class RevenuePortionGridWidget extends StatelessWidget {
  const RevenuePortionGridWidget({
    super.key,
    required this.widget,
  });

  final RevenueScreenBodyWidget widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.screenHeight * 0.9,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        children: [
          InkWell(
            onTap: () =>  Navigator.pushNamed(context, AppRoutes.walletScreen),
            child: BlocBuilder<FetchWalletBloc, FetchWalletState>(
              builder: (context, state) {
                String totalEarnings = '₹ 0';
                if (state is FetchWalletLoading) {
                  totalEarnings = 'Loading...';
                } else if (state is FetchWalletLoaded) {
                  final double earnings =  state.walletModel.lifetimeAmount;
                  totalEarnings = formatIndianCurrency(earnings);
                } else if (state is FetchWlletFilure) {
                  totalEarnings = 'Error: Try Again';
                }
                return RevenueDetailsContainer(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 30, 104, 32),
                      Color.fromARGB(255, 184, 255, 186),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  title: 'Total Revenu',
                  description: 'A clear snapshot of your earnings.',
                  icon: Icons.currency_rupee_sharp,
                  salesText: totalEarnings,
                  iconColor: const Color.fromARGB(255, 160, 196, 139),
                );
              },
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.walletScreen),
            child: BlocBuilder<FetchBookingBloc, FetchBookingState>(
              builder: (context, state) {
                String todayEarnings = '₹ 0';
                if (state is FetchBookingLoading) {
                  todayEarnings = 'Loading...';
                } else if (state is FetchBookingEmpty) {
                  todayEarnings = 'No bookings';
                } else if (state is FetchBookingSuccess) {
                  final double earnings = RevenueFilteringUsecase()
                      .calculateTodayEarnings(state.bookings);
                  if (earnings == 0) {
                    todayEarnings = 'No bookings';
                  } else {
                    todayEarnings = formatIndianCurrency(earnings);
                  }
                } else if (state is FetchBookingFailure) {
                  todayEarnings = 'Error: Try Again';
                }
                return RevenueDetailsContainer(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 14, 72, 119),
                      Color.fromARGB(255, 160, 212, 255)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  title: 'Today’s Earnings',
                  description:
                      'A focused glimpse of your daily hustle.',
                  icon: Icons.shopping_basket,
                  salesText: todayEarnings,
                  iconColor: const Color.fromARGB(255, 118, 171, 215),
                );
              },
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(  context, AppRoutes.serviceManageScreen),
            child: BlocBuilder<FetchBarberServiceBloc,FetchBarberServiceState>(
              builder: (context, state) {
                String serviceCount = '0';
                if (state is FetchBarberServiceLoading) {
                  serviceCount = 'Loading...';
                } else if (state is FetchBarberServiceSuccess) {
                  serviceCount = state.services.length.toString();
                } else if (state is FetchBarberServiceEmpty) {
                  serviceCount = 'No services found';
                } else if (state is FetchBarberServiceError) {
                  serviceCount = 'Error: Try Again';
                }
                return RevenueDetailsContainer(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.orange,
                      Color.fromARGB(255, 255, 220, 164)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  title: 'Total Services',
                  description:
                      "The total count of every service you’ve provided",
                  icon: CupertinoIcons.wrench_fill,
                  salesText: serviceCount,
                  iconColor: const Color.fromARGB(255, 255, 225, 181),
                );
              },
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.bookingScreen),
            child: BlocBuilder<FetchBookingBloc, FetchBookingState>(
              builder: (context, state) {
                String customerCount = '0';
                if (state is FetchBookingLoading) {
                  customerCount = 'Loading...';
                } else if (state is FetchBookingSuccess) {
                  final int uniqueCustomers = RevenueFilteringUsecase()
                      .calculateCustomerBookings(state.bookings);
                  if (uniqueCustomers == 0) {
                    customerCount = 'No customers';
                  } else {
                    customerCount = uniqueCustomers.toString();
                  }
                } else if (state is FetchBookingEmpty) {
                  customerCount = 'No customers found';
                } else if (state is FetchBookingFailure) {
                  customerCount = 'Error: Try Again';
                }
                return RevenueDetailsContainer(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.purple,
                      Color.fromARGB(255, 245, 186, 255),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  title: 'Total Customers',
                  description:
                      'The clients who’ve chosen you as their go-to barber',
                  icon: Icons.people,
                  salesText: customerCount,
                  iconColor: const Color.fromARGB(255, 248, 181, 255),
                );
              },
            ),
          ),
          InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.bookingScreen),
            child: BlocBuilder<FetchBookingBloc, FetchBookingState>(
              builder: (context, state) {
                String workLegacy = '0hrs 0mins';
                if (state is FetchBookingLoading) {
                  workLegacy = 'Loading...';
                } else if (state is FetchBookingSuccess) {
                  workLegacy = RevenueFilteringUsecase().calculateTotalWorkingHours(state.bookings);
                } else if (state is FetchBookingEmpty) {
                  workLegacy = 'No hours recorded';
                } else if (state is FetchBookingFailure) {
                  workLegacy = 'Error: Try Again';
                }
                return RevenueDetailsContainer(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.red,
                      Color.fromARGB(255, 255, 181, 181),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  title: 'Work Legacy',
                  description:
                      "The accumulated hours of your craft, reflecting a lifetime of skill and passion.",
                  icon: CupertinoIcons.timer_fill,
                  salesText: workLegacy,
                  iconColor: const Color.fromARGB(255, 255, 181, 181),
                );
              },
            ),
          ),
          InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.bookingScreen),
            child: BlocBuilder<FetchBookingBloc, FetchBookingState>(
              builder: (context, state) {
              String totalBookings = '0';
              if (state is FetchBookingLoading) {
                totalBookings = 'Loading...';
              } else if (state is FetchBookingSuccess) {
                final String bookingsCount = RevenueFilteringUsecase().totalBookings(state.bookings);
                if(bookingsCount.isEmpty){
                  totalBookings = 'No bookings';
                } else {
                  totalBookings = bookingsCount;
                }
              } else if (state is FetchBookingEmpty) {
                totalBookings = 'No bookings';
              }else if (state is FetchBookingFailure) {
                totalBookings = 'Error: Try Again';
              }
                return RevenueDetailsContainer(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 60, 39, 176),
                      Color.fromARGB(255, 192, 186, 255),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  title: 'Total Bookings',
                  description:
                      'Every booking is a step towards building your success.',
                  icon: Icons.book,
                  salesText: totalBookings,
                  iconColor: const Color.fromARGB(255, 187, 181, 255),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

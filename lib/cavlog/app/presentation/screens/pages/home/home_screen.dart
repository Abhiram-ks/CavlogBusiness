import 'package:barber_pannel/cavlog/app/data/repositories/fetch_barberdata_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_booking_with_user_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_pending_bookings_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_users_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_pendings_bloc/fetch_pendings_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetchbarber/fetch_barber_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/home_screen_widget/home_custom_scrolable_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../data/repositories/fetch_banner_repo.dart';
import '../../../../data/repositories/fetch_booking_transaction_repo.dart';
import '../../../provider/bloc/fetchings/fetch_banners_bloc/fetch_banners_bloc.dart';
import '../../../provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) {
          final fetchUserRepo = FetchUserRepositoryImpl();
          final serviceRepo   = UserServices(fetchUserRepo);
          final repository    = FetchPendingBookingsRepositoryImpl(serviceRepo);

          return FetchPendingsBookingBloc(repository);
        }),
        BlocProvider(create: (_) =>FetchBookingBloc(FetchBookingRepositoryImpl())),
        BlocProvider(create: (_) =>FetchBarberBloc(FetchBarberRepositoryImpl())),
        BlocProvider(create: (_) =>FetchBannersBloc(FetchBannerRepositoryImpl())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
              color: AppPalette.blackClr,
              child: SafeArea(
             child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: HomePageCustomScrollViewWidget(
              screenHeight: screenHeight,
              screenWidth: screenWidth)
            )
          ));
        },
      ),
    );
  }
}


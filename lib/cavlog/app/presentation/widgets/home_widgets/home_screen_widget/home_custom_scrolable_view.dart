
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_pendings_bloc/fetch_pendings_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_banners_bloc/fetch_banners_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetchbarber/fetch_barber_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/home_screen_widget/home_sliver_appbar_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/home_screen_widget/home_widget_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageCustomScrollViewWidget extends StatefulWidget {
  const HomePageCustomScrollViewWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  State<HomePageCustomScrollViewWidget> createState() =>
      _HomePageCustomScrollViewWidgetState();
}

class _HomePageCustomScrollViewWidgetState
    extends State<HomePageCustomScrollViewWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBookingBloc>().add(FetchBookingDatasFilteringStatus(status: 'Pending'));
      context.read<FetchBannersBloc>().add(FetchBannersRequest());
      context.read<FetchBarberBloc>().add(FetchCurrentBarber());
      context.read<FetchPendingsBookingBloc>().add(FetchPendingsBookingRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        HomeScreenSliverAppBar(widget: widget),
        SliverToBoxAdapter(
            child: HomeScreenBodyWIdget(
          screenHeight: widget.screenHeight,
          screenWidth: widget.screenWidth,
        )),
      ],
    );
  }
}

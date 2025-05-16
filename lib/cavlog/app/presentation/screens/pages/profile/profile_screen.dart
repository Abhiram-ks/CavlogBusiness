import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_posts_bloc/fetch_posts_bloc.dart';
import 'package:barber_pannel/core/common/common_loading_widget.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/fetch_barber_post_repo.dart';
import '../../../../data/repositories/fetch_servicedata_repo.dart';
import '../../../provider/bloc/fetchings/fetch_service_bloc/fetch_service_bloc.dart';
import '../../../provider/bloc/fetchings/fetchbarber/fetch_barber_bloc.dart';
import '../../../widgets/profile_widgets/profile_helper_widget/profile_scrollview.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>FetchServiceBloc(ServiceRepositoryImpl())..add(FetchServiceRequst())),
        BlocProvider(create: (_) => FetchPostsBloc(FetchBarberPostRepositoryImpl())),
      ],
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<FetchBarberBloc>().add(FetchCurrentBarber());
            context.read<FetchPostsBloc>().add(FetchPostRequest());
          });

          return LayoutBuilder(builder: (context, constraints) {
            double screenHeight = constraints.maxHeight;
            double screenWidth = constraints.maxWidth;

            return ColoredBox(
              color: AppPalette.blackClr,
              child: SafeArea(
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    body: BlocBuilder<FetchBarberBloc, FetchBarberState>(
                      builder: (context, state) {
                        if (state is FetchBarbeLoading ||
                            state is FetchBarberError) {
                          return LoadingScreen(
                              screenHeight: screenHeight, screenWidth: screenWidth);
                        }
                        if (state is FetchBarberLoaded) {
                          return ProfileScrollView(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            barber: state.barber,
                          );
                        }
                        return LoadingScreen(
                            screenHeight: screenHeight, screenWidth: screenWidth);
                      },
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

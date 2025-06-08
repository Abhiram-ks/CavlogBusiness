import 'package:barber_pannel/cavlog/app/data/models/barber_model.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_posts_bloc/fetch_posts_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/help_screen/help_screen.dart';
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
                        if (state is FetchBarberLoaded) {
                          return ProfileScrollView(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            barber: state.barber,
                          );
                        }
                        return  ProfileScrollView(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            barber: BarberModel(uid: '', barberName: "BarberName Loading...", ventureName: 'VentureName Loading...', phoneNumber: 'Loading...', address: 'Address Loading...', email: 'example@gamil.com', isVerified: true, isblok: false),
                          );
                      },
                    ),
                    floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
                  },
                  backgroundColor: AppPalette.orengeClr,
                  child: Icon(
                    Icons.smart_toy_sharp,
                    color: AppPalette.whiteClr,
                  ),
                )
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

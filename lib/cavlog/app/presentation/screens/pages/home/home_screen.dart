import 'package:barber_pannel/cavlog/app/data/repositories/fetch_barberdata_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetchbarber/fetch_barber_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/common/common_imageshow.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../../core/utils/image/app_images.dart';
import '../../../../data/repositories/fetch_banner_repo.dart';
import '../../../../data/repositories/fetch_booking_transaction_repo.dart';
import '../../../provider/bloc/fetch_banners_bloc/fetch_banners_bloc.dart';
import '../../../provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import '../../../provider/cubit/cubit/image_slider_cubit.dart';
import '../../../widgets/home_widgets/home_screen_widget/home_sliver_appbar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchBookingBloc(FetchBookingRepositoryImpl())),
        BlocProvider(create: (context) => FetchBarberBloc(FetchBarberRepositoryImpl())),
        BlocProvider( create: (_) => FetchBannersBloc(FetchBannerRepositoryImpl())),
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
                          screenWidth: screenWidth))));
        },
      ),
    );
  }
}

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
      context.read<FetchBookingBloc>().add(FetchBookingDatasFilteringStatus(status: 'pending'));
      context.read<FetchBannersBloc>().add(FetchBannersRequest());

      context.read<FetchBarberBloc>().add(FetchCurrentBarber());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        HomeScreenSliverAppBar(widget: widget),
        SliverToBoxAdapter(
       child:    
       HomeScreenBodyWIdget(screenHeight: widget.screenHeight,screenWidth: widget.screenWidth,)
            ),
      ],
    );
  }
}


class HomeScreenBodyWIdget extends StatelessWidget {
    final double screenHeight;
  final double screenWidth;
  const HomeScreenBodyWIdget({super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
     child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           BlocBuilder<FetchBannersBloc, FetchBannersState>(
            builder: (context, state) {
              if (state is FetchBannersLoaded) {
                return ImageScolingWidget(
                    show: false,
                    imageList: state.banners.imageUrls,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth);
              } else if (state is FetchBannersLoading) {
                Shimmer.fromColors(
                  baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                  highlightColor: AppPalette.whiteClr,
                  child: ImageScolingWidget(
                      imageList: [AppImages.loginImageAbove, AppImages.loginImageAbove],
                      show: true,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth),
                );
              }
              return ConstantWidgets.hight10(context);
            },
          ),
          ConstantWidgets.hight10(context),
        ],
     )
    );
  }
}



class ImageScolingWidget extends StatelessWidget {
  const ImageScolingWidget({
    super.key,
    required this.imageList,
    required this.screenHeight,
    required this.screenWidth,
    required this.show,
  });

  final List<String> imageList;
  final double screenHeight;
  final double screenWidth;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageSliderCubit(imageList: imageList),
      child: Builder(
        builder: (context) {
          final cubit = context.read<ImageSliderCubit>();
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: SizedBox(
              height: screenHeight * 0.29,
              width: screenWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: cubit.pageController,
                    itemCount: imageList.length,
                    onPageChanged: cubit.updatePage,
                    itemBuilder: (context, index) {
                      return (imageList[index].startsWith('http'))
                          ? imageshow(
                              imageUrl: imageList[index],
                              imageAsset: imageList[index])
                          : Image.asset(
                              AppImages.loginImageAbove,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            );
                    },
                  ),
                  
                   Positioned(
                    bottom: 8,
                    child: BlocBuilder<ImageSliderCubit, int>(
                      builder: (context, state) {
                        return SmoothPageIndicator(
                          controller: cubit.pageController,
                          count: imageList.length,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: AppPalette.whiteClr,
                            dotColor: AppPalette.greyClr,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

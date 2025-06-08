import  'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_banners_bloc/fetch_banners_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/home_screen_widget/home_image_scorlable_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/home_screen_widget/home_timeline_builder_pendings.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart' show ConstantWidgets;
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/themes/colors.dart';

class HomeScreenBodyWIdget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const HomeScreenBodyWIdget(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
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
                    imageList: [AppImages.emptyImage, AppImages.emptyImage],
                    show: true,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth),
              );
            }
            return ConstantWidgets.hight10(context);
          },
        ),
        ConstantWidgets.hight30(context),
        Padding(
          padding: EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth * .15 : screenWidth * .04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Track Booking Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ConstantWidgets.hight10(context),
              TimelineBuilderPendings(),
            ],
          ),
        ),
      ],
    ));
  }
}

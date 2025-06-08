
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/image_slider_cubit/image_slider_cubit.dart';
import 'package:barber_pannel/core/common/common_imageshow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/image/app_images.dart';

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


import 'package:barber_pannel/cavlog/app/presentation/widgets/profile_widgets/profile_helper_widget/profile_tabbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/common/common_imageshow.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../../core/utils/image/app_images.dart';

SizedBox paymentSectionBarberData(
    {required BuildContext context,
    required String imageURl,
    required String shopName,
    required String shopAddress,
    required String email,
    required double screenWidth,
    required double screenHeight}) {
  return SizedBox(
    height: screenHeight * 0.12,
    child: Row(
      children: [
        ConstantWidgets.width20(context),
        Flexible(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: (imageURl.startsWith('http'))
                ? imageshow(
                    imageUrl: imageURl, imageAsset: AppImages.emptyImage)
                : Image.asset(
                    AppImages.emptyImage,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
          ),
        ),
        ConstantWidgets.width20(context),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                shopName,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.whiteClr),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              profileviewWidget(
                screenWidth,
                context,
                Icons.location_on,
                shopAddress,
                AppPalette.redClr,
                maxLines: 2,
                textColor: AppPalette.hintClr,
              ),
              Text(
                email,
                style: GoogleFonts.plusJakartaSans(color: AppPalette.whiteClr),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              ConstantWidgets.width40(context),
            ],
          ),
        ),
        ConstantWidgets.width20(context),
      ],
    ),
  );
}

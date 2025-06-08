import 'dart:io';
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/service_states_handle.dart';
import 'package:barber_pannel/core/common/common_imageshow.dart';
import 'package:barber_pannel/core/common/snackbar_helper.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';
import '../../../../../core/common/common_action_button.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../data/models/barber_model.dart';
import '../../provider/bloc/image_picker/image_picker_bloc.dart';
import '../../provider/bloc/modifications/upload_service_data_bloc/upload_service_data_bloc.dart';
import '../../provider/cubit/gender_cubit/gender_option_cubit.dart';

class UploadingServiceDatas extends StatelessWidget {
  const UploadingServiceDatas({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.barber,
  });

  final double screenWidth;
  final BarberModel barber;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gender = getGenderOptionFromString(barber.gender);
      context.read<GenderOptionCubit>().selectGenderOption(gender);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantWidgets.hight30(context),
        InkWell(
          onTap: () {
            context.read<ImagePickerBloc>().add(PickImageAction());
          },
          child: DottedBorder(
            color: AppPalette.greyClr,
            strokeWidth: 1,
            dashPattern: [4, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.23,
              child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
                builder: (context, state) {
                  if (state is ImagePickerInitial) {
                    if (barber.detailImage != null &&
                        barber.detailImage!.isNotEmpty &&
                        barber.detailImage!.startsWith('http')) {
                      return SizedBox(
                        width: screenWidth * 0.89,
                        height: screenHeight * 0.22,
                        child: imageshow(
                          imageUrl: barber.detailImage!,
                          imageAsset: AppImages.loginImageAbove,
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: screenWidth * 0.89,
                        height: screenHeight * 0.22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.cloud_upload,
                              size: 35,
                              color: AppPalette.buttonClr,
                            ),
                            const Text('Upload an Image'),
                          ],
                        ),
                      );
                    }
                  } else if (state is ImagePickerLoading) {
                    return const CupertinoActivityIndicator(radius: 16.0);
                  } else if (state is ImagePickerSuccess) {
                    return buildImagePreview(state: state,screenWidth: screenWidth*0.86,screenHeight: screenHeight*41,radius: 12);
                  } else if (state is ImagePickerError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.photo,
                          size: 35,
                          color: AppPalette.redClr,
                        ),
                        Text(state.errorMessage)
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.cloud_upload,
                        size: 35,
                        color: AppPalette.buttonClr,
                      ),
                      Text('Upload an Images')
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        ConstantWidgets.hight20(context),
        const Text(
          "Select Gender",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ConstantWidgets.hight10(context),
        BlocBuilder<GenderOptionCubit, GenderOption>(
          builder: (context, selectedGender) {
            return Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10,
              children: GenderOption.values.map((gender) {
                Color activeColor;
                String label;

                switch (gender) {
                  case GenderOption.male:
                    activeColor = AppPalette.blueClr;
                    label = "Male";
                    break;
                  case GenderOption.female:
                    activeColor = Colors.pink;
                    label = "Female";
                    break;
                  case GenderOption.unisex:
                    activeColor = AppPalette.orengeClr;
                    label = "Unisex";
                    break;
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<GenderOption>(
                      value: gender,
                      groupValue: selectedGender,
                      activeColor: activeColor,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<GenderOptionCubit>()
                              .selectGenderOption(value);
                        }
                      },
                    ),
                    Text(label),
                  ],
                );
              }).toList(),
            );
          },
        ),
        ConstantWidgets.hight20(context),
        BlocListener<UploadServiceDataBloc, UploadServiceDataState>(
          listener: (context, state) {
            handleServiceWidgetState(context, state);
          },
          child: ActionButton(
              screenWidth: screenWidth,
              onTap: () {
                final imageState = context.read<ImagePickerBloc>().state;
                final genderState = context.read<GenderOptionCubit>().state;

                if (imageState is ImagePickerSuccess) {
                  context.read<UploadServiceDataBloc>().add(
                      UploadServiceDataRequest(
                          imagePath: imageState.imagePath ?? '',
                          imageBytes: kIsWeb ? imageState.imageBytes : null,
                          genderOption: genderState));
                } else {
                  CustomeSnackBar.show(
                      context: context,
                      title: 'Image Not Found!',
                      description: 'Unable to proceed. Image not found. Please make sure an image is selected.',
                      titleClr: AppPalette.redClr);
                }
              },
              label: 'Upload',
              screenHight: screenHeight),
        )
      ],
    );
  }
}

GenderOption getGenderOptionFromString(String? gender) {
  switch (gender?.toLowerCase()) {
    case 'male':
      return GenderOption.male;
    case 'female':
      return GenderOption.female;
    case 'unisex':
      return GenderOption.unisex;
    default:
      return GenderOption.unisex;
  }
}


Widget buildImagePreview({required ImagePickerSuccess state,required double screenWidth,required double screenHeight,required int radius}) {
  final imageWidget = () {
    if (kIsWeb && state.imageBytes != null) {
      return Image.memory(
        state.imageBytes!,
        width: screenWidth,
        height: screenHeight,
        fit: screenWidth > 600 ? BoxFit.contain : BoxFit.cover,
      );
    } else if (state.imagePath != null && state.imagePath!.startsWith('http')) {
      return Image.network(
        state.imagePath!,
        width: screenWidth ,
        height: screenHeight,
        fit: BoxFit.cover,
      );
    } else if (state.imagePath != null && state.imagePath!.isNotEmpty) {
      return Image.file(
        File(state.imagePath!),
        width: screenWidth,
        height: screenHeight,
        fit: BoxFit.cover,
      );
    } else {
      return const Text("No image selected");
    }
  }();

  return PinchToZoomScrollableWidget(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageWidget,
    ),
  );
}

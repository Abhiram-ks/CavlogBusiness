
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/service_widget_upload_datas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../provider/bloc/image_picker/image_picker_bloc.dart';

BlocBuilder<ImagePickerBloc, ImagePickerState> imagePIckerChating() {
  return BlocBuilder<ImagePickerBloc, ImagePickerState>(
    builder: (context, state) {
      if (state is ImagePickerLoading) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              padding: const EdgeInsets.all(4),
              child: CircularProgressIndicator(
                color: AppPalette.buttonClr,
              )),
        );
      } else if (state is ImagePickerSuccess) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                 buildImagePreview(state: state,screenWidth:80,screenHeight: 80,radius: 12),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      context.read<ImagePickerBloc>().add(ClearImageAction());
                    },
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (state is ImagePickerError) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        color: AppPalette.redClr),
                      Text('Error')
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      context.read<ImagePickerBloc>().add(ClearImageAction());
                    },
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox();
    },
  );
}

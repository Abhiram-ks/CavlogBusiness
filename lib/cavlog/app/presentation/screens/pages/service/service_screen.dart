import 'package:barber_pannel/cavlog/app/data/repositories/image_picker_repo.dart';
import 'package:barber_pannel/cavlog/app/domain/usecases/imageuploadon_cloud_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/image_picker/image_picker_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/modifications/upload_service_data_bloc/upload_service_data_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/current_service_cubit/current_service_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/fetch_rating_avg_cubit/fetch_rating_avg_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/service_pageone/service_pageone_body.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/service_pageone/service_view_detail_card.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/service_widget_upload_datas.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/cloudinary/cloudinary_service.dart';
import '../../../../data/datasources/firestore_barber_service.dart';
import '../../../../domain/usecases/image_picker_usecase.dart';
import '../../../provider/cubit/gender_cubit/gender_option_cubit.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ServicePageCubit()),
        BlocProvider(create: (context) => FetchRatingAvgCubit()),
        BlocProvider(create: (context) => ImagePickerBloc(PickImageUseCase(ImagePickerRepositoryImpl(ImagePicker())))),
        BlocProvider(create: (context) => UploadServiceDataBloc(FirestoreBarberService(), CloudinaryService(),ImageUploaderMobile(CloudinaryService()))),
        BlocProvider(create: (context) => GenderOptionCubit(initialGender: getGenderOptionFromString(null))),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          return Scaffold(
            appBar: CustomAppBar(
              backgroundColor: AppPalette.blackClr,
              isTitle: true,
              title: 'Details Page',
              iconColor: AppPalette.whiteClr,
            ),
            body: BlocBuilder<ServicePageCubit, CurrentServicePage>(
                builder: (context, state) {
              switch (state) {
                case CurrentServicePage.pageOne:
                  return RatingAndReviewWidget(
                      screenHeight: screenHeight, screenWidth: screenWidth);

                case CurrentServicePage.pageTwo:
                  return ViewServiceDetailsPage(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  );
              }
            }),
            floatingActionButton: BlocBuilder<ServicePageCubit, CurrentServicePage>(
              builder: (context, state) {
                final isPageOne = state == CurrentServicePage.pageOne;
                return FloatingActionButton(
                  onPressed: () {
                    isPageOne ? context.read<ServicePageCubit>().goToPageTwo() : context.read<ServicePageCubit>().goToPageOne();
                  },
                  backgroundColor: AppPalette.orengeClr,
                  child: Icon(
                    isPageOne ? Icons.picture_as_pdf : Icons.reviews,
                    color: AppPalette.whiteClr,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

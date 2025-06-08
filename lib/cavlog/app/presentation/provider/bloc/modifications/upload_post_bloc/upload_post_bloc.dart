
import 'package:barber_pannel/cavlog/app/domain/usecases/imageuploadon_cloud_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../../core/cloudinary/cloudinary_service.dart';
import '../../../../../domain/usecases/upload_post_usecase.dart';
part 'upload_post_event.dart';
part 'upload_post_state.dart';

class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {
  String barberId = '';
  String imagePath = '';
  String description = '';
  final ImageUploader _repo;
  Uint8List? webImagePath;

  final CloudinaryService _cloudinaryService;
  final UploadPostUsecase _uploadPostUsecase;
  UploadPostBloc(this._cloudinaryService, this._uploadPostUsecase, this._repo)
      : super(UploadPostInitial()) {
    on<UploadPostEventRequst>((event, emit) {
      barberId = event.barberId;
      imagePath = event.imageUrl;
      description = event.description;
      webImagePath = event.imageBytes;
      emit(UploadPostShowAlert());
    });

    on<UploadPostConfirmed>((event, emit) async {
      emit(UploadPostLoading());
      try {
        final String? response;

        if (kIsWeb && webImagePath != null) {
          response = await _cloudinaryService.uploadWebImage(webImagePath!);
        }else {
          response = await _repo.upload(imagePath);
        }
        if (response == null) {
          emit(UploadPostFailure(errorMessage: 'Error due to: Image upload failed'));
          return;
        }

        final isSuccess = await _uploadPostUsecase.call(
        barberId: barberId, imageUrl: response, description: description);

        if (isSuccess) {
          emit(UploadPostSuccess());
        } else {
          emit(UploadPostFailure(errorMessage: 'Error: Post upload failed.'));
        }
      } catch (e) {
        emit(UploadPostFailure(errorMessage: 'Error due to: $e'));
      }
    });
  }
}

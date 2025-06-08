part of 'upload_service_data_bloc.dart';

abstract class UploadServiceDataEvent {}

class UploadServiceDataRequest extends UploadServiceDataEvent {
  final String imagePath;
  final Uint8List? imageBytes;
  final GenderOption genderOption;

  UploadServiceDataRequest({
    required this.imagePath,
    this.imageBytes,
    required this.genderOption,
  });
}

class UploadServiceConfirmed extends UploadServiceDataEvent {}

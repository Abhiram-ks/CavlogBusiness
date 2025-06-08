part of 'image_picker_bloc.dart';

abstract class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}
final class ImagePickerLoading extends ImagePickerState {}
final class ImagePickerSuccess extends ImagePickerState {
  final String? imagePath;   
  final Uint8List? imageBytes;  
  ImagePickerSuccess({this.imagePath, this.imageBytes});
}

final class ImagePickerError extends ImagePickerState {
  final String errorMessage;
  ImagePickerError(this.errorMessage);
}

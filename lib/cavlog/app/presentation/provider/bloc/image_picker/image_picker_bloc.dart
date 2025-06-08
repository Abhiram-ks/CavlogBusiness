import 'package:barber_pannel/cavlog/app/domain/usecases/image_picker_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final PickImageUseCase pickImageUseCase;
  ImagePickerBloc(this.pickImageUseCase) : super(ImagePickerInitial()) {
        on<ClearImageAction>((event, emit) {
        emit(ImagePickerInitial());
        });
    on<PickImageAction>((event, emit) async{
       emit(ImagePickerLoading());
      try { 
        if (kIsWeb) {
      
          final imageBytes = await pickImageUseCase.pickImageBytes();
          if (imageBytes != null) {
            emit(ImagePickerSuccess(imageBytes: imageBytes));
          }else {
             emit(ImagePickerError('Please select an image.'));
          }
        }  else {
          final imagePath = await pickImageUseCase.call();
          if (imagePath != null) {
            emit(ImagePickerSuccess(imagePath: imagePath));
          } else {
            emit(ImagePickerError('Please select an image.'));
          }
        }
      } catch (e) {
        emit(ImagePickerError("An Error occured:"));
      }
    });
  }
}

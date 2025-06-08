
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

abstract class ImagePickerRepository {
  Future<String?> pickImagePath();
  Future<Uint8List?> pickImageBytes();
}


class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ImagePicker _imagePicker;

  ImagePickerRepositoryImpl(this._imagePicker);

  @override
  Future<String?> pickImagePath() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  @override
  Future<Uint8List?> pickImageBytes() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return await image.readAsBytes();
  }
}

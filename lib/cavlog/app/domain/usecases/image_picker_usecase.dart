import 'dart:typed_data';
import '../../data/repositories/image_picker_repo.dart';



class PickImageUseCase {
  final ImagePickerRepository repository;

  PickImageUseCase(this.repository);

  Future<String?> call() async {
    return await repository.pickImagePath();
  }

  Future<Uint8List?> pickImageBytes() async {
    return await repository.pickImageBytes();
  }
}

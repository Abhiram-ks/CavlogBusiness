import 'dart:io';
import 'package:barber_pannel/core/cloudinary/cloudinary_service.dart';


abstract class ImageUploader {
  Future<String?> upload(String imagePath);
}


class ImageUploaderMobile implements ImageUploader {
  final CloudinaryService cloudinaryService;

  ImageUploaderMobile(this.cloudinaryService);

  @override
  Future<String?> upload(String imagePath) {
    return cloudinaryService.uploadImage(File(imagePath));
  }
}

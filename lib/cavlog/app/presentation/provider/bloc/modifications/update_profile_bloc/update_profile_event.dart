part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent{}
final class UpdateProfileRequest extends UpdateProfileEvent {
  final String image;
  final Uint8List? imageBytes;
  final String barberName;
  final String ventureName;
  final String phoneNumber;
  final String address;
  final int year;

  UpdateProfileRequest({
    required this.image,
    required this.barberName,
    required this.ventureName,
    this.imageBytes,
    required this.phoneNumber,
    required this.address,
    required this.year,
  });
}

final class ConfirmUpdateRequest extends UpdateProfileEvent {}
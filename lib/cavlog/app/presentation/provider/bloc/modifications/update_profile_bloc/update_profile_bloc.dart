
import 'package:barber_pannel/cavlog/app/domain/usecases/update_user_profile.dart';
import 'package:barber_pannel/core/cloudinary/cloudinary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../domain/usecases/imageuploadon_cloud_usecase.dart';
part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final CloudinaryService _cloudinaryService;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final ImageUploader _repo;

  Uint8List? webImagePath;
  String _barberName = '';
  String _ventureName = '';
  String _phoeNumber = '';
  String _address = '';
  String _image = '';
  int _year = 0;

  String get barberName => _barberName;
  String get ventureName => _ventureName;
  String get phoneNumber => _phoeNumber;
  String get address => _address;
  String get image => _image;
  int get year => _year;

  UpdateProfileBloc(
      this._cloudinaryService, this._updateUserProfileUseCase, this._repo)
      : super(UpdateProfileInitial()) {
    on<UpdateProfileRequest>((event, emit) {
      webImagePath = event.imageBytes;
      _barberName = event.barberName;
      _ventureName = event.ventureName;
      _phoeNumber = event.phoneNumber;
      _address = event.address;
      _year = event.year;
      _image = event.image;
      emit(ShowConfirmAlertBox());
    });

    on<ConfirmUpdateRequest>((event, emit) async {
      emit(UpdateProfileLoading());
      try {
        String imageUrl = _image;
        if (!_image.startsWith('http')) {
          final String? response;
          if (kIsWeb && webImagePath != null) {
            response = await _cloudinaryService.uploadWebImage(webImagePath!);
          } else {
            response = await _repo.upload(_image);
          }
          if (response == null || response.isEmpty) {
            emit(UpdateProfileFailure("Image upload failed."));
            return;
          }

          imageUrl = response;
        }

        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        final String? barberUid = preferences.getString('barberUid');

        if (barberUid == null || barberUid.isEmpty) {
          emit(UpdateProfileFailure('Error: Barber UID not found in Storage.'));
          return;
        }

        final isSuccess = await _updateUserProfileUseCase.updateUSerProfile(
            uid: barberUid,
            barberName: _barberName,
            ventureName: _ventureName,
            phoeNumber: _phoeNumber,
            address: _address,
            image: imageUrl,
            year: _year);

        if (isSuccess) {
          emit(UpdateProfileSuccess());
        } else {
          emit(UpdateProfileFailure('Error: Failed to update profile.'));
        }
      } catch (e) {
        emit(UpdateProfileFailure('Error: $e'));
      }
    });
  }
}

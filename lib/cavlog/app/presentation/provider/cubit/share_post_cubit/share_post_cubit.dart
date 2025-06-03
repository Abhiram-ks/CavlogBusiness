import 'package:barber_pannel/cavlog/app/presentation/screens/settings/view_post_screen/share_function_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareCubit extends Cubit<void> {
  final ShareService shareService;
  ShareCubit(this.shareService) : super(null);

  Future<void> sharePost({
    required String text,
    required String ventureName,
    required String location,
    String? imageUrl,
  }) async {
    await shareService.sharePost(
      text: text,
      ventureName: ventureName,
      location: location,
      imageUrl: imageUrl,
    );
  }
}

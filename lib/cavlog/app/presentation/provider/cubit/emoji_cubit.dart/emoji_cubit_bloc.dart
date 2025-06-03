
import 'package:bloc/bloc.dart';

class EmojiPickerCubit extends Cubit<bool> {
  EmojiPickerCubit() : super(false);

  void toggleEmoji() => emit(!state);
  void hideEmoji() => emit(false);
}

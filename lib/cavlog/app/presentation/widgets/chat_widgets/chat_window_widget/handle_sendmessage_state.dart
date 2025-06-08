
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/common/snackbar_helper.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../auth/presentation/provider/cubit/buttonProgress/button_progress_cubit.dart';
import '../../../provider/bloc/image_picker/image_picker_bloc.dart';
import '../../../provider/bloc/send_message_bloc/send_message_bloc.dart';

void handleSendMessage(BuildContext context, SendMessageState state,TextEditingController controller) {
   final buttonCubit = context.read<ButtonProgressCubit>();
   if (state is SendMessageLoading) {
     buttonCubit.sendButtonStart();
   }
  else if(state is SendMessageSuccess) {
     controller.clear();
     context.read<ImagePickerBloc>().add(ClearImageAction());
     buttonCubit.stopLoading();
  } else if (state is SendMessageFailure) {
    buttonCubit.stopLoading();

    CustomeSnackBar.show(
      context: context,
      title: 'Message Not Delivered!  ',
      description: 'We hit a bump while sending your message. Let’s try again.',
      titleClr: AppPalette.redClr,
    );
  }
}
import 'package:barber_pannel/cavlog/auth/presentation/provider/cubit/buttonProgress/button_progress_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/snackbar_helper.dart';
import '../../../../../core/themes/colors.dart';
import '../../provider/bloc/RegisterSubmition/register_submition_bloc.dart';
import 'navigation_to_admin.dart';

void handleOTPVarificationState(
    BuildContext context, RegisterSubmitionState state, ) {
       final buttonCubit = context.read<ButtonProgressCubit>();
   if (state is OtpVarifyed) {
     context.read<RegisterSubmitionBloc>().add(SubmitRegistration());
  }
  if (state is OtpIncorrect) {
    CustomeSnackBar.show(
      context: context,
      title: 'Invalid OTP',
      description: "Oops! The OTP you entered is incorrect. Please check and try again. Error: ${state.error}",
      titleClr: AppPalette.blackClr,
    );
  } else if (state is OtpExpired) {
    CustomeSnackBar.show(
      context: context,
      title: 'OTP Expired',
      description: "Oops! The OTP you entered has expired. Please request a new OTP.",
      titleClr: AppPalette.blackClr,
    );
  } else if (state is RegisterLoading){
    buttonCubit.startLoading();
  }
  else if (state is RegisterSuccess){
    buttonCubit.stopLoading();
    navigateToAdminRequest(context);
  }
  else if (state is RegisterFailure) {
  buttonCubit.stopLoading();

  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text('Registration Failed'),
      content: Text('Something went wrong. Please try again.'),
      actions: [
        CupertinoDialogAction(
          child: Text('Retry',style: TextStyle(color: AppPalette.redClr)),
          onPressed: () {
            Navigator.of(context).pop();
           context.read<RegisterSubmitionBloc>().add((SubmitRegistration()));
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel',style: TextStyle(color: AppPalette.blackClr),),
        ),
      ],
    ),
  );
}
}
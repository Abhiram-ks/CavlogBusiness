

import 'package:barber_pannel/cavlog/auth/presentation/provider/cubit/buttonProgress/button_progress_cubit.dart';
import 'package:barber_pannel/cavlog/auth/presentation/widgets/otp_widget/navigation_to_admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/common/snackbar_helper.dart';
import '../../../../../core/themes/colors.dart';
import '../../provider/bloc/RegisterSubmition/register_submition_bloc.dart';

void handleOtpState(
    BuildContext context, RegisterSubmitionState state, bool otpsed) {
      final buttonCubit = context.read<ButtonProgressCubit>();

  if (state is OtpLoading) {
    CustomeSnackBar.show(
      context: context,
      title: otpsed
          ? "Sending OTP to Email..."
          : "Resending Authentication Email...",
      description: otpsed
          ? "Please wait while we send your OTP email."
          : "We're resending the verification email. Please wait...",
      titleClr: AppPalette.buttonClr,
    );
  } else if (state is OtpSuccess) {
    CustomeSnackBar.show(
      context: context,
      title: otpsed ? "OTP Sent Successfully" : "Verification Email Resent!",
      description: otpsed
          ? "Check your inbox and enter the OTP to continue."
          : "Check your inbox and verify your email to proceed.",
      titleClr: AppPalette.greenClr,
    );
  } else if (state is OtpFailure) {
    CustomeSnackBar.show(
      context: context,
      title: otpsed ? "OTP Sending Failed" : "Resend Failed!",
      description: otpsed
          ? "We couldn't send the OTP. Error: ${state.error}"
          : "We couldn't resend the email. Error: ${state.error}",
      titleClr: AppPalette.redClr,
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



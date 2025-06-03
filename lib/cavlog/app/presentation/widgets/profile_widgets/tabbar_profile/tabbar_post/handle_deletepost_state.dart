import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/delete_post_cubit/delete_post_cubit.dart';
import 'package:barber_pannel/core/common/snackbar_helper.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';

void handleDeletePostsState(BuildContext context, DeletePostState state) {
  //! Handles the state session for slot deletion
  if (state is DeletePostLoading) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleting...'),
      ),
    );
  } else if (state is DeletePostSuccess) {
    CustomeSnackBar.show(
      context: context,
      title: 'Session Successful!',
      description:
          "Post deleted successfully. This action is permanent and cannot be undone.",
      titleClr: AppPalette.greenClr,
    );
  } else if (state is DeletePostFailure) {
    Navigator.pop(context);
    CustomeSnackBar.show(
      context: context,
      title: 'Session Failure!',
      description:
          "Oops! Unfortunately, post deletion failed. Please try again later.",
      titleClr: AppPalette.redClr,
    );
  }
}

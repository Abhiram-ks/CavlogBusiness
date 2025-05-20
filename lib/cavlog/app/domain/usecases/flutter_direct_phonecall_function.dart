import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/common/snackbar_helper.dart';
import '../../../../core/themes/colors.dart';

class CallHelper {
  static Future<void> makeCall(String phoneNumber, BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        if (await Permission.phone.request().isGranted) {
          await FlutterPhoneDirectCaller.callNumber(phoneNumber);
        } else {
          if (!context.mounted) return;
          CustomeSnackBar.show(
            context: context,
            title: 'Permission Denied',
            description: 'Phone call permission is required to make direct calls.',
            titleClr: AppPalette.redClr,
          );
        }
      } else if (Platform.isIOS) {
        final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
        if (await canLaunchUrl(telUri)) {
          await launchUrl(telUri);
        } else {
          throw 'Could not launch dialer';
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomeSnackBar.show(
        context: context,
        title: 'Unable to Connect',
        description: 'We couldn’t make the call right now. Please try again.\n\nError: $e',
        titleClr: AppPalette.redClr,
      );
    }
  }
}

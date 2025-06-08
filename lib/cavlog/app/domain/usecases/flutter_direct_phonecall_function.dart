
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/common/snackbar_helper.dart';
import '../../../../core/themes/colors.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart' show kIsWeb;

class CallHelper {
  static Future<void> makeCall(String phoneNumber, BuildContext context) async {
    try {
      final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

      if (kIsWeb) {
        if (await canLaunchUrl(telUri)) {
          await launchUrl(telUri);
        } else {
          if (!context.mounted) return;
          _showError(context, 'Cannot launch dialer on web.');
        }
        return;
      }


      if (Theme.of(context).platform == TargetPlatform.android) {
        if (await Permission.phone.request().isGranted) {
          await FlutterPhoneDirectCaller.callNumber(phoneNumber);
        } else {
           if (!context.mounted) return;
          _showPermissionError(context);
        }
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await canLaunchUrl(telUri)) {
          await launchUrl(telUri);
        } else {
            if (!context.mounted) return;
          _showError(context, 'Could not open dialer.');
        }
      } else {
        _showError(context, 'Platform not supported.');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'We couldn’t make the call. Please try again.\n\nError: $e');
    }
  }

  static void _showError(BuildContext context, String message) {
 
    CustomeSnackBar.show(
      context: context,
      title: 'Unable to Connect',
      description: message,
      titleClr: AppPalette.redClr,
    );
  }

  static void _showPermissionError(BuildContext context) {
    if (!context.mounted) return;
    CustomeSnackBar.show(
      context: context,
      title: 'Permission Denied',
      description: 'Phone call permission is required to make direct calls.',
      titleClr: AppPalette.redClr,
    );
  }
}

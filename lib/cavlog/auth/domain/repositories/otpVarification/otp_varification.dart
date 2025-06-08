

import 'package:flutter/material.dart';

class OtpVarification {
  DateTime otpCreationTime = DateTime.now();
  final Duration otpValidity  = Duration(minutes: 2);


  Future<bool> verifyOTP({required String inputOtp,required String? otp}) async{
    try {   
     if (inputOtp.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(inputOtp)){
       debugPrint('Invalid OTP format: $inputOtp');
       return false;
      }

      if (DateTime.now().difference(otpCreationTime) > otpValidity){
          debugPrint('OTP expired.');
          return false;
        }
        
        return Future.delayed(Duration(seconds: 1), (){
          return inputOtp == otp;
        });

    }catch (e) {
      return false;
    }
  }

}


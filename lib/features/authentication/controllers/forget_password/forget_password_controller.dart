import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starfolio/data/repositories/authentication/authentication_repository.dart';
import 'package:starfolio/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:starfolio/utils/popups/full_screen_loader.dart';
import 'package:starfolio/utils/popups/loaders.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../screens/password_configuration/reset_password.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  //v ariables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Processing your request...', TImages.docerAnimation);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // waits for email to be sent
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // removes full screen loader
      TFullScreenLoader.stopLoading();

      // notifies the user of a success that email has been sent
      TLoaders.successSnackBar(title: "Email Sent", message: "EMAIL link sent to reset your password".tr);

      // go to reset password screen w/ getx
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    }
    catch (e) {
      // in case of error, send error message
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // resend password email in case the user didn't get it :( (same logic as before)
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Processing your request...', TImages.docerAnimation);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: "Email Sent", message: "EMAIL link sent to reset your password".tr);
    }
    catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
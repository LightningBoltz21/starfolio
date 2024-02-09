import 'package:flutter/material.dart';
import 'package:starfolio/utils/constants/image_strings.dart';
import 'package:starfolio/utils/constants/text_strings.dart';
import 'package:starfolio/utils/constants/sizes.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';
import 'package:starfolio/utils/device/device_utility.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
// import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starfolio/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: TDeviceUtils.getAppBarHeight(),
        right: TSizes.defaultSpace,
        child: TextButton(
          onPressed: () {},
          child: TextButton(onPressed: () => OnBoardingController.instance.skipPage(), child: const Text('Skip')),
        ));
  }
}
import 'package:flutter/material.dart';
import 'package:starfolio/utils/constants/image_strings.dart';
import 'package:starfolio/utils/constants/text_strings.dart';
import 'package:starfolio/utils/constants/sizes.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';
import 'package:starfolio/utils/device/device_utility.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
//import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starfolio/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';

class OnBoardingButton extends StatelessWidget {

  const OnBoardingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      right: TSizes.defaultSpace,
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(shape: CircleBorder(), backgroundColor: dark ? TColors.primary : Colors.black),
        child: Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}


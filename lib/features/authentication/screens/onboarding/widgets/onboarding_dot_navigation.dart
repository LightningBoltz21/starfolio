import 'package:flutter/material.dart';
import 'package:starfolio/utils/constants/image_strings.dart';
import 'package:starfolio/utils/constants/text_strings.dart';
import 'package:starfolio/utils/constants/sizes.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';
import 'package:starfolio/utils/device/device_utility.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
//import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:starfolio/features/authentication/screens/onboarding/widgets/onboarding_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starfolio/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class OnBoardingDotNavigation extends StatelessWidget {

  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
            activeDotColor: dark ? TColors.light: TColors.dark, dotHeight: 6),
      ),
    );
  }
}


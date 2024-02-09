import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starfolio/common/styles/spacing_styles.dart';
import 'package:starfolio/features/authentication/screens/login/widgets/login_form.dart';
import 'package:starfolio/features/authentication/screens/login/widgets/login_header.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/constants/image_strings.dart';
import 'package:starfolio/utils/constants/sizes.dart';
import 'package:starfolio/utils/constants/text_strings.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              LoginHeader(dark: dark,),
              const LoginForm(),
              const FormDivider(dividerText: "OR SIGN IN WITH"),
              const SizedBox(height: TSizes.spaceBtwSections),
              const SocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}









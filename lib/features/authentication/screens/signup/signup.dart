import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starfolio/common/widgets/login_signup/form_divider.dart';
import 'package:starfolio/common/widgets/login_signup/social_buttons.dart';
import 'package:starfolio/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/constants/sizes.dart';
import 'package:starfolio/utils/constants/text_strings.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),
              const SignupForm(),

              // Divider
              const SizedBox(height: TSizes.spaceBtwSections),
              FormDivider(dividerText: TTexts.orSignUpWith.capitalize!),

              // Social Buttons
              const SizedBox(height: TSizes.spaceBtwSections),
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}



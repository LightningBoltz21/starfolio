import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starfolio/features/authentication/screens/signup/verify_email.dart';
import 'package:starfolio/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';
import 'package:starfolio/utils/validators/validation.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signup/signup_controller.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) => TValidator.validateEmptyText('First Name', value),
                  controller: controller.firstName,
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.firstName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  validator: (value) => TValidator.validateEmptyText('Last Name', value),
                  controller: controller.lastName,
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.lastName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            validator: (value) => TValidator.validateEmptyText('UserName', value),
            controller: controller.username,
            expands: false,
            decoration: const InputDecoration(
                labelText: TTexts.username,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            validator: (value) => TValidator.validateEmail(value),
            controller: controller.email,
            expands: false,
            decoration: const InputDecoration(
                labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            validator: (value) => TValidator.validatePhoneNumber(value),
            controller: controller.phoneNumber,
            expands: false,
            decoration: const InputDecoration(
                labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Password
          Obx(
            () => TextFormField(
              validator: (value) => TValidator.validatePassword(value),
              controller: controller.password,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash: Iconsax.eye),
                ),
              ),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Terms and Conditions
          const TermsAndConditionsCheckbox(),
          const SizedBox(height: TSizes.spaceBtwSections),
          //Sign Up Button
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.signup(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                  ),
                  child: const Text(TTexts.createAccount))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starfolio/common/section_heading.dart';
import 'package:starfolio/common/widgets/app_bar/app_bar.dart';
import 'package:starfolio/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:starfolio/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:starfolio/data/repositories/authentication/authentication_repository.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/constants/sizes.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            PrimaryHeaderContainer(
                child: Column(
              children: [
                AppBar2(
                    title: Text('Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: TColors.white))),
                // User Profile Card
                TUserProfileTile(
                    onPressed: () => Get.to(() => const ProfileScreen())),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            )),
            //Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TSettingsMenuTile(
                    icon: Iconsax.notification,
                    title: 'Notifications',
                    subTitle: 'Manage When You Get Notified',
                    onTap: () {},
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.security_card,
                    title: 'Account Privacy',
                    subTitle: 'Manage Data Usage and Connected Accounts',
                    onTap: () {},
                  ),

                  // App Settings
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const TSectionHeading(
                      title: 'App Settings', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TSettingsMenuTile(
                      icon: Iconsax.document_upload,
                      title: 'Load Data',
                      subTitle: 'Upload Data to Cloud Firestore'),
                  TSettingsMenuTile(
                      icon: Iconsax.image,
                      title: 'HD Image Quality',
                      subTitle: 'Adjust Image Quality',
                      trailing: Switch(value: false, onChanged: (value) {})),

                  // Logout Button
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(onPressed: () => AuthenticationRepository.instance.logout(), child: const Text("Logout"),),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

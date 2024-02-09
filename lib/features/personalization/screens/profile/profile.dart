import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starfolio/common/section_heading.dart';
import 'package:starfolio/common/t_circular_image.dart';
import 'package:starfolio/common/widgets/app_bar/app_bar.dart';
import 'package:starfolio/data/repositories/user/user_repository.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/portfolio_app_bar.dart';
import 'package:starfolio/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:starfolio/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:starfolio/utils/constants/image_strings.dart';
import 'package:starfolio/utils/constants/sizes.dart';
import 'package:starfolio/utils/popups/loaders.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const AppBar2(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            // Profile Picture
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Obx(() {
                    final networkImage = controller.user.value.profilePicture;
                    final image = networkImage.isNotEmpty
                        ? networkImage
                        : TImages.onBoardingImage1;
                    return controller.imageUploading.value
                        ? const TShimmerEffect(
                            width: 80,
                            height: 80,
                            radius: 80,
                          )
                        : TCircularImage(
                            image: image,
                            width: 80,
                            height: 80,
                            isNetworkImage: networkImage.isNotEmpty,
                          );
                  }),
                  TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('Change Profile Picture')),
                ],
              ),
            ),

            // Details
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            const TSectionHeading(
                title: 'Profile Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
              onPressed: () => Get.to(() => const ChangeName()),
              title: 'Name',
              value: controller.user.value.fullName,
            ),
            TProfileMenu(
              onPressed: () {},
              title: 'UserName',
              value: controller.user.value.username,
            ),

            const SizedBox(height: TSizes.spaceBtwItems),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
              onPressed: () {},
              title: 'User ID',
              value: controller.user.value.id,
              icon: Iconsax.copy,
            ),
            TProfileMenu(
              onPressed: () {},
              title: 'E-mail',
              value: controller.user.value.email,
            ),
            TProfileMenu(
              onPressed: () {},
              title: 'Phone Number',
              value: controller.user.value.phoneNumber,
            ),
            TProfileMenu(
              onPressed: () {},
              title: 'Gender',
              value: 'Male',
            ),
            TProfileMenu(
              onPressed: () {},
              title: 'Date of Birth',
              value: '4/21/2007',
            ),

            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),
            Center(
              child: TextButton(
                onPressed: () => controller.deleteAccountWarningPopup(),
                child: const Text(
                  'Close Account',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    firstName.text = userController.user.value.firstName;
  }

  Future<void> updateUserName() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Logging you in...', TImages.docerAnimation);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim()
      };
      await userRepository.updateSingleField(name);

      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your name has been updated!');

      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starfolio/data/repositories/authentication/authentication_repository.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/category_widget.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/portfolio_app_bar.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/constants/image_strings.dart';
import 'package:starfolio/utils/constants/sizes.dart';

import '../../../../common/t_circular_image.dart';
import '../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/models/user_model.dart';
import '../../controllers/portfolio_controller.dart';

class Portfolio extends StatelessWidget {

  const Portfolio({super.key});

  @override
  Widget build(BuildContext context) {
    // get instances of controllers with getx

    final UserController userController = Get.put(UserController());
    final PortfolioController portfolioController = Get.put(PortfolioController());

    portfolioController.fetchPortfolioData(userController.user.value.id);
    bool isCurrentUser = AuthenticationRepository().authUser?.uid == userController.user.value.id;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [

            Container(
              color: TColors.primary, // purple background color
              width: double.infinity, // Ensure the container fills the width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // app bar with buttons (save and add category)
                  PortfolioAppBar(isCurrentUser: isCurrentUser, userProfile: userController.user.value,),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // get user image, if can't connect to firebase storage then load google image
                  Obx(() {
                    final networkImage = userController.user.value.profilePicture;
                    final image = networkImage.isNotEmpty
                        ? networkImage
                        : TImages.onBoardingImage1;
                    return userController.imageUploading.value
                        ? const TShimmerEffect(
                          width: 80,
                          height: 80,
                          radius: 80,
                        )
                        : TCircularImage(
                          image: image,
                          width: 200,
                          height: 200,
                          isNetworkImage: networkImage.isNotEmpty,
                        );
                  }),

                  const SizedBox(height: TSizes.spaceBtwItems), //space between image and portfolio section
                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
                    child: GetBuilder<PortfolioController>(
                      builder: (controller) => ListView.builder(
                        // list of categories, each category has list experiences
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryWidget(
                            category: controller.items[index],
                            portfolioController: controller, isCurrentUser: isCurrentUser, userController: userController,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Add your search bar or any other widgets here
                ],
              ),
            ),
            // circle design to make the app look nice :)
            Positioned.fill( // Use Positioned.fill to make the IgnorePointer fill the stack
              child: IgnorePointer(
                child: Stack(
                  children: [
                    Positioned(
                      top: -150,
                      right: -250,
                      child: CircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1)),
                    ),
                    Positioned(
                      top: 100,
                      right: -300,
                      child: CircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

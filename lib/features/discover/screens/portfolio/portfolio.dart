import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/category.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/portfolio_app_bar.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/constants/image_strings.dart';
import 'package:starfolio/utils/constants/sizes.dart';

import '../../../../common/t_circular_image.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controllers/portfolio_controller.dart';

class Portfolio extends StatelessWidget {
  const Portfolio({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: TColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const PortfolioAppBar(),
              const SizedBox(height: TSizes.spaceBtwSections),
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
              const SizedBox(height: TSizes.spaceBtwItems),
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
                child: GetBuilder<PortfolioController>(
                  builder: (controller) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Category(
                          name: controller.items[index].name ?? '',
                          index: index,
                          portfolioController: controller);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Add your search bar or any other widgets here
            ],
          ),
        ),
      ),
    );
  }
}

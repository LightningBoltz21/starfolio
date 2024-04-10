import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starfolio/features/discover/screens/portfolio/portfolio.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/portfolio_app_bar.dart';
import 'package:starfolio/utils/constants/sizes.dart';

import '../../../common/t_circular_image.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../personalization/controllers/user_controller.dart';

class Connect extends StatelessWidget {
  Connect({Key? key});

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2(
        title: Text(
          'Connect',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: TextField(
              controller: userController.searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust the number of columns as needed
                childAspectRatio: 0.8, // Adjust the aspect ratio as needed
              ),
              itemCount: userController.filteredUsers.length,
              itemBuilder: (context, index) {
                final user = userController.filteredUsers[index];
                final networkImage = user.profilePicture;
                final image = networkImage.isNotEmpty
                    ? networkImage
                    : TImages.onBoardingImage1; // Default image if no network image
                var userString = "${user.fullName}, ${user.gradeRole} @ ${user.schoolOrg}";

                return GestureDetector(
                  onTap: () {
                    // Handle the onTap event
                    Get.to(() => Portfolio(userProfile: user));
                  },
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: TColors.primary,
                      title: Text(
                        userString,
                        style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.white),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                      ),
                    ),
                    child: userController.imageUploading.value
                        ? const TShimmerEffect(
                      width: 80,
                      height: 80,
                      radius: 80,
                    )
                        : TCircularImage(
                      image: image,
                      width: 100, // Adjust the width as needed
                      height: 100, // Adjust the height as needed
                      isNetworkImage: networkImage.isNotEmpty,
                    ),
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
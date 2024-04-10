import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:intl/intl.dart";
import "package:share_plus/share_plus.dart";
import "package:starfolio/features/discover/screens/portfolio/widgets/portfolio_app_bar.dart";
import "package:starfolio/utils/constants/colors.dart";
import "package:starfolio/utils/constants/sizes.dart";

import "../../../../../common/t_circular_image.dart";
import "../../../../../utils/constants/image_strings.dart";
import "../../../../personalization/controllers/user_controller.dart";
import "../../../controllers/portfolio_controller.dart";
import "../../../models/experience.dart";
import "../add_items.dart";

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final PortfolioController portfolioController;
  final UserController userController;
  final bool isCurrentUser; // Add this line

  const ExperienceCard({
    Key? key,
    required this.experience,
    required this.portfolioController,
    required this.isCurrentUser,
    required this.userController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      return DateFormat('MMMM yyyy').format(date);
    }

    String dateRange =
        '${formatDate(experience.startDate)} - ${formatDate(experience.endDate)}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      // Increased vertical margin
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for the image
                const SizedBox(width: 8.0),
                const SizedBox(
                  width: 35.0,
                  height: 35.0,
                  child: Icon(
                    Iconsax.magic_star1,
                    color: TColors.primary,
                  ), // Placeholder icon
                ),
                const SizedBox(width: 10.0),
                // Experience details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.title,
                        style: const TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        dateRange,
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Added padding below the image and details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(experience.description,
                  style: const TextStyle(fontSize: 14.0)),
            ),
            // Moved description below the image and details
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Obx(() {
                    final networkImage = experience.image;

                    // Check if the image is uploading, show a shimmer effect
                    if (userController.imageUploading.value) {
                      return const TShimmerEffect(
                        width: 80,
                        height: 80,
                        radius: 80,
                      );
                    }

                    // If there's a network image, show it; otherwise, show no widget or an empty space
                    if (networkImage.isNotEmpty || networkImage != "") {
                      return TRectImage(
                        image: networkImage,
                        width: 250,
                        height: 250,
                        isNetworkImage: true,
                      );
                    } else {
                      // Return an empty Container or SizedBox if you don't want to show any widget
                      // return Container(); // Use this if you don't want the widget to occupy any space
                      return const SizedBox.shrink(); // This also ensures the widget takes up no space
                    }
                  }),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.share, size: 20), // Share button
                  color: Colors.green, // Green color
                  onPressed: () {
                    // Handle share action
                    final String shareContent =
                        '''I experienced ${experience.title} from ${formatDate(experience.startDate)} - ${formatDate(experience.endDate)}. ${experience.description} ${experience.image}''';

                    Share.share(shareContent);
                  },
                ),
                const SizedBox(width: 8.0),
                if (isCurrentUser)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20), // Edit button
                    color: TColors.primary,
                    onPressed: () {
                      // Open the AddItems screen with existing data
                      Get.to(() => AddItems(
                            categoryIndex: experience.categoryIndex,
                            existingExperience: experience,
                            controller: portfolioController,
                          ));
                    },
                  ),
                if (isCurrentUser) const SizedBox(width: 8.0),
                if (isCurrentUser)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20), // Delete button
                    color: Colors.red,
                    onPressed: () {
                      // Delete the experience
                      portfolioController.removeExperience(experience);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

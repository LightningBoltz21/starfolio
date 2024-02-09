import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:intl/intl.dart";
import "package:share_plus/share_plus.dart";
import "package:starfolio/utils/constants/colors.dart";
import "package:starfolio/utils/constants/sizes.dart";

import "../../../controllers/portfolio_controller.dart";
import "../../../models/experience.dart";
import "../add_items.dart";
import "../portfolio.dart";

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final PortfolioController portfolioController;

  const ExperienceCard({
    Key? key,
    required this.experience,
    required this.portfolioController,
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
                Container(
                  width: 35.0,
                  height: 35.0,
                  child: const Icon(Iconsax.magic_star1, color: TColors.primary,), // Placeholder icon
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.share, size: 20), // Share button
                  color: Colors.green, // Green color
                  onPressed: () {
                    // Handle share action
                    final String shareContent =
                    '''Experience Title: ${experience.title}
                    Date Range: ${formatDate(experience.startDate)} - ${formatDate(experience.endDate)}
                    Description: ${experience.description}''';

                    Share.share(shareContent);
                  },
                ),
                const SizedBox(width: 8.0),
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
                const SizedBox(width: 8.0),
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

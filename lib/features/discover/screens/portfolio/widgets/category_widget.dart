
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/experience_card.dart';

import '../../../controllers/portfolio_controller.dart';
import '../../../models/experience.dart';
import '../add_items.dart';


class Category extends StatelessWidget {
  final String name;
  final int index;
  final PortfolioController portfolioController; // Add this

  const Category({
    Key? key,
    required this.name,
    required this.index,
    required this.portfolioController, // Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: Colors.white)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Get.to(() => AddItems(categoryIndex: index, controller: portfolioController));
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  portfolioController.renameItem(context, index);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  // Remove the item from the list using GetX state management
                  portfolioController.removeItem(index);
                },
              ),
            ],
          ),
        ),
        const Divider(),
        Obx(() {
          final List<Experience> categoryExperiences = portfolioController.experiences
              .where((experience) => experience.categoryIndex == index)
              .toList();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: categoryExperiences.length,
            itemBuilder: (context, experienceIndex) {
              final Experience experience = categoryExperiences[experienceIndex];
              return ExperienceCard(experience: experience, portfolioController: portfolioController);
            },
          );
        }),
      ],
    );
  }
}

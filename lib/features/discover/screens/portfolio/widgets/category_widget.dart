import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/experience_card.dart';
import 'package:starfolio/features/personalization/controllers/user_controller.dart';

import '../../../controllers/portfolio_controller.dart';
import '../../../models/category_model.dart';
import '../../../models/experience.dart';
import '../add_items.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final PortfolioController portfolioController;
  final UserController userController;
  final bool isCurrentUser;

  const CategoryWidget({
    Key? key,
    required this.category,
    required this.portfolioController,
    required this.isCurrentUser, required this.userController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(category.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: Colors.white)),
          trailing: isCurrentUser ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Get.to(() => AddItems(
                      categoryIndex: category.index,
                      controller: portfolioController));
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  portfolioController.renameItem(context, category.index);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  portfolioController.removeItem(category.index);
                },
              ),
            ],
          ) : const SizedBox.shrink(),
        ),
        const Divider(),
        Obx(() {
          final List<Experience> categoryExperiences = portfolioController
              .experiences
              .where((experience) => experience.categoryIndex == category.index)
              .toList();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: categoryExperiences.length,
            itemBuilder: (context, experienceIndex) {
              final Experience experience =
                  categoryExperiences[experienceIndex];
              return ExperienceCard(
                  experience: experience,
                  portfolioController: portfolioController, isCurrentUser: isCurrentUser, userController: userController,);
            },
          );
        }),
      ],
    );
  }
}

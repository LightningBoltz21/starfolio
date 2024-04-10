import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starfolio/features/discover/controllers/portfolio_controller.dart';
import 'package:starfolio/features/personalization/controllers/user_controller.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../common/widgets/products.cart/cart_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../personalization/models/user_model.dart';

class PortfolioAppBar extends StatelessWidget {

  final UserModel userProfile;
  final bool isCurrentUser;

  const PortfolioAppBar({
    super.key,
    required this.userProfile,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final controller2 = Get.put(PortfolioController());
    print(controller.user.value);

    return AppBar2(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (controller.profileLoading.value) {
              return const TShimmerEffect(width: 80, height: 15);
            } else {
              return (Text(userProfile.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .apply(color: TColors.white)));
            }
          }),
          Obx(() {
            if (controller.profileLoading.value) {
              return const TShimmerEffect(width: 80, height: 15);
            } else {
              var output = '${userProfile.gradeRole} @ ${userProfile.schoolOrg}';
              return (Text(output,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: TColors.white)));
            }
          }),
        ],
      ),
      actions: [
        isCurrentUser ? IconButton(
            onPressed: () {
              controller2.savePortfolioData();
            },
            icon: const Icon(Iconsax.save_2, color: Colors.white)) : const SizedBox.shrink(),
        isCurrentUser ? CartCounterIcon(
            onPressed: () => controller2.addItem(context),
            iconColor: TColors.white) : const SizedBox.shrink()
      ],
    );
  }
}

class TShimmerEffect extends StatelessWidget {
  const TShimmerEffect({
    Key? key,
    required this.width,
    required this.height,
    this.radius = 15,
    this.color,
  }) : super(key: key);

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Shimmer.fromColors(
      baseColor: dark ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: dark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? (dark ? TColors.darkerGrey : TColors.white),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

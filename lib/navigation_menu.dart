import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starfolio/data/repositories/authentication/authentication_repository.dart';
import 'package:starfolio/features/discover/screens/connect.dart';
import 'package:starfolio/features/discover/screens/portfolio/portfolio.dart';
import 'package:starfolio/features/personalization/controllers/user_controller.dart';
import 'package:starfolio/features/personalization/screens/settings/settings.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(() => NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: controller.handleSelectedIndex,
        backgroundColor: darkMode ? TColors.black : Colors.white,
        indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.magic_star), label: 'PORTFOLIO'),
          NavigationDestination(icon: Icon(Iconsax.link), label: 'CONNECT'),
          NavigationDestination(icon: Icon(Iconsax.setting), label: 'SETTINGS'),
        ],
      )),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  List<Widget>? _screens;

  List<Widget> get screens {
    _screens ??= [
      const Portfolio(),
      Connect(),
      const SettingsScreen(),
    ];
    return _screens!;
  }

  void handleSelectedIndex(int index) async {
    if (index == 0 || index == 2) { // Assuming Portfolio is at index 0 and Settings at index 2
      await fetchUserDetails();
    }
    selectedIndex.value = index; // Update the index after fetching data
  }

  Future<void> fetchUserDetails() async {
    UserController userController = Get.put(UserController());
    await userController.fetchUserById(AuthenticationRepository().authUser!.uid);
  }
}
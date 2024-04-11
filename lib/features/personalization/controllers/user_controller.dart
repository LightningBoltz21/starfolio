import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starfolio/data/repositories/authentication/authentication_repository.dart';
import 'package:starfolio/data/repositories/user/user_repository.dart';
import 'package:starfolio/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:starfolio/utils/constants/image_strings.dart';
import 'package:starfolio/utils/constants/sizes.dart';
import 'package:starfolio/utils/popups/full_screen_loader.dart';
import 'package:starfolio/utils/popups/loaders.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../authentication/screens/login/login.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;
  TextEditingController searchController = TextEditingController();

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
    fetchAllUsers();
    searchController.addListener(() {
      filterUsers();
    });
  }

  Future<void> fetchUserById(String userId) async {
    try {
      // Get the document reference from Firestore using the userId
      DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      // If the document exists, convert the data to a UserModel and update the `user` observable
      if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
        user.value = UserModel.fromSnapshot(userDocSnapshot);
      } else {
        // Handle the case where the user does not exist
        if (kDebugMode) {
          print("No user found for id: $userId");
        }
        user.value = UserModel.empty(); // or however you handle non-existent users
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      if (kDebugMode) {
        print("Error fetching user by id: $e");
      }
      user.value = UserModel.empty(); // Use an appropriate default or error value
    }
  }

  void fetchAllUsers() async {
    try {
      // Fetch all users from Firestore and update `allUsers` list
      final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
      final usersData = usersSnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
      allUsers.assignAll(usersData);
      filteredUsers.assignAll(allUsers);
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  void filterUsers() {
    String query = searchController.text.toLowerCase();
    List<UserModel> tempFilteredUsers = [];
    if (query.isNotEmpty) {
      tempFilteredUsers = allUsers.where((user) => user.fullName.toLowerCase().contains(query)).toList();
    } else {
      tempFilteredUsers.assignAll(allUsers);
    }
    filteredUsers.assignAll(tempFilteredUsers);
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {

      // REFRESH USER RECORD
      await fetchUserRecord();
      if (user.value.id.isEmpty) {

        if (userCredentials != null) {
          final nameParts =
          UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final username =
          UserModel.generateUsername(userCredentials.user!.displayName ?? '');

          // MAP DATA
          final user = UserModel(
            id: userCredentials.user!.uid,
            username: username,
            email: userCredentials.user!.email ?? '',
            firstName: nameParts[0],
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join('') : '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
            schoolOrg: '',
            gradeRole: '',
          );

          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
          title: "Data was not saved",
          message:
              "Something went wrong with saving your information. You can re-save your data in your profile.");
    }
  }

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: 'Delete Account',
        middleText:
            'Are you sure you want to delete your account? This action is not reversible and all of your data will be lost.',
        confirm: ElevatedButton(
          onPressed: () async => deleteUserAccount(),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              side: const BorderSide(color: Colors.red)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
            child: Text('Delete'),
          ),
        ),
        cancel: OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        ));
  }

  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing', TImages.docerAnimation);

      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // RE-AUTHENTICATE BEFORE DELETING
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Processing...', TImages.docerAnimation);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!reAuthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // UPLOAD PROFILE IMAGE
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 1024,
          maxWidth: 1024);
      if (image != null) {
        imageUploading.value = true;
        if(kDebugMode) {
          print("UPLOADING UPLOADING");
        }
        final imageUrl = await userRepository.uploadImage(
            'Users/Images/Profile/', image);

        // Update user image record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();
        TLoaders.successSnackBar(title: 'Congratulations', message: 'Your profile image has been updated!');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Something went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }
}

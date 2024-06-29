import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/portfolio_controller.dart';
import '../../models/experience.dart';

class AddItems extends StatelessWidget {
  final int categoryIndex;
  final PortfolioController controller;
  final Experience? existingExperience;
  final userRepository = Get.put(UserRepository());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the form
  final imageUploading = false.obs;

  AddItems({
    Key? key,
    required this.categoryIndex,
    required this.controller,
    this.existingExperience,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _initializeFormFields();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Manage Experience'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // Wrap your widget with a Form widget
            key: _formKey, // Associate the Form with a GlobalKey
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Title', value),
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: controller.titleController,
                ),
                const SizedBox(height: 16.0),
                _buildDateTimePicker(
                  labelText: 'Start Date',
                  onChanged: (value) {
                    controller.selectedStartMonth = value!;
                    controller.update();
                  },
                ),
                const SizedBox(height: 16.0),
                _buildDateTimePicker(
                  labelText: 'End Date',
                  onChanged: (value) {
                    controller.selectedEndMonth = value!;
                    controller.update();
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Description', value),
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: null,
                  controller: controller.descriptionController,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Add Photo'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _rmImage,
                  child: const Text('Remove Photo'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _validateDates()) {
                      _saveExperience();
                      if (kDebugMode) {
                        print("back to loop");
                      }
                      Get.back();
                      if (kDebugMode) {
                        print("we back");
                      } // Close the form
                    }
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initializeFormFields() {
    if (existingExperience != null) {
      controller.titleController.text = existingExperience!.title;
      controller.descriptionController.text = existingExperience!.description;
      controller.selectedStartMonth = existingExperience!.startDate.month;
      controller.selectedStartYear = existingExperience!.startDate.year;
      controller.selectedEndMonth = existingExperience!.endDate.month;
      controller.selectedEndYear = existingExperience!.endDate.year;
      controller.selectedImage = existingExperience!.image;
    }
  }

  _pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 1024,
          maxWidth: 1024);

      if (pickedImage != null) {
        imageUploading.value = true;
        if (kDebugMode) {
          print("UPLOADING UPLOADING");
        }
        final imageUrl = await userRepository.uploadImage(
            'Users/Images/Experiences/', pickedImage);
        controller.selectedImage = imageUrl;
        controller.update();
        if (kDebugMode) {
          print(controller.selectedImage);
        }
        // update image save record
        TLoaders.successSnackBar(
            title: 'Congratulations', message: 'Your photo has been updated!');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Oh Snap!', message: 'Something went wrong: $e');
    } finally {
      // controller2.imageUploading.value = false;
    }
  }

  _rmImage() async {
    try {
      controller.selectedImage = "";
      controller.update();
      if (kDebugMode) {
        print(controller.selectedImage);
      }
      // update image save record
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your photo has been deleted!');
    } catch (e) {
      if (kDebugMode) {
        print("NOOO");
      }
    }
  }

  String generateRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join('');
  }

  final String clientId = '780imtdft3lmi0';
  final String clientSecret = '6pjJWhW6RSIL9zKn';
  final String redirectUri = 'https://starfolio.page.link/V9Hh';

  void _authenticateWithLinkedIn() async {
    final String state = generateRandomString(16);
    final String authUrl = 'https://www.linkedin.com/oauth/v2/authorization?'
        'response_type=code&client_id=$clientId&redirect_uri=$redirectUri&state=$state&'
        'scope=r_liteprofile%20r_emailaddress%20w_member_social';

    try {
      final result = await FlutterWebAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: 'starfolio',
      );

      final Uri deepLink = Uri.parse(result);
      final String? code = deepLink.queryParameters['code'];

      if (code != null) {
        await _handleLinkedInAuth(code);
      } else {
        throw Exception('No code received from LinkedIn');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during LinkedIn OAuth: $e');
      }
      Get.snackbar('Error', 'Failed to authenticate with LinkedIn: $e');
    }
  }

  Future<void> _handleLinkedInAuth(String code) async {
    final String accessTokenUrl = 'https://www.linkedin.com/oauth/v2/accessToken';
    try {
      final response = await http.post(
        Uri.parse(accessTokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final tokenData = json.decode(response.body);
        final String accessToken = tokenData['access_token'];
        await _fetchLinkedInProfile(accessToken);
      } else {
        throw Exception('Failed to obtain access token: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching LinkedIn access token: $e');
      }
      Get.snackbar('Error', 'Failed to obtain LinkedIn access token: $e');
    }
  }

  Future<void> _fetchLinkedInProfile(String accessToken) async {
    final profileUrl = 'https://api.linkedin.com/v2/me';
    final profileResponse = await http.get(
      Uri.parse(profileUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    final profileData = json.decode(profileResponse.body);
    final String firstName = profileData['localizedFirstName'];
    final String lastName = profileData['localizedLastName'];

    final emailUrl = 'https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))';
    final emailResponse = await http.get(
      Uri.parse(emailUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    final emailData = json.decode(emailResponse.body);
    final String email = emailData['elements'][0]['handle~']['emailAddress'];

    if (kDebugMode) {
      print('First Name: $firstName, Last Name: $lastName, Email: $email');
    }

    // Here you can populate the form fields with the LinkedIn profile data
  }

  void _saveExperience() {
    String title = controller.titleController.text.trim();
    String description = controller.descriptionController.text.trim();
    DateTime startDate = DateTime(controller.selectedStartYear, controller.selectedStartMonth);
    DateTime endDate = DateTime(controller.selectedEndYear, controller.selectedEndMonth);
    String image = controller.selectedImage;

    Experience experience = Experience(
      title: title,
      startDate: startDate,
      endDate: endDate,
      description: description,
      image: image,
      // Handle image logic as needed
      categoryIndex: categoryIndex,
    );

    if (existingExperience == null) {
      controller.addExperience(experience, categoryIndex);
    } else {
      controller.editExperience(existingExperience!, experience);
    }
    if (kDebugMode) {
      print("experience saved");
    }
  }

  bool _validateDates() {
    DateTime startDate = DateTime(controller.selectedStartYear, controller.selectedStartMonth);
    DateTime endDate = DateTime(controller.selectedEndYear, controller.selectedEndMonth);
    if (kDebugMode) {
      print('Start Date: $startDate');
    }
    if (kDebugMode) {
      print('End Date: $endDate');
    }
    if (startDate.isAfter(endDate)) {
      Get.snackbar('Error', 'Start date must be before or equal to end date');
      return false;
    }
    return true;
  }

  Widget _buildDateTimePicker({required String labelText, required Function(int?) onChanged}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)), // Add border radius
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              items: _buildMonthDropdownItems(),
              onChanged: onChanged,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Month'),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: DropdownButtonFormField<int>(
              items: _buildYearDropdownItems(),
              onChanged: (int? value) {
                // Handle year selection
                if (value != null) {
                  if (labelText.contains('Start')) {
                    controller.selectedStartYear = value;
                  } else if (labelText.contains('End')) {
                    controller.selectedEndYear = value;
                  }
                  controller.update(); // This will trigger a rebuild of the GetX widgets if needed
                }
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Year'),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildMonthDropdownItems() {
    return List<DropdownMenuItem<int>>.generate(
      12,
          (index) =>
          DropdownMenuItem(
            value: index + 1,
            child: Text(_getMonthName(index + 1)),
          ),
    );
  }

  List<DropdownMenuItem<int>> _buildYearDropdownItems() {
    final currentYear = DateTime.now().year;
    final years = List.generate(21, (index) => currentYear - index);
    return years
        .map((year) => DropdownMenuItem(value: year, child: Text('$year')))
        .toList();
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

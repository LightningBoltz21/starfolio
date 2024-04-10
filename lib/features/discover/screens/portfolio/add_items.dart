import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../../utils/validators/validation.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controllers/portfolio_controller.dart';
import '../../models/experience.dart';

class AddItems extends StatelessWidget {
  final int categoryIndex;
  final PortfolioController controller;
  final Experience? existingExperience;
  final userRepository = Get.put(UserRepository());
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(); // Add a GlobalKey for the form
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

  void _saveExperience() {
    String title = controller.titleController.text.trim();
    String description = controller.descriptionController.text.trim();
    DateTime startDate =
    DateTime(controller.selectedStartYear, controller.selectedStartMonth);
    DateTime endDate =
    DateTime(controller.selectedEndYear, controller.selectedEndMonth);
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
    DateTime startDate =
    DateTime(controller.selectedStartYear, controller.selectedStartMonth);
    DateTime endDate =
    DateTime(controller.selectedEndYear, controller.selectedEndMonth);
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

// Include your _buildDateTimePicker, _buildMonthDropdownItems, _buildYearDropdownItems, _getMonthName methods here
  Widget _buildDateTimePicker(
      {required String labelText, required Function(int?) onChanged}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0)), // Add border radius
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
                  controller
                      .update(); // This will trigger a rebuild of the GetX widgets if needed
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
    final currentYear = DateTime
        .now()
        .year;
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

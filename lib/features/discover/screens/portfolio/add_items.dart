import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/portfolio_controller.dart';
import '../../models/experience.dart';

class AddItems extends StatelessWidget {
  final int categoryIndex;
  final PortfolioController controller;
  final Experience? existingExperience;

  AddItems({
    Key? key,
    required this.categoryIndex,
    required this.controller,
    this.existingExperience,
  }) : super(key: key);

  void _initializeFormFields() {
    if (existingExperience != null) {
      controller.titleController.text =
          existingExperience!.title; // Use '!' for null check
      controller.descriptionController.text = existingExperience!.description;
      // Set the date fields accordingly
      controller.selectedStartMonth = existingExperience!.startDate.month;
      controller.selectedStartYear = existingExperience!.startDate.year;
      controller.selectedEndMonth = existingExperience!.endDate.month;
      controller.selectedEndYear = existingExperience!.endDate.year;
    }
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
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
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: null,
                controller: controller.descriptionController,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement functionality to add a photo
                  _pickImage();
                },
                child: const Text('Add Photo'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  String title = controller.titleController.text.trim();
                  String description = controller.descriptionController.text.trim();
                  DateTime startDate = DateTime(controller.selectedStartYear, controller.selectedStartMonth);
                  DateTime endDate = DateTime(controller.selectedEndYear, controller.selectedEndMonth);

                  Experience experience = Experience(// Use the existing ID if updating, else leave blank for a new experience
                    title: title,
                    startDate: startDate,
                    endDate: endDate,
                    description: description,
                    image: '',  // Add logic for handling images if necessary
                    categoryIndex: categoryIndex,
                  );

                  if (existingExperience == null) {
                    // Add a new experience
                    controller.addExperience(experience, categoryIndex);
                  } else {
                    // Update an existing experience
                    controller.editExperience(existingExperience!, experience);
                  }

                  Get.back();  // Close the form
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              onChanged: (value) {
                // Handle year selection
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
          (index) => DropdownMenuItem(
        value: index + 1,
        child: Text('${_getMonthName(index + 1)}'),
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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Assuming you have a method in your controller to update the image of an experience
      controller.updateExperienceImage(categoryIndex, existingExperience, image.path);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../models/experience.dart';
import '../screens/portfolio/widgets/category.dart';

class PortfolioController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int selectedStartMonth = DateTime.now().month;
  int selectedStartYear = DateTime.now().year;
  int selectedEndMonth = DateTime.now().month;
  int selectedEndYear = DateTime.now().year;

  final items = <Category>[].obs;
  final RxList<Experience> experiences = <Experience>[].obs;

  void addExperience(Experience newExperience, int categoryIndex) {// Assign the category index
    experiences.add(newExperience);
  }

  void addItem(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              SizedBox(
                width: 400, // Set your desired width here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Create New Category",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Reduced space between text input and buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: textFieldController,
                        decoration: const InputDecoration(
                          hintText: "ENTER CATEGORY NAME",
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Add space between text input and buttons
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between buttons
                          Expanded(
                            child: TextButton(
                              child: const Text("Done"),
                              onPressed: () {
                                String categoryName = textFieldController.text;
                                if (categoryName.trim().isNotEmpty) {
                                  int newIndex = items
                                      .length; // Get the index for the new item
                                  items.add(Category(
                                    name: categoryName, index: newIndex, portfolioController: this,));
                                  update();
                                }
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add space between buttons and the SizedBox
                    const SizedBox(height: 5),
                    // Add a small SizedBox below the row with the buttons
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void renameItem(BuildContext context, int index) {
    TextEditingController textFieldController = TextEditingController();
    textFieldController.text =
        items[index].name; // Pre-fill the text field with the current name
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              Container(
                width: 400, // Set your desired width here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Edit Category",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Reduced space between text input and buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: textFieldController,
                        decoration: const InputDecoration(
                          hintText: "ENTER CATEGORY NAME",
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Add space between text input and buttons
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between buttons
                          Expanded(
                            child: TextButton(
                              child: const Text("Done"),
                              onPressed: () {
                                String categoryName = textFieldController.text;
                                if (categoryName.trim().isNotEmpty) {
                                  // Update the name of the EditableListItem at the specified index
                                  items[index] = Category(
                                    name: categoryName, index: index, portfolioController: this,);
                                  update(); // Update the UI
                                }
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add space between buttons and the SizedBox
                    const SizedBox(height: 5),
                    // Add a small SizedBox below the row with the buttons
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void removeItem(int index) {
    // Remove the category from the items list
    items.removeAt(index);

    // Remove all experiences associated with the category being deleted
    experiences.removeWhere((experience) => experience.categoryIndex == index);

    // After removing the category and its experiences, you need to update the categoryIndex
    // for the remaining experiences to reflect their new positions.
    for (int i = 0; i < experiences.length; i++) {
      if (experiences[i].categoryIndex > index) {
        experiences[i] = Experience(
          title: experiences[i].title,
          startDate: experiences[i].startDate,
          endDate: experiences[i].endDate,
          description: experiences[i].description,
          image: experiences[i].image,
          categoryIndex: experiences[i].categoryIndex - 1, // Decrement the index
        );
      }
    }

    // Similarly, update the indices for the remaining categories to reflect their new positions
    for (int i = index; i < items.length; i++) {
      items[i] = Category(
        name: items[i].name,
        index: i, // Update the index
        portfolioController: this,
      );
    }

    // Notify listeners to update the UI
    update();
  }

  void removeExperience(Experience experience) {
    experiences.remove(experience);
    update();
  }

  void editExperience(Experience oldExperience, Experience newExperience) {
    int index = experiences.indexOf(oldExperience);
    if (index != -1) {
      experiences[index] = newExperience;
      update();
    }
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:starfolio/utils/popups/loaders.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../models/category_model.dart';
import '../models/experience.dart';


class PortfolioController extends GetxController {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int selectedStartMonth = DateTime.now().month;
  int selectedStartYear = DateTime.now().year;
  int selectedEndMonth = DateTime.now().month;
  int selectedEndYear = DateTime.now().year;
  String selectedImage = "";

  final imageUploading = false.obs;
  final RxList<CategoryModel> items = <CategoryModel>[].obs;
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
                width: 400,
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: textFieldController,
                        decoration: const InputDecoration(
                          hintText: "ENTER CATEGORY NAME",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          const SizedBox(width: 10), // Add spacing between buttons
                          Expanded(
                            child: TextButton(
                              child: const Text("Done"),
                              onPressed: () {
                                String categoryName = textFieldController.text;
                                if (categoryName.trim().isNotEmpty) {
                                  items.add(CategoryModel(name: categoryName, index: items.length));
                                  update();
                                }
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
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
              SizedBox(
                width: 400,
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
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
                          const SizedBox(width: 10), // Add spacing between buttons
                          Expanded(
                            child: TextButton(
                              child: const Text("Done"),
                              onPressed: () {
                                String categoryName = textFieldController.text;
                                if (categoryName.trim().isNotEmpty) {
                                  // Update the name of the EditableListItem at the specified index
                                  items[index] = CategoryModel(
                                    name: categoryName, index: index);
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

    // After removing the category and its experiences, update the categoryIndex
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
      items[i] = CategoryModel(
        name: items[i].name,
        index: i, // Update the index
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

  Future<void> savePortfolioData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference userCategoriesRef = FirebaseFirestore.instance
          .collection('Users').doc(userId).collection('categories');

      // Start a batch write
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Step 1: Schedule deletion of existing categories and their experiences
      QuerySnapshot existingCategoriesSnapshot = await userCategoriesRef.get();
      for (var categoryDoc in existingCategoriesSnapshot.docs) {
        QuerySnapshot experiencesSnapshot = await categoryDoc.reference
            .collection('experiences').get();
        for (var experienceDoc in experiencesSnapshot.docs) {
          // Schedule deletion of each experience
          batch.delete(experienceDoc.reference);
        }

        // Schedule deletion of the category
        batch.delete(categoryDoc.reference);
      }

      // Step 2: Schedule addition of new categories and their experiences
      for (final category in items) {
        DocumentReference categoryDocRef = userCategoriesRef
            .doc(); // Let Firestore generate the doc ID

        // Schedule addition of the category document
        batch.set(categoryDocRef, {
          'name': category.name,
          // Add other category fields as necessary
        });

        // Schedule addition of experiences for this category
        final categoryExperiences = experiences.where((exp) =>
        exp.categoryIndex == category.index).toList();
        for (final experience in categoryExperiences) {
          DocumentReference experienceDocRef = categoryDocRef.collection(
              'experiences').doc(); // Let Firestore generate the doc ID
          batch.set(experienceDocRef, {
            'title': experience.title,
            'startDate': experience.startDate,
            'endDate': experience.endDate,
            'description': experience.description,
            'image': experience.image
            // Include other experience fields as necessary
          });
        }
      }

      // Commit the batch once after all operations have been scheduled
      await batch.commit();
      TLoaders.successSnackBar(title: "Info Saved!");
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "SOMETHING WENT WRONG. PLEASE TRY AGAIN LATER";
    }
  }

  Future<void> fetchPortfolioData(String userId) async {
    if (kDebugMode) {
      print('Fetching portfolio data...');
    }
    try {
      CollectionReference userCategoriesRef = FirebaseFirestore.instance
          .collection('Users').doc(userId).collection('categories');

      // Clear existing data
      items.clear();
      experiences.clear();

      // Fetch categories
      QuerySnapshot categorySnapshot = await userCategoriesRef.get();
      if (kDebugMode) {
        print('Fetched ${categorySnapshot.docs.length} categories');
      }
      for (var categoryDoc in categorySnapshot.docs) {
        var categoryData = categoryDoc.data() as Map<String, dynamic>;
        CategoryModel category = CategoryModel(
            name: categoryData['name'], index: items.length);
        items.add(category);

        // Fetch experiences for this category
        QuerySnapshot experienceSnapshot = await categoryDoc.reference
            .collection('experiences').get();
        if (kDebugMode) {
          print('Fetched ${experienceSnapshot.docs.length} experiences for category ${category.name}');
        }
        for (var experienceDoc in experienceSnapshot.docs) {
          var experienceData = experienceDoc.data() as Map<String, dynamic>;
          Experience experience = Experience(
            title: experienceData['title'],
            startDate: (experienceData['startDate'] as Timestamp).toDate(),
            endDate: (experienceData['endDate'] as Timestamp).toDate(),
            description: experienceData['description'],
            image: experienceData['image'] as String? ?? '',
            categoryIndex: items.length - 1,
          );
          experiences.add(experience);
        }
      }

      // Notify listeners to update UI
      update();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('FAILURE TO FETCH DATA: ${e.message}');
      }
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('FAILURE TO FETCH DATA: ${e.message}');
      }
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      if (kDebugMode) {
        print('FAILURE TO FETCH DATA');
      }
      throw const TFormatException();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('FAILURE TO FETCH DATA: ${e.message}');
      }
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) {
        print('FAILURE TO FETCH DATA (platform exception)');
      }
      throw "SOMETHING WENT WRONG. PLEASE TRY AGAIN LATER";
    }
  }


}
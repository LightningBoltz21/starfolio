class Experience {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String image;
  final int categoryIndex; // Add a field to store the category index

  Experience({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.image,
    required this.categoryIndex,
  });
}

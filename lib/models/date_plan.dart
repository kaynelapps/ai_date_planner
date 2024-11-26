class DatePlan {
  final String title;
  final String description;
  final List<String> clues;
  final String imageAsset;
  final bool isFeatured;

  DatePlan({
    required this.title,
    required this.description,
    required this.clues,
    required this.imageAsset,
    this.isFeatured = false,
  });
}


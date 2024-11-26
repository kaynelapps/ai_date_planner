class Challenge {
  final String title;
  final String description;
  final int points;
  final bool isCompleted;
  final String imageUrl;
  final Function()? onTap;

  Challenge({
    required this.title,
    required this.description,
    required this.points,
    required this.isCompleted,
    required this.imageUrl,
    this.onTap,
  });
}

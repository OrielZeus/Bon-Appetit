class Restaurant {
  const Restaurant({
    required this.name,
    required this.category,
    required this.rating,
    required this.deliveryMinutes,
  });

  final String name;
  final String category;
  final double rating;
  final int deliveryMinutes;
}

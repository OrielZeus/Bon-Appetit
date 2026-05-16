class Restaurant {
  const Restaurant({
    required this.name,
    required this.category,
    required this.rating,
    required this.deliveryMinutes,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] as String? ?? 'Unnamed restaurant',
      category: json['category'] as String? ?? 'Restaurant',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      deliveryMinutes: (json['deliveryMinutes'] as num?)?.toInt() ?? 0,
    );
  }

  final String name;
  final String category;
  final double rating;
  final int deliveryMinutes;
}

class CatalogItem {
  const CatalogItem({
    required this.name,
    required this.category,
    required this.price,
    required this.assetPath,
    required this.badge,
  });

  final String name;
  final String category;
  final double price;
  final String assetPath;
  final String badge;
}

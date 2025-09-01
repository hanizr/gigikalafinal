class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final num rating;
  final String brand;
  final String category;
  final String thumbnail;
  final List images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'],
    title: j['title'] ?? '',
    description: j['description'] ?? '',
    price: j['price'] ?? 0,
    rating: j['rating'] ?? 0,
    brand: j['brand'] ?? '',
    category: j['category'] ?? '',
    thumbnail: j['thumbnail'] ?? '',
    images: j['images'] ?? [],
  );
}
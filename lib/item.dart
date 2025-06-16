// item.dart
class Item {
  String name; // Name of the item
  String category; // Category of the item (previously description)
  double price; // Price of the item
  String imageUrl; // URL of the item's image

  // Constructor
  Item({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}
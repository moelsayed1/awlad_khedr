class Items {
  final String id; // Unique identifier for each item
  final String image;
  final String name;
  final double price;
  final double quantity;
  int counter; // Counter for each item

  Items({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    this.counter = 0, // Initialize counter at 0
  });
}

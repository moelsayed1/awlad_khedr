class TopRatedModel {
  TopRatedModel({
    required this.products,
  });

  final List<Product> products;

  factory TopRatedModel.fromJson(Map<String, dynamic> json){
    return TopRatedModel(
      products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    );
  }

}

class Product {
  Product({
    required this.productId,
    required this.productName,
    required this.price,
    required this.qtyAvailable,
    required this.image,
    required this.imageUrl,
    required this.minimumSoldQuantity,
    required this.totalSold,
    this.categoryName,
  });

  final int? productId;
  final String? productName;
  final String? price;
  final String? qtyAvailable;
  final String? image;
  final String? imageUrl;
  final String? minimumSoldQuantity;
  final String? totalSold;
  final String? categoryName;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      productId: json["product_id"],
      productName: json["product_name"],
      price: json["price"],
      qtyAvailable: json["qty_available"],
      image: json["image"],
      imageUrl: json["image_url"],
      minimumSoldQuantity: json["minimum_sold_quantity"],
      totalSold: json["total_sold"],
      categoryName: json["category_name"],
    );
  }

}

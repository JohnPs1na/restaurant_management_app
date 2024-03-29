class ProductModel implements Comparable<dynamic> {
  late String name;
  late double price;
  late String category;

  ProductModel(
      {required this.name, required this.price, required this.category});

  ProductModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'category': category};
  }

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}

class ProductModule {
  String name, price;
  String? id;
  ProductModule({required this.name, required this.price, this.id});

  Map<String, dynamic> toJson() => {'name': name, 'price': price, '_id': id};
  factory ProductModule.fromJson(Map<String, dynamic> json) {
    return ProductModule(
        name: json['name'], price: json['price'], id: json['_id']);
  }
}

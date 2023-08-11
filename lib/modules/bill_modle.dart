class BillModule {
  String name, quantity, price;
  String? qrScan, qrTime, pay, id;
  BillModule(
      {required this.name,
      required this.quantity,
      required this.price,
      this.qrScan,
      this.qrTime,
      this.pay,
      this.id});

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'price': price,
        'qrScan': qrScan,
        'qrTime': qrTime,
        'pay': pay,
        'id': id
      };
  factory BillModule.fromJson(Map<String, dynamic> json) {
    return BillModule(
        id: json["_id"],
        name: json['name'],
        quantity: json['quantity'],
        price: json['price'],
        qrScan: json['qrScan'],
        qrTime: json['qrTime'],
        pay: json['pay']);
  }
}

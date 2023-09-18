class BillModule {
  String name, quantity, price;
  String? qrScan, qrTime, pay, id, pay1, pay2, pay3, qrdate, sub, user;

  BillModule(
      {required this.name,
      required this.quantity,
      required this.price,
      this.qrScan,
      this.qrTime,
      this.qrdate,
      this.pay,
      this.pay1,
      this.pay2,
      this.pay3,
      this.id,
      this.sub,
      this.user});

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'price': price,
        'qrScan': qrScan,
        'qrTime': qrTime,
        'qrdate': qrdate,
        'pay': pay,
        'pay1': pay1,
        'pay2': pay2,
        'pay3': pay3,
        'id': id,
        'sub': sub,
        'user': user,
      };
  factory BillModule.fromJson(Map<String, dynamic> json) {
    return BillModule(
      id: json["_id"],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      qrScan: json['qrScan'],
      qrTime: json['qrTime'],
      qrdate: json['qrdate'],
      pay: json['pay'],
      pay1: json['pay1'],
      pay2: json['pay2'],
      pay3: json['pay3'],
      sub: json['sub'],
      user: json['user'],
    );
  }
}

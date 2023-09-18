class PayModule {
  String pay;
  String date;

  PayModule({
    required this.pay,
    required this.date,
  });

  // factory PayModule.fromRawJson(String str) =>
  //     PayModule.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory PayModule.fromJson(Map<String, dynamic> json) => PayModule(
        pay: json["pay"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "pay": pay,
        "date": date,
      };
}

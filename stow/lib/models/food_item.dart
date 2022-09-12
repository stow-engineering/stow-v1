class FoodItem {
  int value;
  final String uid;
  final String? barcode;
  String name;
  DateTime? expDate;

  FoodItem({
    this.value = 0,
    this.uid = '',
    this.barcode = '',
    this.name = '',
    this.expDate,
  });

  FoodItem copyWith({
    int? value,
    String? uid,
    String? barcode,
    String? name,
    DateTime? expDate,
  }) {
    return FoodItem(
      value: value ?? this.value,
      uid: uid ?? this.uid,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      expDate: expDate ?? this.expDate,
    );
  }
}

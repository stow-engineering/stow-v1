class FoodItem {
  int value;
  final String uid;
  final String? barcode;
  String name;

  FoodItem({
    this.value = 0,
    this.uid = '',
    this.barcode = '',
    this.name = '',
  });

  FoodItem copyWith({
    int? value,
    String? uid,
    String? barcode,
    String? name,
  }) {
    return FoodItem(
      value: value ?? this.value,
      uid: uid ?? this.uid,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
    );
  }
}

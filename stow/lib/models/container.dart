class Container {
  final int value;
  final String uid;
  final String barcode;
  final bool full;
  final String user;
  final String size;
  final String name;

  Container(
      {this.value = 0,
      this.uid = '',
      this.barcode = '',
      this.full = true,
      this.user = '',
      this.name = '',
      this.size = 'Small'});

  Container copyWith(
      {int? value,
      String? uid,
      String? barcode,
      bool? full,
      String? user,
      String? name,
      String? size}) {
    return Container(
      value: value ?? this.value,
      uid: uid ?? this.uid,
      barcode: barcode ?? this.barcode,
      full: full ?? this.full,
      user: user ?? this.user,
      name: name ?? this.name,
      size: size ?? this.size,
    );
  }
}

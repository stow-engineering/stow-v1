import 'package:json_annotation/json_annotation.dart';

part 'grocery_item.g.dart';

@JsonSerializable()
class GroceryItem {
  int num;
  String name;
  bool checked;

  GroceryItem({this.num = 1, this.name = '', this.checked = false});

  GroceryItem copyWith({int? num, String? name, bool? checked}) {
    return GroceryItem(
        num: num ?? this.num,
        name: name ?? this.name,
        checked: checked ?? this.checked);
  }

  factory GroceryItem.fromJson(Map<String, dynamic> json) =>
      _$GroceryItemFromJson(json);

  Map<String, dynamic> toJson() => _$GroceryItemToJson(this);
}

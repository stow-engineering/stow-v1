// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroceryItem _$GroceryItemFromJson(Map<String, dynamic> json) => GroceryItem(
      num: json['num'] as int? ?? 1,
      name: json['name'] as String? ?? '',
      checked: json['checked'] as bool? ?? false,
    );

Map<String, dynamic> _$GroceryItemToJson(GroceryItem instance) =>
    <String, dynamic>{
      'num': instance.num,
      'name': instance.name,
      'checked': instance.checked,
    };

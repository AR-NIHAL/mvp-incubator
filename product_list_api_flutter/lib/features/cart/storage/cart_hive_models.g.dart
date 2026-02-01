// GENERATED CODE - DO NOT MODIFY BY HAND
// This file was added manually to make the project run without build_runner.

part of 'cart_hive_models.dart';

class HiveCartItemAdapter extends TypeAdapter<HiveCartItem> {
  @override
  final int typeId = 10;

  @override
  HiveCartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final fieldNum = reader.readByte();
      fields[fieldNum] = reader.read();
    }
    return HiveCartItem(
      productId: fields[0] as int,
      title: fields[1] as String,
      brand: fields[2] as String,
      imageUrl: fields[3] as String,
      price: (fields[4] as num).toDouble(),
      rating: (fields[5] as num).toDouble(),
      qty: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCartItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.qty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCartItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:objectbox/objectbox.dart';

@Entity()
class FuelEntity {
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime date;

  double? latitude;
  double? longitude;
  String? address;

  FuelEntity({
    this.latitude,
    this.longitude,
    this.address,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  @override
  toString() => 'FuelEntity{id: $id, date: $date}';
}

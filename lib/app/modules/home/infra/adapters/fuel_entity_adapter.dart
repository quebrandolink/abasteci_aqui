import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';

class FuelEntityAdapter {
  static FuelEntity fromJson(dynamic json) {
    return FuelEntity(
      uid: json["uid"]! as String,
      userId: json["userId"]! as String,
      address: json["address"]! as String,
      date: json["date"]!.toDate(),
      km: json["km"]! as int,
      latitude: json["latitude"]! as double,
      longitude: json["longitude"]! as double,
    );
  }

  static Map<String, dynamic> toJson(FuelEntity entity) {
    return <String, dynamic>{
      "userId": entity.userId,
      "address": entity.address,
      "date": entity.date,
      "km": entity.km,
      "latitude": entity.latitude,
      "longitude": entity.longitude,
    };
  }
}

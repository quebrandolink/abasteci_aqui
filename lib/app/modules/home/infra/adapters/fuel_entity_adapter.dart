import '../../domain/entities/fuel_entity.dart';

class FuelEntityAdapter {
  static FuelEntity fromJson(dynamic json) {
    return FuelEntity(
      uid: json["uid"]! as String,
      userId: json["userId"]! as String,
      date: json["date"]!.toDate(),
      address: json["address"] != null ? json["address"]! as String : "",
      latitude: json["latitude"] != null ? json["latitude"]! as double : 0,
      longitude: json["longitude"] != null ? json["longitude"]! as double : 0,
      km: json["km"] != null ? json["km"]! as int : 0,
      vehicle: json["vehicle"] != null ? json["vehicle"]! as String : "",
      liter: json["liter"] != null ? json["liter"]! as double : 0.0,
      valueLiter:
          json["valueLiter"] != null ? json["valueLiter"]! as double : 0.0,
    );
  }

  static Map<String, dynamic> toJson(FuelEntity entity) {
    return <String, dynamic>{
      "userId": entity.userId,
      "date": entity.date,
      "address": entity.address,
      "latitude": entity.latitude,
      "longitude": entity.longitude,
      "km": entity.km,
      "vehicle": entity.vehicle,
      "liter": entity.liter,
      "valueLiter": entity.valueLiter,
    };
  }
}

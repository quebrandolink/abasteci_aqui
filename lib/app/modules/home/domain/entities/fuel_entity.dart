// ignore_for_file: public_member_api_docs, sort_constructors_first
class FuelEntity {
  String uid;

  DateTime date;

  double? latitude;
  double? longitude;
  String? address;
  int? km;
  String? userId;
  String? vehicle;
  double? liter;
  double? valueLiter;

  FuelEntity({
    DateTime? date,
    this.uid = "",
    this.latitude = 0,
    this.longitude = 0,
    this.address = "",
    this.km = 0,
    this.userId,
    this.vehicle = "",
    this.liter = 0.0,
    this.valueLiter = 0.0,
  }) : date = date ?? DateTime.now();

  @override
  String toString() {
    return 'uid: $uid, date: $date, latitude: $latitude, longitude: $longitude, address: $address, km: $km, userId: $userId, vehicle: $vehicle, liter: $liter, valueLiter: $valueLiter';
  }
}

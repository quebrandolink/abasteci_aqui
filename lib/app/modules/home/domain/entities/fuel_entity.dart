class FuelEntity {
  String uid;

  DateTime date;

  double? latitude;
  double? longitude;
  String? address;
  int? km;
  String? userId;

  FuelEntity({
    this.uid = "",
    this.latitude = 0,
    this.longitude = 0,
    this.address,
    this.km,
    this.userId,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  @override
  String toString() {
    return 'uid: $uid, date: $date, latitude: $latitude, longitude: $longitude, address: $address, km: $km, userId: $userId';
  }
}

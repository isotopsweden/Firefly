class Car {
  final String type;
  final List<String> passengers;

  Car({this.type, this.passengers});

  @override
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      type: json['type'],
      passengers: (json['passangers'] ?? []).cast<String>(),
    );
  }
}

class Fireflyfly {
  final String name;
  final int age;

  Fireflyfly({this.name, this.age});

  @override
  factory Fireflyfly.fromJson(Map<String, dynamic> json) {
    return Fireflyfly(
      name: json['name'],
      age: json['age'],
    );
  }
}

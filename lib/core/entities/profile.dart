// lib/core/entities/profile.dart
class Profile {
  final String name;
  final int age;
  final double weight; // kg
  final double height; // cm

  const Profile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
  });

  Profile copyWith({String? name, int? age, double? weight, double? height}) =>
      Profile(
        name: name ?? this.name,
        age: age ?? this.age,
        weight: weight ?? this.weight,
        height: height ?? this.height,
      );

  /// IMC calculado localmente — O(1)
  double get imc => weight / ((height / 100) * (height / 100));
}

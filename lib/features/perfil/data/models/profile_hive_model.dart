// lib/features/perfil/data/models/profile_hive_model.dart
import 'package:hive/hive.dart';
import '../../../../core/entities/profile.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 0)
class ProfileHiveModel extends HiveObject {
  @HiveField(0) String name;
  @HiveField(1) int age;
  @HiveField(2) double weight;
  @HiveField(3) double height;

  ProfileHiveModel({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
  });

  factory ProfileHiveModel.fromEntity(Profile p) =>
      ProfileHiveModel(name: p.name, age: p.age, weight: p.weight, height: p.height);

  Profile toEntity() =>
      Profile(name: name, age: age, weight: weight, height: height);
}

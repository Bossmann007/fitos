// lib/features/treinos/data/models/exercise_hive_model.dart
import 'package:hive/hive.dart';
import '../../../../core/entities/exercise.dart';

part 'exercise_hive_model.g.dart';

@HiveType(typeId: 3)
class ExerciseHiveModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String category;
  @HiveField(3) String modality;
  @HiveField(4) bool isCustom;

  ExerciseHiveModel({
    required this.id,
    required this.name,
    required this.category,
    required this.modality,
    required this.isCustom,
  });

  factory ExerciseHiveModel.fromEntity(Exercise e) => ExerciseHiveModel(
        id: e.id, name: e.name, category: e.category,
        modality: e.modality, isCustom: e.isCustom,
      );

  Exercise toEntity() => Exercise(
        id: id, name: name, category: category,
        modality: modality, isCustom: isCustom,
      );
}

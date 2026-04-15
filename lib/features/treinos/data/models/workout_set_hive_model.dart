// lib/features/treinos/data/models/workout_set_hive_model.dart
import 'package:hive/hive.dart';
import '../../../../core/entities/workout_set.dart';

part 'workout_set_hive_model.g.dart';

@HiveType(typeId: 2)
class WorkoutSetHiveModel extends HiveObject {
  @HiveField(0) String exerciseId;
  @HiveField(1) String exerciseName;
  @HiveField(2) int sets;
  @HiveField(3) int reps;
  @HiveField(4) double weight;
  @HiveField(5) int restSeconds;

  WorkoutSetHiveModel({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restSeconds,
  });

  factory WorkoutSetHiveModel.fromEntity(WorkoutSet s) => WorkoutSetHiveModel(
        exerciseId: s.exerciseId,
        exerciseName: s.exerciseName,
        sets: s.sets,
        reps: s.reps,
        weight: s.weight,
        restSeconds: s.restSeconds,
      );

  WorkoutSet toEntity() => WorkoutSet(
        exerciseId: exerciseId,
        exerciseName: exerciseName,
        sets: sets,
        reps: reps,
        weight: weight,
        restSeconds: restSeconds,
      );
}

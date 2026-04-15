// lib/features/treinos/data/models/workout_hive_model.dart
import 'package:hive/hive.dart';
import '../../../../core/entities/workout.dart';
import 'workout_set_hive_model.dart';
import 'daily_log_hive_model.dart';

part 'workout_hive_model.g.dart';

@HiveType(typeId: 1)
class WorkoutHiveModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) DateTime date;
  @HiveField(2) String type;
  @HiveField(3) List<WorkoutSetHiveModel> sets;
  @HiveField(4) String? notes;
  @HiveField(5) int durationMinutes;
  @HiveField(6) DailyLogHiveModel? dailyLog;

  WorkoutHiveModel({
    required this.id,
    required this.date,
    required this.type,
    required this.sets,
    this.notes,
    required this.durationMinutes,
    this.dailyLog,
  });

  factory WorkoutHiveModel.fromEntity(Workout w) => WorkoutHiveModel(
        id: w.id,
        date: w.date,
        type: w.type,
        sets: w.sets.map(WorkoutSetHiveModel.fromEntity).toList(),
        notes: w.notes,
        durationMinutes: w.durationMinutes,
        dailyLog: w.dailyLog != null
            ? DailyLogHiveModel.fromEntity(w.dailyLog!)
            : null,
      );

  Workout toEntity() => Workout(
        id: id,
        date: date,
        type: type,
        sets: sets.map((s) => s.toEntity()).toList(),
        notes: notes,
        durationMinutes: durationMinutes,
        dailyLog: dailyLog?.toEntity(),
      );
}

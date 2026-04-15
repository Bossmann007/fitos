// lib/features/treinos/data/models/daily_log_hive_model.dart
import 'package:hive/hive.dart';
import '../../../../core/entities/daily_log.dart';

part 'daily_log_hive_model.g.dart';

@HiveType(typeId: 4)
class DailyLogHiveModel extends HiveObject {
  @HiveField(0) String date;
  @HiveField(1) int energia;
  @HiveField(2) int fadiga;

  DailyLogHiveModel({
    required this.date,
    required this.energia,
    required this.fadiga,
  });

  factory DailyLogHiveModel.fromEntity(DailyLog d) =>
      DailyLogHiveModel(date: d.date, energia: d.energia, fadiga: d.fadiga);

  DailyLog toEntity() =>
      DailyLog(date: date, energia: energia, fadiga: fadiga);
}

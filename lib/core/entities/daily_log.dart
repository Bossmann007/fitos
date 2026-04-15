// lib/core/entities/daily_log.dart
class DailyLog {
  final String date; // formato yyyy-MM-dd (chave do Hive)
  final int energia; // 1–10
  final int fadiga;  // 1–10

  const DailyLog({
    required this.date,
    required this.energia,
    required this.fadiga,
  });
}

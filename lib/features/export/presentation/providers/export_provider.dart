// lib/features/export/presentation/providers/export_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/entities/workout.dart';
import '../../domain/obsidian_formatter.dart';

final obsidianFormatterProvider = Provider((_) => ObsidianFormatter());

final exportProvider =
    Provider((ref) => ExportService(ref.read(obsidianFormatterProvider)));

class ExportService {
  final ObsidianFormatter _formatter;
  ExportService(this._formatter);

  /// Gera .md temporário e abre o iOS share sheet.
  /// O usuário escolhe onde salvar (Files → OneDrive → Mafioso).
  Future<void> exportWorkout(Workout workout) async {
    final content = _formatter.format(workout);
    final name = _formatter.fileName(workout);

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsString(content);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/markdown')],
      subject: name,
    );
  }
}

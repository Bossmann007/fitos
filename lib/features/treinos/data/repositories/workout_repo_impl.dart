import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import '../../../../core/entities/workout.dart';
import '../../../../core/entities/exercise.dart';
import '../../../../data/hive/hive_boxes.dart';
import '../../domain/repositories/workout_repository.dart';
import '../models/workout_hive_model.dart';
import '../models/exercise_hive_model.dart';

class WorkoutRepoImpl implements WorkoutRepository {
  // Armazenamento em memória para web
  static final List<Workout> _webWorkouts = [];
  static final List<Exercise> _webExercises = _defaultExercises();

  Box<WorkoutHiveModel> get _workouts =>
      Hive.box<WorkoutHiveModel>(HiveBoxes.workouts);
  Box<ExerciseHiveModel> get _exercises =>
      Hive.box<ExerciseHiveModel>(HiveBoxes.exercises);

  @override
  void saveWorkout(Workout workout) {
    if (kIsWeb) { _webWorkouts.insert(0, workout); return; }
    _workouts.put(workout.id, WorkoutHiveModel.fromEntity(workout));
  }

  /// Ordena por data descendente — O(n log n)
  @override
  List<Workout> getHistory() {
    if (kIsWeb) return List.unmodifiable(_webWorkouts);
    final list = _workouts.values.map((m) => m.toEntity()).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  List<Exercise> getExercises() {
    if (kIsWeb) return _webExercises;
    return _exercises.values.map((m) => m.toEntity()).toList();
  }

  static List<Exercise> _defaultExercises() => [
    const Exercise(id: '1',  name: 'Supino Reto',       category: 'Peito',      modality: 'Livre',         isCustom: false),
    const Exercise(id: '2',  name: 'Supino Inclinado',  category: 'Peito',      modality: 'Livre',         isCustom: false),
    const Exercise(id: '3',  name: 'Crucifixo',         category: 'Peito',      modality: 'Livre',         isCustom: false),
    const Exercise(id: '4',  name: 'Remada Curvada',    category: 'Costas',     modality: 'Livre',         isCustom: false),
    const Exercise(id: '5',  name: 'Puxada Frontal',    category: 'Costas',     modality: 'Máquina',       isCustom: false),
    const Exercise(id: '6',  name: 'Agachamento',       category: 'Pernas',     modality: 'Livre',         isCustom: false),
    const Exercise(id: '7',  name: 'Leg Press',         category: 'Pernas',     modality: 'Máquina',       isCustom: false),
    const Exercise(id: '8',  name: 'Desenvolvimento',   category: 'Ombro',      modality: 'Livre',         isCustom: false),
    const Exercise(id: '9',  name: 'Elevação Lateral',  category: 'Ombro',      modality: 'Livre',         isCustom: false),
    const Exercise(id: '10', name: 'Rosca Direta',      category: 'Braço',      modality: 'Livre',         isCustom: false),
    const Exercise(id: '11', name: 'Tríceps Pulley',    category: 'Braço',      modality: 'Máquina',       isCustom: false),
    const Exercise(id: '12', name: 'Prancha',           category: 'Core',       modality: 'Peso Corporal', isCustom: false),
    const Exercise(id: '13', name: 'Barra Fixa',        category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
    const Exercise(id: '14', name: 'Flexão de Braço',   category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
  ];
}

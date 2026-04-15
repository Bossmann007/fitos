// lib/data/hive/hive_init.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'hive_boxes.dart';
import '../../features/perfil/data/models/profile_hive_model.dart';
import '../../features/treinos/data/models/exercise_hive_model.dart';
import '../../features/treinos/data/models/workout_hive_model.dart';
import '../../features/treinos/data/models/workout_set_hive_model.dart';
import '../../features/treinos/data/models/daily_log_hive_model.dart';

class HiveInit {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Registra todos os adaptadores gerados pelo build_runner
    Hive.registerAdapter(ProfileHiveModelAdapter());
    Hive.registerAdapter(WorkoutHiveModelAdapter());
    Hive.registerAdapter(WorkoutSetHiveModelAdapter());
    Hive.registerAdapter(ExerciseHiveModelAdapter());
    Hive.registerAdapter(DailyLogHiveModelAdapter());

    // Abre todos os boxes
    await Hive.openBox<ProfileHiveModel>(HiveBoxes.profile);
    await Hive.openBox<ExerciseHiveModel>(HiveBoxes.exercises);
    await Hive.openBox<WorkoutHiveModel>(HiveBoxes.workouts);
    await Hive.openBox<DailyLogHiveModel>(HiveBoxes.dailyLogs);

    // Seed: popula exercícios pré-definidos na primeira execução
    await _seedExercisesIfEmpty();
  }

  static Future<void> _seedExercisesIfEmpty() async {
    final box = Hive.box<ExerciseHiveModel>(HiveBoxes.exercises);
    if (box.isNotEmpty) return; // já populado — O(1)

    const uuid = Uuid();
    final exercises = [
      // --- PEITO ---
      ExerciseHiveModel(id: uuid.v4(), name: 'Supino Reto',          category: 'Peito',      modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Supino Inclinado',     category: 'Peito',      modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Crucifixo',            category: 'Peito',      modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Peck Deck',            category: 'Peito',      modality: 'Máquina',       isCustom: false),
      // --- COSTAS ---
      ExerciseHiveModel(id: uuid.v4(), name: 'Remada Curvada',       category: 'Costas',     modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Puxada Frontal',       category: 'Costas',     modality: 'Máquina',       isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Remada Unilateral',    category: 'Costas',     modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Pullover',             category: 'Costas',     modality: 'Livre',         isCustom: false),
      // --- PERNAS ---
      ExerciseHiveModel(id: uuid.v4(), name: 'Agachamento',          category: 'Pernas',     modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Leg Press',            category: 'Pernas',     modality: 'Máquina',       isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Cadeira Extensora',    category: 'Pernas',     modality: 'Máquina',       isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Mesa Flexora',         category: 'Pernas',     modality: 'Máquina',       isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Panturrilha em Pé',    category: 'Pernas',     modality: 'Máquina',       isCustom: false),
      // --- OMBRO ---
      ExerciseHiveModel(id: uuid.v4(), name: 'Desenvolvimento',      category: 'Ombro',      modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Elevação Lateral',     category: 'Ombro',      modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Face Pull',            category: 'Ombro',      modality: 'Máquina',       isCustom: false),
      // --- BRAÇO ---
      ExerciseHiveModel(id: uuid.v4(), name: 'Rosca Direta',         category: 'Braço',      modality: 'Livre',         isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Tríceps Pulley',       category: 'Braço',      modality: 'Máquina',       isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Rosca Martelo',        category: 'Braço',      modality: 'Livre',         isCustom: false),
      // --- CORE ---
      ExerciseHiveModel(id: uuid.v4(), name: 'Abdominal Crunch',     category: 'Core',       modality: 'Peso Corporal', isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Prancha',              category: 'Core',       modality: 'Peso Corporal', isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Elevação de Pernas',   category: 'Core',       modality: 'Peso Corporal', isCustom: false),
      // --- CALISTENIA ---
      ExerciseHiveModel(id: uuid.v4(), name: 'Barra Fixa',           category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Paralela',             category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Flexão de Braço',      category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Agachamento Pistol',   category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'L-Sit',                category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Muscle-Up',            category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
      ExerciseHiveModel(id: uuid.v4(), name: 'Handstand Push-Up',    category: 'Calistenia', modality: 'Peso Corporal', isCustom: false),
    ];

    for (final exercise in exercises) {
      await box.put(exercise.id, exercise);
    }
  }
}

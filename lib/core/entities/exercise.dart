// lib/core/entities/exercise.dart
class Exercise {
  final String id;
  final String name;
  final String category; // Peito, Costas, Pernas, Ombro, Braço, Core, Calistenia
  final String modality; // Livre, Máquina, Calistenia, Peso Corporal
  final bool isCustom;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.modality,
    this.isCustom = false,
  });
}

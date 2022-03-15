const String tablePuzzles = 'puzzles';

class PuzzleFields {
  static final List<String> values = [
    id,
    name,
    difficulty,
    enabled
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String difficulty = 'difficulty';
  static const String enabled = 'enabled';
}

class Puzzle {
  final int? id;
  final String name;
  final int difficulty;
  final bool enabled;

  const Puzzle({
    this.id,
    required this.name,
    required this.difficulty,
    required this.enabled
  });

  Puzzle copy({
    int? id,
    String? name,
    int? difficulty,
    bool? enabled,
  }) =>
    Puzzle(
      id: id ?? this.id,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      enabled: enabled ?? this.enabled,
    );

    Map<String, Object?> toJson() => {
      PuzzleFields.id: id,
      PuzzleFields.name: name,
      PuzzleFields.difficulty: difficulty,
      PuzzleFields.enabled: enabled ? 1 : 0,
  };

  static Puzzle fromJson(Map<String, Object?> json) => Puzzle(
    id: json[PuzzleFields.id] as int?,
    name: json[PuzzleFields.name] as String,
    difficulty: json[PuzzleFields.difficulty] as int,
    enabled: json[PuzzleFields.enabled] == 1,
  );
}
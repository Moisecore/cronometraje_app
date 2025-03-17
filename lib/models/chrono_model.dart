enum ChronoState { stopped, running, paused }

/// Chrono Model (representa una instancia de un Chrono).
class ChronoModel {
  final int? id;
  final String name;
  final DateTime createdAt;
  final ChronoState state;
  final List<String> tags;

  ChronoModel({
    this.id,
    required this.name,
    required this.createdAt,
    this.state = ChronoState.stopped,
    this.tags = const ['Etiquetas'],
  });

  factory ChronoModel.fromMap(Map<String, dynamic> map) {
    return ChronoModel(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
      state: ChronoState.values[map['state']],
      tags: List<String>.from(map['tags'] ?? ['Etiquetas']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'state': state.index,
      'tags': tags,
    };
  }
}
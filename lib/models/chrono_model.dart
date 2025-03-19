enum ChronoState { detenido, andando, pausado } // En DB como: 0, 1, 2.

/// Chrono Model (representa una instancia de un Chrono).
class ChronoModel {
  final int? id;
  final String name;
  final DateTime createdAt;
  final ChronoState state;
  final List<String> tags;
  final int hidden; // Campo para soft-delete, 0: visible, 1: soft-deleted.

  ChronoModel({
    this.id,
    required this.name,
    required this.createdAt,
    this.state = ChronoState.detenido,
    this.tags = const [],
    this.hidden = 0
  });

  /// Crea un ChronoModel desde un Map de la base de datos.
  factory ChronoModel.fromMap(Map<String, dynamic> map) {
    return ChronoModel(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
      state: ChronoState.values[map['state']],
      tags: List<String>.from({map['tags']}), // Pendiente: modificar para implementación de etiquetas.
      hidden: map['hidden']
    );
  }

  /// Convierte un ChronoModel a un Map para guardar en la base de datos.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String,dynamic>{};
    if (id != null) {
      map['id'] = id;
    } else{
      map['name'] = name;
      map['createdAt'] = createdAt.toIso8601String();
      map['state'] = state.index;
      map['tags'] = tags.toString();
      map['hidden'] = hidden;
    }
    return map;
  }
}
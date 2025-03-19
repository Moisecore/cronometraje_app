/// Record Model (representa una instancia de un registro de tiempo).
class RecordModel {
  final int? id;
  final DateTime createdAt;
  final Duration recordedTime;
  final String? comment;
  final int hidden; // Campo para soft-delete, 0: visible, 1: soft-deleted.
  final int chronoId;

  RecordModel({
    this.id,
    required this.createdAt,
    required this.recordedTime,
    this.comment,
    this.hidden = 0,
    required this.chronoId,
  });

  /// Convierte un RecordModel a un Map para guardar en la base de datos.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String,dynamic>{};
    if (id != null) {
      map['id'] = id;
    } else {
      map['createdAt'] = createdAt.toIso8601String();
      map['recordedTime'] = recordedTime.inMilliseconds;
      map['comment'] = comment;
      map['hidden'] = hidden;
      map['chronoId'] = chronoId;
    }
    return map;
  }

  /// Crea un RecordModel desde un Map de la base de datos.
  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      recordedTime: Duration(milliseconds: map['recordedTime']),
      comment: map['comment'],
      hidden: map['hidden'],
      chronoId: map['chronoId'],
    );
  }
}

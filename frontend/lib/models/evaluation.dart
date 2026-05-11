class Evaluation {
  final int id;
  final int projectId;
  final int teacherId;
  final double? grade;
  final String? feedback;
  final DateTime createdAt;

  const Evaluation({
    required this.id,
    required this.projectId,
    required this.teacherId,
    this.grade,
    this.feedback,
    required this.createdAt,
  });

  // Project is approved if grade >= 6.0
  bool get isApproved => (grade ?? 0) >= 6.0;

  factory Evaluation.fromMap(Map<String, dynamic> map) => Evaluation(
        id: map['id'] as int,
        projectId: map['projeto_id'] as int,
        teacherId: map['professor_id'] as int,
        grade: map['nota'] != null ? (map['nota'] as num).toDouble() : null,
        feedback: map['feedback'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'projeto_id': projectId,
        'professor_id': teacherId,
        'nota': grade,
        'feedback': feedback,
        'created_at': createdAt.toIso8601String(),
      };
}
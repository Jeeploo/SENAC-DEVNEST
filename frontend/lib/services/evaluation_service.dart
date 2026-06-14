// ─── EVALUATION SERVICE (mock em memória) ─────────────────────────────────────
// Espelha a tabela `avaliacoes` do schema SQL.
// Trocar por chamadas REST na integração com backend.

class EvaluationEntry {
  final int id;
  final int projectId;
  final int teacherId;
  final String teacherName;
  final double grade;
  final String feedback;

  // Critérios da rubrica (0.0 – 10.0, passo 0.5)
  final double criterioMetodologia;
  final double criterioInovacao;
  final double criterioImplementacao;
  final double criterioDocumentacao;
  final double criterioApresentacao;

  final DateTime createdAt;

  const EvaluationEntry({
    required this.id,
    required this.projectId,
    required this.teacherId,
    required this.teacherName,
    required this.grade,
    required this.feedback,
    required this.criterioMetodologia,
    required this.criterioInovacao,
    required this.criterioImplementacao,
    required this.criterioDocumentacao,
    required this.criterioApresentacao,
    required this.createdAt,
  });

  bool get isApproved => grade >= 6.0;

  // DECIMAL(4,2) — ex: "7.50", "9.00"
  String get gradeFormatted => grade.toStringAsFixed(2);
}

class EvaluationService {
  static final List<EvaluationEntry> _store = [];
  static int _seq = 1;

  static List<EvaluationEntry> get all => List.unmodifiable(_store);

  static EvaluationEntry? forProject(int projectId) {
    try {
      return _store.firstWhere((e) => e.projectId == projectId);
    } catch (_) {
      return null;
    }
  }

  static List<EvaluationEntry> byTeacher(int teacherId) =>
      _store.where((e) => e.teacherId == teacherId).toList();

  static EvaluationEntry save({
    required int projectId,
    required int teacherId,
    required String teacherName,
    required double criterioMetodologia,
    required double criterioInovacao,
    required double criterioImplementacao,
    required double criterioDocumentacao,
    required double criterioApresentacao,
    required String feedback,
  }) {
    _store.removeWhere((e) => e.projectId == projectId);

    final grade = (criterioMetodologia +
            criterioInovacao +
            criterioImplementacao +
            criterioDocumentacao +
            criterioApresentacao) /
        5.0;

    final entry = EvaluationEntry(
      id: _seq++,
      projectId: projectId,
      teacherId: teacherId,
      teacherName: teacherName,
      grade: grade,
      feedback: feedback,
      criterioMetodologia: criterioMetodologia,
      criterioInovacao: criterioInovacao,
      criterioImplementacao: criterioImplementacao,
      criterioDocumentacao: criterioDocumentacao,
      criterioApresentacao: criterioApresentacao,
      createdAt: DateTime.now(),
    );
    _store.add(entry);
    return entry;
  }
}

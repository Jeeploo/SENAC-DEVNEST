// ─── INTEREST SERVICE (MOCK) ──────────────────────────────────────────────────
// Substitua por chamadas REST quando o backend estiver disponível:
//   POST  /api/interests                    → registerInterest
//   GET   /api/interests?empresa_id=X       → forEmpresa
//   GET   /api/interests?aluno_id=X         → forAluno

import '../models/interest.dart';

class InterestService {
  InterestService._();

  static final List<Interest> _interests = [
    Interest(
      id: 1,
      empresaId: 101,
      empresaNome: 'TechCorp Soluções',
      projetoId: 1,
      projetoTitulo: 'Sistema de Automação Residencial',
      alunoId: 1,
      date: DateTime(2024, 5, 10),
    ),
    Interest(
      id: 2,
      empresaId: 102,
      empresaNome: 'Inovação Digital',
      projetoId: 2,
      projetoTitulo: 'App de Gestão Acadêmica',
      alunoId: 1,
      date: DateTime(2024, 5, 15),
    ),
  ];
  static int _nextId = 3;

  /// Registra interesse de uma empresa num projeto de aluno.
  /// Idempotente: ignora se o par (empresaId, projetoId) já existe.
  /// TODO: substituir por POST /api/interests
  static void registerInterest({
    required int empresaId,
    required String empresaNome,
    required int projetoId,
    required String projetoTitulo,
    required int alunoId,
  }) {
    if (_interests.any(
        (i) => i.empresaId == empresaId && i.projetoId == projetoId)) {
      return;
    }
    _interests.add(Interest(
      id: _nextId++,
      empresaId: empresaId,
      empresaNome: empresaNome,
      projetoId: projetoId,
      projetoTitulo: projetoTitulo,
      alunoId: alunoId,
      date: DateTime.now(),
    ));
  }

  static bool hasInteresse(int empresaId, int projetoId) =>
      _interests.any((i) => i.empresaId == empresaId && i.projetoId == projetoId);

  /// TODO: substituir por GET /api/interests?empresa_id=X
  static List<Interest> forEmpresa(int empresaId) =>
      _interests.where((i) => i.empresaId == empresaId).toList();

  /// TODO: substituir por GET /api/interests?aluno_id=X
  static List<Interest> forAluno(int alunoId) =>
      _interests.where((i) => i.alunoId == alunoId).toList();
}

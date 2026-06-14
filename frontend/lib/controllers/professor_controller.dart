import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../services/evaluation_service.dart';
import '../utils/app_session.dart';

enum ProfFilter { all, pending, evaluated }

class ProfessorController extends ChangeNotifier {
  final List<Project> _projects = List.from(kProjectsMock);
  ProfFilter _filter = ProfFilter.all;
  String? _turma;

  ProfFilter get filter => _filter;
  String? get turma => _turma;

  List<String> get turmas {
    final t = _projects
        .map((p) => p.classGroupName ?? '')
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return t;
  }

  List<Project> get _active =>
      _projects.where((p) => p.status != ProjectStatus.draft).toList();

  List<Project> get filteredProjects {
    var list = _active;
    if (_turma != null) {
      list = list.where((p) => p.classGroupName == _turma).toList();
    }
    switch (_filter) {
      case ProfFilter.all:
        return list;
      case ProfFilter.pending:
        return list
            .where((p) => p.status == ProjectStatus.submitted)
            .toList();
      case ProfFilter.evaluated:
        return list
            .where((p) => p.status == ProjectStatus.evaluated)
            .toList();
    }
  }

  int get totalAll => _active.length;
  int get totalPending =>
      _active.where((p) => p.status == ProjectStatus.submitted).length;
  int get totalEvaluatedByMe =>
      EvaluationService.byTeacher(AppSession.userId).length;

  void setFilter(ProfFilter f) {
    _filter = f;
    notifyListeners();
  }

  void setTurma(String? t) {
    _turma = t;
    notifyListeners();
  }

  // Chamado após salvar avaliação para atualizar status do projeto na lista
  void markEvaluated(int projectId) {
    final idx = _projects.indexWhere((p) => p.id == projectId);
    if (idx == -1) return;
    _projects[idx] = _projects[idx].copyWith(status: ProjectStatus.evaluated);
    notifyListeners();
  }
}

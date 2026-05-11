import 'package:flutter/foundation.dart';
import '../models/project.dart';

enum AdminFilter { all, pending, evaluated, rejected }

class AdminController extends ChangeNotifier {
  List<Project> _projects = List.from(kProjectsMock);
  AdminFilter _filter = AdminFilter.all;

  AdminFilter get filter => _filter;

  List<Project> get _pending =>
      _projects.where((p) => p.status == ProjectStatus.submitted).toList();

  List<Project> get _evaluated =>
      _projects.where((p) => p.status == ProjectStatus.evaluated).toList();

  List<Project> get filteredProjects {
    switch (_filter) {
      case AdminFilter.all:
        return _projects.where((p) => p.status != ProjectStatus.draft).toList();
      case AdminFilter.pending:
        return _pending;
      case AdminFilter.evaluated:
        return _evaluated;
      case AdminFilter.rejected:
        return [];
    }
  }

  int get totalSubmissions =>
      _projects.where((p) => p.status != ProjectStatus.draft).length;

  int get totalPending   => _pending.length;
  int get totalEvaluated => _evaluated.length;

  void setFilter(AdminFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  // TODO: PUT /projects/:id/status + POST /evaluations { grade >= 6 }
  Future<void> approveProject(Project project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index == -1) return;
    _projects[index] = project.copyWith(status: ProjectStatus.evaluated);
    notifyListeners();
  }

  // TODO: PUT /projects/:id/status + POST /evaluations { grade < 6 }
  Future<void> rejectProject(Project project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index == -1) return;
    _projects[index] = project.copyWith(status: ProjectStatus.evaluated);
    notifyListeners();
  }

  void loadProjects(List<Project> projects) {
    _projects = projects;
    notifyListeners();
  }
}
// ─── USER SERVICE (MOCK) ─────────────────────────────────────────────────────
// Substitua por chamadas REST quando o backend estiver disponível:
//   GET    /api/users            → all / byProfile
//   PATCH  /api/users/:id        → toggleActive / updateTurma
// IMPORTANTE: o backend real nunca deve retornar campos de senha.

import '../models/user.dart';
import '../models/class_group.dart';

class UserService {
  UserService._();

  static final List<ClassGroup> mockTurmas = const [
    ClassGroup(id: 1, name: 'ADS 2024.1', period: '2024.1'),
    ClassGroup(id: 2, name: 'GTI 2024.1', period: '2024.1'),
    ClassGroup(id: 3, name: 'DS 2024.1', period: '2024.1'),
    ClassGroup(id: 4, name: 'ADS 2024.2', period: '2024.2'),
    ClassGroup(id: 5, name: 'GTI 2024.2', period: '2024.2'),
  ];

  // TODO: substituir seed por GET /api/users
  static final List<User> _users = [
    User(id: 1, name: 'Lucas Ferreira', email: 'lucas@devnest.com', password: '123456', profile: UserProfile.student, classGroupId: 1, course: 'ADS', createdAt: DateTime(2024, 1, 15), isActive: true),
    User(id: 2, name: 'Ana Beatriz Lima', email: 'aluno@devnest.com', password: '123456', profile: UserProfile.student, classGroupId: 1, course: 'ADS', createdAt: DateTime(2024, 1, 10), isActive: true),
    User(id: 3, name: 'Carlos Eduardo Santos', email: 'carlos@devnest.com', password: '123456', profile: UserProfile.student, classGroupId: 2, course: 'GTI', createdAt: DateTime(2024, 2, 3), isActive: true),
    User(id: 4, name: 'Mariana Oliveira', email: 'mariana@devnest.com', password: '123456', profile: UserProfile.student, classGroupId: 3, course: 'DS', createdAt: DateTime(2024, 1, 20), isActive: true),
    User(id: 5, name: 'Pedro Alves', email: 'pedro@devnest.com', password: '123456', profile: UserProfile.student, classGroupId: 4, course: 'GTI', createdAt: DateTime(2024, 1, 18), isActive: false),
    User(id: 6, name: 'Prof. Carlos Souza', email: 'professor@devnest.com', password: '123456', profile: UserProfile.teacher, createdAt: DateTime(2024, 1, 8), isActive: true),
    User(id: 7, name: 'Profa. Maria Santos', email: 'maria.prof@devnest.com', password: '123456', profile: UserProfile.teacher, createdAt: DateTime(2024, 1, 9), isActive: true),
    User(id: 8, name: 'Coordenador Silva', email: 'coordenador@devnest.com', password: '123456', profile: UserProfile.coordinator, createdAt: DateTime(2024, 1, 5), isActive: true),
    User(id: 101, name: 'TechVision Soluções', email: 'empresa@devnest.com', password: '123456', profile: UserProfile.company, institution: 'TechVision', createdAt: DateTime(2024, 2, 1), isActive: true),
    User(id: 102, name: 'InovaTech', email: 'inovatech@devnest.com', password: '123456', profile: UserProfile.company, institution: 'InovaTech', createdAt: DateTime(2024, 2, 5), isActive: true),
  ];

  static List<User> get all => List.unmodifiable(_users);

  static List<User> byProfile(UserProfile profile) =>
      _users.where((u) => u.profile == profile).toList();

  static ClassGroup? turmaById(int id) =>
      mockTurmas.where((t) => t.id == id).firstOrNull;

  static String turmaName(int? id) =>
      id == null ? '—' : (turmaById(id)?.name ?? '—');

  // TODO: substituir por PATCH /api/users/:id { ativo: bool }
  static void toggleActive(int id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx >= 0) _users[idx] = _users[idx].copyWith(isActive: !_users[idx].isActive);
  }

  // TODO: substituir por PATCH /api/users/:id { turma_id: int? }
  static void updateTurma(int userId, int? turmaId) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx >= 0) _users[idx] = _users[idx].copyWith(classGroupId: turmaId);
  }
}

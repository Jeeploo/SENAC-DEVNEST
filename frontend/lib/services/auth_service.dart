// ─── AUTH SERVICE (MOCK) ──────────────────────────────────────────────────────
// Credenciais de demonstração — não usar em produção.
// Substitua AuthService.login() por chamada real: POST /api/auth/login { email, senha }
// Em produção, o backend deve retornar um token JWT e NUNCA enviar a senha de volta.

import '../models/user.dart';

class AuthService {
  AuthService._();

  static final List<User> _mockUsers = [
    User(
      id: 2,
      name: 'Ana Beatriz Lima',
      email: 'aluno@devnest.com',
      password: '123456',
      profile: UserProfile.student,
      classGroupId: 1,
      course: 'ADS',
      createdAt: DateTime(2024, 1, 10),
      isActive: true,
    ),
    User(
      id: 6,
      name: 'Prof. Carlos Souza',
      email: 'professor@devnest.com',
      password: '123456',
      profile: UserProfile.teacher,
      createdAt: DateTime(2024, 1, 8),
      isActive: true,
    ),
    User(
      id: 8,
      name: 'Coordenador Silva',
      email: 'coordenador@devnest.com',
      password: '123456',
      profile: UserProfile.coordinator,
      createdAt: DateTime(2024, 1, 5),
      isActive: true,
    ),
    User(
      id: 101,
      name: 'TechVision Soluções',
      email: 'empresa@devnest.com',
      password: '123456',
      profile: UserProfile.company,
      institution: 'TechVision',
      createdAt: DateTime(2024, 2, 1),
      isActive: true,
    ),
  ];

  /// Valida credenciais e retorna o [User] ou null se inválido.
  /// TODO: substituir por POST /api/auth/login quando o backend estiver pronto
  static User? login(String email, String password) {
    try {
      return _mockUsers.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase().trim() &&
            u.password == password,
      );
    } catch (_) {
      return null;
    }
  }
}

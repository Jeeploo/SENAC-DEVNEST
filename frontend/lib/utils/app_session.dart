// ─── SESSÃO DO USUÁRIO ────────────────────────────────────────────────────────
// Armazena o perfil logado. Trocar por JWT/SharedPreferences na integração real.
class AppSession {
  AppSession._();

  static String _role = ''; // 'aluno' | 'professor' | 'coordenador' | 'empresa'
  static String _name = '';

  static String get role => _role;
  static String get name => _name;

  static void login({required String role, String name = ''}) {
    _role = role;
    _name = name;
  }

  static void logout() {
    _role = '';
    _name = '';
  }

  static bool get isAluno => _role == 'aluno';
  static bool get isAdmin => _role == 'coordenador';
  static bool get isProfessor => _role == 'professor';
  static bool get isEmpresa => _role == 'empresa';
  static bool get isLoggedIn => _role.isNotEmpty;
}

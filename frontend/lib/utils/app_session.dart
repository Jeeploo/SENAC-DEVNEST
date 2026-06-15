// ─── SESSÃO DO USUÁRIO ────────────────────────────────────────────────────────
// Armazena o perfil logado. Trocar por JWT/SharedPreferences na integração real.
import '../models/user.dart';

class AppSession {
  AppSession._();

  static String _role    = '';
  static String _name    = '';
  static String _email   = '';
  static int    _userId  = 0;
  static int?   _turmaId;

  static String get role    => _role;
  static String get name    => _name;
  static String get email   => _email;
  static int    get userId  => _userId;
  static int?   get turmaId => _turmaId;

  /// Popula a sessão a partir de um [User] autenticado.
  static void loginUser(User user) {
    _role    = user.profile.dbValue;
    _name    = user.name;
    _email   = user.email;
    _userId  = user.id;
    _turmaId = user.classGroupId;
  }

  static void logout() {
    _role    = '';
    _name    = '';
    _email   = '';
    _userId  = 0;
    _turmaId = null;
  }

  static bool get isAluno     => _role == 'aluno';
  static bool get isAdmin     => _role == 'coordenador';
  static bool get isProfessor => _role == 'professor';
  static bool get isEmpresa   => _role == 'empresa';
  static bool get isLoggedIn  => _role.isNotEmpty;
}

enum UserProfile { student, teacher, coordinator, company }

extension UserProfileExt on UserProfile {
  static UserProfile fromDb(String value) {
    switch (value) {
      case 'aluno':        return UserProfile.student;
      case 'professor':    return UserProfile.teacher;
      case 'coordenador':  return UserProfile.coordinator;
      case 'empresa':      return UserProfile.company;
      default:             return UserProfile.student;
    }
  }

  String get dbValue {
    switch (this) {
      case UserProfile.student:     return 'aluno';
      case UserProfile.teacher:     return 'professor';
      case UserProfile.coordinator: return 'coordenador';
      case UserProfile.company:     return 'empresa';
    }
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final UserProfile profile;
  final String? course;
  final String? institution;
  final String? profilePicture;
  final int? classGroupId;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.profile,
    this.course,
    this.institution,
    this.profilePicture,
    this.classGroupId,
    required this.createdAt,
  });

  // Initials for avatar (e.g. "Lucas Ferreira" -> "LF")
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return parts.first.substring(0, 2).toUpperCase();
  }

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as int,
        name: map['nome'] as String,
        email: map['email'] as String,
        password: map['senha'] as String,
        profile: UserProfileExt.fromDb(map['perfil'] as String),
        course: map['curso'] as String?,
        institution: map['instituicao'] as String?,
        profilePicture: map['foto_perfil'] as String?,
        classGroupId: map['turma_id'] as int?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': name,
        'email': email,
        'senha': password,
        'perfil': profile.dbValue,
        'curso': course,
        'instituicao': institution,
        'foto_perfil': profilePicture,
        'turma_id': classGroupId,
        'created_at': createdAt.toIso8601String(),
      };
}
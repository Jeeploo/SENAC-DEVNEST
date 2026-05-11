// ─── ProjectFile (arquivos_projeto) ──────────────────────────────────────────
class ProjectFile {
  final int id;
  final int projectId;
  final String? fileName;
  final String? filePath;
  final String? fileType;
  final DateTime createdAt;

  const ProjectFile({
    required this.id,
    required this.projectId,
    this.fileName,
    this.filePath,
    this.fileType,
    required this.createdAt,
  });

  factory ProjectFile.fromMap(Map<String, dynamic> map) => ProjectFile(
        id: map['id'] as int,
        projectId: map['projeto_id'] as int,
        fileName: map['nome_arquivo'] as String?,
        filePath: map['caminho_arquivo'] as String?,
        fileType: map['tipo_arquivo'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'projeto_id': projectId,
        'nome_arquivo': fileName,
        'caminho_arquivo': filePath,
        'tipo_arquivo': fileType,
        'created_at': createdAt.toIso8601String(),
      };
}

// ─── Comment (comentarios) ───────────────────────────────────────────────────
class Comment {
  final int id;
  final int projectId;
  final int userId;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> map) => Comment(
        id: map['id'] as int,
        projectId: map['projeto_id'] as int,
        userId: map['usuario_id'] as int,
        content: map['comentario'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'projeto_id': projectId,
        'usuario_id': userId,
        'comentario': content,
        'created_at': createdAt.toIso8601String(),
      };
}

// ─── Favorite (favoritos) ────────────────────────────────────────────────────
class Favorite {
  final int id;
  final int userId;
  final int projectId;

  const Favorite({
    required this.id,
    required this.userId,
    required this.projectId,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) => Favorite(
        id: map['id'] as int,
        userId: map['usuario_id'] as int,
        projectId: map['projeto_id'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'usuario_id': userId,
        'projeto_id': projectId,
      };
}

// ─── Technology (tecnologias) ─────────────────────────────────────────────────
class Technology {
  final int id;
  final String name;

  const Technology({required this.id, required this.name});

  factory Technology.fromMap(Map<String, dynamic> map) =>
      Technology(id: map['id'] as int, name: map['nome'] as String);

  Map<String, dynamic> toMap() => {'id': id, 'nome': name};
}

// ─── ActionHistory (historico_acoes) ─────────────────────────────────────────
class ActionHistory {
  final int id;
  final int userId;
  final String action;
  final String? description;
  final DateTime createdAt;

  const ActionHistory({
    required this.id,
    required this.userId,
    required this.action,
    this.description,
    required this.createdAt,
  });

  factory ActionHistory.fromMap(Map<String, dynamic> map) => ActionHistory(
        id: map['id'] as int,
        userId: map['usuario_id'] as int,
        action: map['acao'] as String,
        description: map['descricao'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'usuario_id': userId,
        'acao': action,
        'descricao': description,
        'created_at': createdAt.toIso8601String(),
      };
}
enum ProjectStatus { draft, submitted, evaluated }

extension ProjectStatusExt on ProjectStatus {
  String get label {
    switch (this) {
      case ProjectStatus.draft:      return 'Draft';
      case ProjectStatus.submitted:  return 'Pending';
      case ProjectStatus.evaluated:  return 'Evaluated';
    }
  }

  // Maps DB value (Portuguese) to enum
  static ProjectStatus fromDb(String value) {
    switch (value) {
      case 'rascunho':  return ProjectStatus.draft;
      case 'submetido': return ProjectStatus.submitted;
      case 'avaliado':  return ProjectStatus.evaluated;
      default:          return ProjectStatus.draft;
    }
  }

  // Maps enum back to DB value (Portuguese)
  String get dbValue {
    switch (this) {
      case ProjectStatus.draft:      return 'rascunho';
      case ProjectStatus.submitted:  return 'submetido';
      case ProjectStatus.evaluated:  return 'avaliado';
    }
  }
}

class Project {
  final int id;
  final int studentId;
  final String title;
  final String description;
  final String? technologies;
  final String? githubLink;
  final String? videoDemo;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Populated via JOIN with users and class_groups
  final String? studentName;
  final String? studentInitials;
  final String? classGroupName;

  const Project({
    required this.id,
    required this.studentId,
    required this.title,
    required this.description,
    this.technologies,
    this.githubLink,
    this.videoDemo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.studentName,
    this.studentInitials,
    this.classGroupName,
  });

  factory Project.fromMap(Map<String, dynamic> map) => Project(
        id: map['id'] as int,
        studentId: map['aluno_id'] as int,
        title: map['titulo'] as String,
        description: map['descricao'] as String,
        technologies: map['tecnologias'] as String?,
        githubLink: map['github_link'] as String?,
        videoDemo: map['video_demo'] as String?,
        status: ProjectStatusExt.fromDb(map['status'] as String),
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
        studentName: map['student_name'] as String?,
        studentInitials: map['student_initials'] as String?,
        classGroupName: map['class_group_name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'aluno_id': studentId,
        'titulo': title,
        'descricao': description,
        'tecnologias': technologies,
        'github_link': githubLink,
        'video_demo': videoDemo,
        'status': status.dbValue,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  Project copyWith({ProjectStatus? status}) => Project(
        id: id,
        studentId: studentId,
        title: title,
        description: description,
        technologies: technologies,
        githubLink: githubLink,
        videoDemo: videoDemo,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt,
        studentName: studentName,
        studentInitials: studentInitials,
        classGroupName: classGroupName,
      );
}

// Mock data — replace with real API calls when backend is ready
final List<Project> kProjectsMock = [
  Project(id: 1, studentId: 1, title: 'App de Monitoramento Ambiental', description: 'Aplicativo Flutter para monitoramento de dados ambientais.', technologies: 'Flutter, Dart, SQLite', status: ProjectStatus.submitted, createdAt: DateTime(2024, 4, 21), updatedAt: DateTime(2024, 4, 21), studentName: 'Lucas Ferreira', studentInitials: 'LF', classGroupName: 'ADS 2024.1'),
  Project(id: 2, studentId: 2, title: 'Plataforma de Tutoria Online', description: 'Sistema web para conexao entre tutores e alunos.', technologies: 'Flutter, Dart, MySQL', status: ProjectStatus.submitted, createdAt: DateTime(2024, 4, 19), updatedAt: DateTime(2024, 4, 19), studentName: 'Ana Beatriz Lima', studentInitials: 'AB', classGroupName: 'GTI 2024.1'),
  Project(id: 3, studentId: 3, title: 'Sistema de Gestao de Estoque', description: 'Controle de estoque com relatorios e alertas.', technologies: 'Flutter, Dart, MySQL', status: ProjectStatus.submitted, createdAt: DateTime(2024, 4, 17), updatedAt: DateTime(2024, 4, 17), studentName: 'Carlos Eduardo Santos', studentInitials: 'CE', classGroupName: 'ADS 2024.2'),
  Project(id: 4, studentId: 4, title: 'Rede Social para Adocao de Pets', description: 'Plataforma para conectar pets a novas familias.', technologies: 'Flutter, Dart, SQLite', status: ProjectStatus.evaluated, createdAt: DateTime(2024, 4, 14), updatedAt: DateTime(2024, 4, 14), studentName: 'Mariana Oliveira', studentInitials: 'MO', classGroupName: 'DS 2024.1'),
  Project(id: 5, studentId: 5, title: 'Dashboard Financeiro Pessoal', description: 'Controle de financas pessoais com graficos.', technologies: 'Flutter, Dart, SQLite', status: ProjectStatus.evaluated, createdAt: DateTime(2024, 4, 9), updatedAt: DateTime(2024, 4, 9), studentName: 'Pedro Alves', studentInitials: 'PA', classGroupName: 'GTI 2024.2'),
];
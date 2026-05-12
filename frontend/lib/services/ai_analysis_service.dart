// ─── AI ANALYSIS SERVICE ─────────────────────────────────────────────────────
class ProjectAnalysis {
  final double score;
  final String summary;
  final List<String> strengths;
  final List<String> improvements;
  final String complexity;
  final String badge;

  const ProjectAnalysis({
    required this.score,
    required this.summary,
    required this.strengths,
    required this.improvements,
    required this.complexity,
    required this.badge,
  });

  factory ProjectAnalysis.fromJson(Map<String, dynamic> json) =>
      ProjectAnalysis(
        score: (json['score'] as num).toDouble(),
        summary: json['summary'] as String,
        strengths: List<String>.from(json['strengths'] as List),
        improvements: List<String>.from(json['improvements'] as List),
        complexity: json['complexity'] as String,
        badge: json['badge'] as String,
      );
}

abstract class AiAnalysisService {
  Future<ProjectAnalysis> analyzeProject({
    required String title,
    required String description,
    required List<String> technologies,
    required String classGroup,
  });
}

class MockAiAnalysisService implements AiAnalysisService {
  @override
  Future<ProjectAnalysis> analyzeProject({
    required String title,
    required String description,
    required List<String> technologies,
    required String classGroup,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2200));
    return _generate(title, description, technologies);
  }

  ProjectAnalysis _generate(
    String title,
    String description,
    List<String> techs,
  ) {
    double score = 6.0;
    if (description.length > 80) {
      score += 0.8;
    }
    if (techs.length >= 3) {
      score += 0.7;
    }
    if (techs.length >= 5) {
      score += 0.5;
    }
    if (_modern(techs)) {
      score += 1.0;
    }
    if (_database(techs)) {
      score += 0.5;
    }
    score = score.clamp(5.0, 10.0);
    final s = (score * 2).round() / 2;
    return ProjectAnalysis(
      score: s,
      badge: s >= 9.0
          ? 'Excelente'
          : s >= 7.5
          ? 'Bom'
          : 'Regular',
      complexity: techs.length >= 5
          ? 'Avançado'
          : techs.length >= 3
          ? 'Intermediário'
          : 'Básico',
      summary:
          'O projeto "$title" demonstra bom entendimento dos conceitos trabalhados. '
          '${_mobile(techs) ? "A escolha de tecnologias mobile é adequada. " : ""}'
          '${description.length > 60 ? "A descrição é clara e objetiva. " : "A descrição poderia ser mais detalhada. "}'
          'Recomenda-se aprimorar documentação e testes para atingir excelência.',
      strengths: _strengths(techs, description),
      improvements: _improvements(techs, description),
    );
  }

  List<String> _strengths(List<String> techs, String desc) {
    final r = <String>[];
    if (techs.isNotEmpty) {
      r.add('Stack tecnológica bem definida: ${techs.take(3).join(", ")}');
    }
    if (desc.length > 60) {
      r.add('Descrição clara com objetivo bem definido');
    }
    if (_database(techs)) {
      r.add('Persistência de dados contemplada na arquitetura');
    }
    if (_modern(techs)) {
      r.add('Uso de tecnologias modernas e relevantes no mercado');
    }
    if (_mobile(techs)) {
      r.add('Desenvolvimento mobile aumenta o alcance da solução');
    }
    if (r.isEmpty) {
      r.add('Projeto com proposta funcional e aplicável');
    }
    return r.take(4).toList();
  }

  List<String> _improvements(List<String> techs, String desc) {
    final r = <String>[];
    if (!_database(techs)) {
      r.add('Considerar adicionar camada de persistência de dados');
    }
    if (techs.length < 3) {
      r.add('Expandir o stack com ferramentas complementares');
    }
    if (desc.length < 60) {
      r.add('Detalhar melhor o objetivo e metodologia do projeto');
    }
    r.add('Implementar testes automatizados para garantir qualidade');
    r.add('Adicionar documentação técnica (README e diagramas)');
    return r.take(4).toList();
  }

  bool _modern(List<String> t) => t.any(
    (x) => [
      'Flutter',
      'React',
      'Vue',
      'Next',
      'TypeScript',
      'Dart',
    ].any((m) => x.toLowerCase().contains(m.toLowerCase())),
  );

  bool _database(List<String> t) => t.any(
    (x) => [
      'SQL',
      'MySQL',
      'PostgreSQL',
      'Firebase',
      'MongoDB',
      'SQLite',
      'Supabase',
    ].any((d) => x.toLowerCase().contains(d.toLowerCase())),
  );

  bool _mobile(List<String> t) => t.any(
    (x) => [
      'Flutter',
      'React Native',
      'Kotlin',
      'Swift',
      'Android',
      'iOS',
    ].any((m) => x.toLowerCase().contains(m.toLowerCase())),
  );
}

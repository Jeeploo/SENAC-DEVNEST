// ─── AI ANALYSIS SERVICE ─────────────────────────────────────────────────────
class ProjectAnalysis {
  final double score;
  final String summary;
  final List<String> strengths;
  final List<String> improvements;
  final String complexity;
  final String badge;
  final Map<String, String> criterioFaixas;
  final Map<String, String> criterioSugestoes;

  const ProjectAnalysis({
    required this.score, required this.summary,
    required this.strengths, required this.improvements,
    required this.complexity, required this.badge,
    this.criterioFaixas = const {},
    this.criterioSugestoes = const {},
  });

  factory ProjectAnalysis.fromJson(Map<String, dynamic> json) => ProjectAnalysis(
    score:        (json['score'] as num).toDouble(),
    summary:      json['summary'] as String,
    strengths:    List<String>.from(json['strengths'] as List),
    improvements: List<String>.from(json['improvements'] as List),
    complexity:   json['complexity'] as String,
    badge:        json['badge'] as String,
  );
}

abstract class AiAnalysisService {
  Future<ProjectAnalysis> analyzeProject({
    required String title,
    required String description,
    required List<String> technologies,
    required String classGroup,
    String feedback,
  });
}

class MockAiAnalysisService implements AiAnalysisService {
  @override
  Future<ProjectAnalysis> analyzeProject({
    required String title,
    required String description,
    required List<String> technologies,
    required String classGroup,
    String feedback = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 2200));
    return _generate(title, description, technologies, feedback);
  }

  ProjectAnalysis _generate(String title, String description, List<String> techs, String feedback) {
    double score = 6.0;
    if (description.length > 80) { score += 0.8; }
    if (techs.length >= 3)       { score += 0.7; }
    if (techs.length >= 5)       { score += 0.5; }
    if (_modern(techs))          { score += 1.0; }
    if (_database(techs))        { score += 0.5; }
    score = score.clamp(5.0, 10.0);
    final s = (score * 2).round() / 2;
    return ProjectAnalysis(
      score: s,
      badge: s >= 9.0 ? 'Excelente' : s >= 7.5 ? 'Bom' : 'Regular',
      complexity: techs.length >= 5 ? 'Avançado' : techs.length >= 3 ? 'Intermediário' : 'Básico',
      summary: 'O projeto "$title" demonstra bom entendimento dos conceitos trabalhados. '
          '${_mobile(techs) ? "A escolha de tecnologias mobile é adequada. " : ""}'
          '${description.length > 60 ? "A descrição é clara e objetiva. " : "A descrição poderia ser mais detalhada. "}'
          'Recomenda-se aprimorar documentação e testes para atingir excelência.',
      strengths: _strengths(techs, description),
      improvements: _improvements(techs, description),
      criterioFaixas: _criterioFaixas(techs, description, feedback),
      criterioSugestoes: _criterioSugestoes(techs, description, feedback),
    );
  }

  List<String> _strengths(List<String> techs, String desc) {
    final r = <String>[];
    if (techs.isNotEmpty)    { r.add('Stack tecnológica bem definida: ${techs.take(3).join(", ")}'); }
    if (desc.length > 60)    { r.add('Descrição clara com objetivo bem definido'); }
    if (_database(techs))    { r.add('Persistência de dados contemplada na arquitetura'); }
    if (_modern(techs))      { r.add('Uso de tecnologias modernas e relevantes no mercado'); }
    if (_mobile(techs))      { r.add('Desenvolvimento mobile aumenta o alcance da solução'); }
    if (r.isEmpty)           { r.add('Projeto com proposta funcional e aplicável'); }
    return r.take(4).toList();
  }

  List<String> _improvements(List<String> techs, String desc) {
    final r = <String>[];
    if (!_database(techs))   { r.add('Considerar adicionar camada de persistência de dados'); }
    if (techs.length < 3)    { r.add('Expandir o stack com ferramentas complementares'); }
    if (desc.length < 60)    { r.add('Detalhar melhor o objetivo e metodologia do projeto'); }
    r.add('Implementar testes automatizados para garantir qualidade');
    r.add('Adicionar documentação técnica (README e diagramas)');
    return r.take(4).toList();
  }

  Map<String, String> _criterioFaixas(List<String> techs, String desc, String feedback) {
    final richDesc = desc.length > 60;
    final hasDb    = _database(techs);
    final hasMod   = _modern(techs);
    final hasFb    = feedback.length > 30;
    return {
      'Metodologia e Planejamento':   richDesc           ? '7–8' : '5–6',
      'Inovação e Criatividade':      hasMod             ? '7–9' : '5–7',
      'Implementação Técnica':        (hasMod && hasDb)  ? '8–9' : hasMod ? '7–8' : '5–7',
      'Qualidade da Documentação':    richDesc           ? '6–8' : '4–6',
      'Apresentação e Comunicação':   hasFb              ? '7–8' : '5–7',
    };
  }

  Map<String, String> _criterioSugestoes(List<String> techs, String desc, String feedback) {
    final richDesc = desc.length > 60;
    final hasDb    = _database(techs);
    final hasMod   = _modern(techs);
    final hasFb    = feedback.length > 30;
    return {
      'Metodologia e Planejamento': richDesc
          ? 'Planejamento bem estruturado; detalhar cronograma e riscos pode elevar a nota.'
          : 'Descreva melhor as etapas, metodologia e critérios de sucesso do projeto.',
      'Inovação e Criatividade': hasMod
          ? 'Uso de tecnologias modernas demonstra criatividade. Explore funcionalidades diferenciadas.'
          : 'Considere incorporar tecnologias ou abordagens mais atuais para agregar valor.',
      'Implementação Técnica': (hasMod && hasDb)
          ? 'Stack sólida com persistência. Incluir tratamento de erros e testes elevará ainda mais.'
          : hasDb
              ? 'Boa persistência de dados. Adote padrões de arquitetura (MVC/Clean) para organização.'
              : 'Adicione camada de persistência de dados e organize o código em camadas.',
      'Qualidade da Documentação': richDesc
          ? 'Descrição clara; adicione README, diagramas e instruções de instalação.'
          : 'Amplie a documentação: objetivo, arquitetura, fluxo de uso e tecnologias utilizadas.',
      'Apresentação e Comunicação': hasFb
          ? 'O feedback registrado fornece bons pontos de partida. Estruture a demo em torno deles.'
          : 'Prepare uma demonstração objetiva: problema, solução, principais funcionalidades e resultado.',
    };
  }

  bool _modern(List<String> t) => t.any((x) =>
      ['Flutter','React','Vue','Next','TypeScript','Dart']
          .any((m) => x.toLowerCase().contains(m.toLowerCase())));

  bool _database(List<String> t) => t.any((x) =>
      ['SQL','MySQL','PostgreSQL','Firebase','MongoDB','SQLite','Supabase']
          .any((d) => x.toLowerCase().contains(d.toLowerCase())));

  bool _mobile(List<String> t) => t.any((x) =>
      ['Flutter','React Native','Kotlin','Swift','Android','iOS']
          .any((m) => x.toLowerCase().contains(m.toLowerCase())));
}

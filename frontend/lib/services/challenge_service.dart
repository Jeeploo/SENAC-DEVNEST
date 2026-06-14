// ─── CHALLENGE SERVICE (mock em memória) ──────────────────────────────────────
// Espelha as tabelas `desafios` e `propostas` do schema SQL.
// Trocar por chamadas REST na integração com backend.

class Desafio {
  int id;
  int empresaId;
  String titulo;
  String descricao;
  String area;
  DateTime prazo;
  String dificuldade; // 'Iniciante' | 'Intermediário' | 'Avançado'
  bool publicado;

  Desafio({
    required this.id,
    required this.empresaId,
    required this.titulo,
    required this.descricao,
    required this.area,
    required this.prazo,
    required this.dificuldade,
    this.publicado = true,
  });
}

class Proposta {
  final int id;
  final int desafioId;
  final int alunoId;
  final String nomeAluno;
  final String descricaoSolucao;
  final DateTime dataEnvio;
  String status; // 'pendente' | 'aceita' | 'recusada'

  Proposta({
    required this.id,
    required this.desafioId,
    required this.alunoId,
    required this.nomeAluno,
    required this.descricaoSolucao,
    required this.dataEnvio,
    this.status = 'pendente',
  });
}

class ChallengeService {
  static final List<Desafio> _desafios = [
    Desafio(
      id: 1,
      empresaId: 101,
      titulo: 'Sistema de Monitoramento Ambiental',
      descricao:
          'Desenvolver solução IoT para monitoramento de temperatura, umidade e qualidade do ar em ambientes industriais, com dashboards em tempo real e alertas automáticos.',
      area: 'IoT / Hardware',
      prazo: DateTime(2025, 8, 30),
      dificuldade: 'Intermediário',
    ),
    Desafio(
      id: 2,
      empresaId: 101,
      titulo: 'App de Gestão de Tarefas com IA',
      descricao:
          'Criar aplicativo mobile que utilize IA para priorizar tarefas automaticamente, reconhecer padrões de produtividade e sugerir cronogramas personalizados.',
      area: 'Mobile / IA',
      prazo: DateTime(2025, 9, 15),
      dificuldade: 'Avançado',
    ),
    Desafio(
      id: 3,
      empresaId: 102,
      titulo: 'Plataforma de E-commerce Sustentável',
      descricao:
          'Desenvolver plataforma web de e-commerce focada em produtos sustentáveis, com rastreio de pegada de carbono e gamificação de compras ecológicas.',
      area: 'Web / E-commerce',
      prazo: DateTime(2025, 10, 1),
      dificuldade: 'Intermediário',
    ),
    Desafio(
      id: 4,
      empresaId: 102,
      titulo: 'API de Integração Bancária',
      descricao:
          'Construir API RESTful segura para integração com sistemas bancários, incluindo autenticação OAuth 2.0, rate limiting e logs de auditoria.',
      area: 'Backend / Fintech',
      prazo: DateTime(2025, 7, 31),
      dificuldade: 'Avançado',
    ),
    Desafio(
      id: 5,
      empresaId: 103,
      titulo: 'Chatbot para Atendimento ao Cliente',
      descricao:
          'Implementar chatbot com NLP para automatizar atendimento ao cliente, integrado ao WhatsApp e Telegram com fluxos configuráveis.',
      area: 'IA / Automação',
      prazo: DateTime(2025, 11, 15),
      dificuldade: 'Iniciante',
    ),
  ];

  static final List<Proposta> _propostas = [
    Proposta(
      id: 1,
      desafioId: 1,
      alunoId: 2,
      nomeAluno: 'Ana Beatriz Lima',
      descricaoSolucao:
          'Proponho usar ESP32 com sensores DHT22 e MQ-135, transmitindo via MQTT para broker HiveMQ, com dashboard em Grafana e alertas via e-mail.',
      dataEnvio: DateTime(2025, 6, 10),
    ),
    Proposta(
      id: 2,
      desafioId: 3,
      alunoId: 1,
      nomeAluno: 'Lucas Ferreira',
      descricaoSolucao:
          'Desenvolverei usando React + Node.js + PostgreSQL, com sistema de pontos de sustentabilidade e integração com API de cálculo de CO2.',
      dataEnvio: DateTime(2025, 6, 12),
    ),
    Proposta(
      id: 3,
      desafioId: 5,
      alunoId: 3,
      nomeAluno: 'Carlos Eduardo Santos',
      descricaoSolucao:
          'Usarei Rasa NLU para o NLP + Python para os fluxos, com integração via API do Telegram Bot e WhatsApp Business API.',
      dataEnvio: DateTime(2025, 6, 14),
    ),
  ];

  static int _desafioSeq = 10;
  static int _propostaSeq = 10;

  // ─── Desafios ────────────────────────────────────────────────────────────────
  static List<Desafio> get all => List.unmodifiable(_desafios);

  static List<Desafio> get publicados =>
      _desafios.where((d) => d.publicado).toList();

  static List<Desafio> forEmpresa(int empresaId) =>
      _desafios.where((d) => d.empresaId == empresaId).toList();

  static Desafio create({
    required int empresaId,
    required String titulo,
    required String descricao,
    required String area,
    required DateTime prazo,
    required String dificuldade,
  }) {
    final d = Desafio(
      id: _desafioSeq++,
      empresaId: empresaId,
      titulo: titulo,
      descricao: descricao,
      area: area,
      prazo: prazo,
      dificuldade: dificuldade,
    );
    _desafios.add(d);
    return d;
  }

  static void update(Desafio updated) {
    final idx = _desafios.indexWhere((d) => d.id == updated.id);
    if (idx != -1) _desafios[idx] = updated;
  }

  static void delete(int id) => _desafios.removeWhere((d) => d.id == id);

  // ─── Propostas ───────────────────────────────────────────────────────────────
  static List<Proposta> proposalsFor(int desafioId) =>
      _propostas.where((p) => p.desafioId == desafioId).toList();

  static List<Proposta> byAluno(int alunoId) =>
      _propostas.where((p) => p.alunoId == alunoId).toList();

  static bool alunoJaEnviou(int desafioId, int alunoId) =>
      _propostas.any((p) => p.desafioId == desafioId && p.alunoId == alunoId);

  static Proposta sendProposal({
    required int desafioId,
    required int alunoId,
    required String nomeAluno,
    required String descricaoSolucao,
  }) {
    final p = Proposta(
      id: _propostaSeq++,
      desafioId: desafioId,
      alunoId: alunoId,
      nomeAluno: nomeAluno,
      descricaoSolucao: descricaoSolucao,
      dataEnvio: DateTime.now(),
    );
    _propostas.add(p);
    return p;
  }

  // ─── Helpers de estatística ───────────────────────────────────────────────────
  static int get totalPropostas => _propostas.length;

  static int proposalCountFor(int desafioId) =>
      _propostas.where((p) => p.desafioId == desafioId).length;
}

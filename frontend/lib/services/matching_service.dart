// ─── MATCHING SERVICE ─────────────────────────────────────────────────────────
//
// INTEGRAÇÃO FUTURA:
//   POST /api/matching/suggest
//   Body: { technologies[], userId }
//   Response: CompanyMatch[]

class CompanyMatch {
  final String id;
  final String name;
  final String type; // 'Empresa' | 'Startup' | 'Agencia'
  final String location;
  final String description;
  final List<String> openRoles;
  final List<String> techStack;
  final int matchPercent; // 0-100
  final String matchReason;

  const CompanyMatch({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.description,
    required this.openRoles,
    required this.techStack,
    required this.matchPercent,
    required this.matchReason,
  });

  factory CompanyMatch.fromJson(Map<String, dynamic> json) => CompanyMatch(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    location: json['location'] as String,
    description: json['description'] as String,
    openRoles: List<String>.from(json['openRoles'] as List),
    techStack: List<String>.from(json['techStack'] as List),
    matchPercent: json['matchPercent'] as int,
    matchReason: json['matchReason'] as String,
  );
}

// ─── INTERFACE ────────────────────────────────────────────────────────────────
abstract class MatchingService {
  Future<List<CompanyMatch>> findMatches(List<String> technologies);
}

// ─── MOCK ────────────────────────────────────────────────────────────────────
class MockMatchingService implements MatchingService {
  static const _companies = [
    CompanyMatch(
      id: 'c1',
      name: 'Tech Innovate',
      type: 'Empresa',
      location: 'Sao Paulo, SP',
      description:
          'Empresa de tecnologia especializada em solucoes IoT e automacao industrial.',
      openRoles: [
        'Dev Flutter Junior',
        'Dev Backend Dart',
        'Estagiario Mobile',
      ],
      techStack: ['Flutter', 'Dart', 'MQTT', 'PostgreSQL', 'React'],
      matchPercent: 0,
      matchReason: '',
    ),
    CompanyMatch(
      id: 'c2',
      name: 'Startup Nova',
      type: 'Startup',
      location: 'Remoto',
      description:
          'Startup de educacao digital buscando desenvolvedores apaixonados por impacto social.',
      openRoles: ['Dev Full Stack Junior', 'UX/UI Designer', 'Dev Mobile'],
      techStack: [
        'React Native',
        'Node.js',
        'Firebase',
        'TypeScript',
        'Flutter',
      ],
      matchPercent: 0,
      matchReason: '',
    ),
    CompanyMatch(
      id: 'c3',
      name: 'DataSolutions',
      type: 'Empresa',
      location: 'Campinas, SP',
      description:
          'Empresa de analytics e BI com projetos de grande escala para o varejo.',
      openRoles: [
        'Analista de Dados Junior',
        'Dev Backend Python',
        'Estagiario BD',
      ],
      techStack: ['Python', 'MySQL', 'PostgreSQL', 'Power BI', 'SQLite'],
      matchPercent: 0,
      matchReason: '',
    ),
    CompanyMatch(
      id: 'c4',
      name: 'WebCraft Agency',
      type: 'Agencia',
      location: 'Rio de Janeiro, RJ',
      description:
          'Agencia digital criando experiencias web para marcas lideres do mercado.',
      openRoles: ['Dev Frontend Junior', 'Dev Vue.js', 'Estagiario Web'],
      techStack: ['Vue.js', 'React', 'Node.js', 'TypeScript', 'CSS'],
      matchPercent: 0,
      matchReason: '',
    ),
    CompanyMatch(
      id: 'c5',
      name: 'CloudBridge',
      type: 'Empresa',
      location: 'Remoto',
      description:
          'Empresa de infraestrutura cloud ajudando startups a escalar suas plataformas.',
      openRoles: [
        'Dev Backend Junior',
        'DevOps Estagiario',
        'Analista de Sistemas',
      ],
      techStack: ['Node.js', 'Python', 'MySQL', 'Docker', 'Laravel'],
      matchPercent: 0,
      matchReason: '',
    ),
    CompanyMatch(
      id: 'c6',
      name: 'MobileFirst',
      type: 'Startup',
      location: 'Florianopolis, SC',
      description:
          'Startup focada em apps mobile de alta performance para o setor financeiro.',
      openRoles: ['Dev Flutter Senior', 'Dev React Native', 'QA Mobile'],
      techStack: ['Flutter', 'React Native', 'Dart', 'Firebase', 'PostgreSQL'],
      matchPercent: 0,
      matchReason: '',
    ),
  ];

  @override
  Future<List<CompanyMatch>> findMatches(List<String> technologies) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (technologies.isEmpty) return [];

    final techs = technologies.map((t) => t.toLowerCase()).toList();

    // Algoritmo de matching — mesma lógica que o backend implementará
    final scored = _companies
        .map((c) {
          final compTechs = c.techStack.map((t) => t.toLowerCase()).toList();
          final matches = techs
              .where(
                (t) => compTechs.any((ct) => ct.contains(t) || t.contains(ct)),
              )
              .length;

          if (matches == 0) return null;

          final pct = ((matches / techs.length) * 100).clamp(20, 98).round();
          final matchedNames = techs
              .where(
                (t) => compTechs.any((ct) => ct.contains(t) || t.contains(ct)),
              )
              .map(
                (t) => technologies.firstWhere(
                  (orig) => orig.toLowerCase() == t,
                  orElse: () => t,
                ),
              )
              .take(2)
              .join(' e ');
          final reason =
              'Voce usa $matchedNames, tecnologias que esta empresa busca ativamente.';

          return CompanyMatch(
            id: c.id,
            name: c.name,
            type: c.type,
            location: c.location,
            description: c.description,
            openRoles: c.openRoles,
            techStack: c.techStack,
            matchPercent: pct,
            matchReason: reason,
          );
        })
        .whereType<CompanyMatch>()
        .toList();

    scored.sort((a, b) => b.matchPercent.compareTo(a.matchPercent));
    return scored.take(3).toList();
  }
}

// ─── IMPLEMENTAÇÃO REAL ────────────────────────────────────────────────────────
// class ApiMatchingService implements MatchingService {
//   final String baseUrl;
//   ApiMatchingService({required this.baseUrl});
//
//   @override
//   Future<List<CompanyMatch>> findMatches(List<String> technologies) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/matching/suggest'),
//       headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${AuthService.token}'},
//       body: jsonEncode({'technologies': technologies, 'userId': AuthService.userId}),
//     );
//     if (response.statusCode == 200) {
//       final list = jsonDecode(response.body) as List;
//       return list.map((j) => CompanyMatch.fromJson(j)).toList();
//     }
//     throw Exception('Erro no matching: ${response.statusCode}');
//   }
// }

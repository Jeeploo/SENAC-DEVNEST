import 'dart:math' as dart_math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';

// ─── MOCK DATA ────────────────────────────────────────────────────────────────
class _FeaturedProject {
  final String title;
  final String description;
  final String category;
  final List<String> technologies;
  final String classGroup;
  final String year;
  final String imageUrl;
  final Color categoryColor;

  const _FeaturedProject({
    required this.title,
    required this.description,
    required this.category,
    required this.technologies,
    required this.classGroup,
    required this.year,
    required this.imageUrl,
    required this.categoryColor,
  });
}

const _kProjects = [
  _FeaturedProject(
    title: 'Sistema de Automacao Residencial',
    description:
        'Desenvolvimento de um sistema IoT completo para controle e monitoramento de ambientes residenciais...',
    category: 'IoT',
    technologies: ['Arduino', 'IoT', 'React Native'],
    classGroup: 'Turma 2024A - Grupo 3',
    year: '2024',
    imageUrl: 'https://picsum.photos/seed/iot-home/500/300',
    categoryColor: Color(0xFF0288D1),
  ),
  _FeaturedProject(
    title: 'Aplicativo de Gestão Acadêmica',
    description:
        'Plataforma mobile para gerenciamento de atividades acadêmicas, incluindo notas, frequência e comúnicação...',
    category: 'Mobile',
    technologies: ['Flutter', 'Firebase', 'UX/UI'],
    classGroup: 'Turma 2024B - Grupo 1',
    year: '2024',
    imageUrl: 'https://picsum.photos/seed/mobile-app/500/300',
    categoryColor: Color(0xFF7B1FA2),
  ),
  _FeaturedProject(
    title: 'Prototipo de Impressora 3D Sustentavel',
    description:
        'Desenvolvimento de uma impressora 3D de baixo custo utilizando materiais reciclaveis e filamentos...',
    category: 'Engenharia',
    technologies: ['Impressao 3D', 'Sustentabilidade', 'Mecanica'],
    classGroup: 'Turma 2023B - Grupo 5',
    year: '2023',
    imageUrl: 'https://picsum.photos/seed/3d-printer/500/300',
    categoryColor: Color(0xFF388E3C),
  ),
  _FeaturedProject(
    title: 'Plataforma de Aprendizado Adaptativo',
    description:
        'Sistema web com inteligencia artificial que personaliza o conteudo de aprendizado baseado no desempenho do...',
    category: 'IA',
    technologies: ['Machine Learning', 'Python', 'React'],
    classGroup: 'Turma 2024A - Grupo 2',
    year: '2024',
    imageUrl: 'https://picsum.photos/seed/ai-platform/500/300',
    categoryColor: Color(0xFFE64A19),
  ),
  _FeaturedProject(
    title: 'Sistema de Design Colaborativo',
    description:
        'Ferramenta web para equipes de design criarem e compartilharem prototipos de forma colaborativa em...',
    category: 'Web',
    technologies: ['WebSocket', 'Canvas', 'TypeScript'],
    classGroup: 'Turma 2023A - Grupo 4',
    year: '2023',
    imageUrl: 'https://picsum.photos/seed/design-collab/500/300',
    categoryColor: Color(0xFF00838F),
  ),
  _FeaturedProject(
    title: 'Robo Autonomo de Limpeza',
    description:
        'Desenvolvimento de um robo autonomo com sensores e cameras para navegacao e limpeza de ambientes...',
    category: 'Robotica',
    technologies: ['Robotica', 'Computer Vision', 'ROS'],
    classGroup: 'Turma 2024B - Grupo 6',
    year: '2024',
    imageUrl: 'https://picsum.photos/seed/robot/500/300',
    categoryColor: Color(0xFFC62828),
  ),
];

const _kCategories = [
  'Todos',
  'IoT',
  'Mobile',
  'Engenharia',
  'IA',
  'Web',
  'Robotica',
];

// ─── HOME VIEW ────────────────────────────────────────────────────────────────
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      drawer: Responsive.isMobile(context) || Responsive.isTablet(context)
          ? const AppDrawer()
          : null,
      body: Column(
        children: [
          const AppNavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const _HeroSection(),
                  const _StatsSection(),
                  const _FeaturedProjectsSection(),
                  const _WhySection(),
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HERO — WOW PARALLAX ─────────────────────────────────────────────────────
class _HeroSection extends StatefulWidget {
  const _HeroSection();
  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with TickerProviderStateMixin {
  double _mx = 0.5, _my = 0.5;
  late final AnimationController _aurora;
  late final AnimationController _float;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _aurora = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatAnim = CurvedAnimation(parent: _float, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _aurora.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mobile = Responsive.isMobile(context);
    final dx = (_mx - 0.5) * 40;
    final dy = (_my - 0.5) * 30;

    return MouseRegion(
      onHover: (e) => setState(() {
        _mx = (e.position.dx / size.width).clamp(0.0, 1.0);
        _my = (e.position.dy / size.height).clamp(0.0, 1.0);
      }),
      child: SizedBox(
        width: double.infinity,
        height: mobile ? 520 : 620,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── LAYER 0: Background image (parallax 0.4x) ─────────────────────
            Transform(
              transform: Matrix4.translationValues(-dx * 0.4, -dy * 0.4, 0)
                ..scale(1.08),
              alignment: Alignment.center,
              child: Image.network(
                'https://images.unsplash.com/photo-1518770660439-4636190af475?w=1800&q=80',
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) =>
                    Container(color: const Color(0xFF060D1A)),
              ),
            ),

            // ── Base dark overlay ─────────────────────────────────────────────
            Container(color: const Color(0xDD060D1A)),

            // ── LAYER 1: Aurora orbes animados (parallax 0.6x) ────────────────
            AnimatedBuilder(
              animation: _aurora,
              builder: (_, __) {
                final t = _aurora.value;
                return Stack(
                  children: [
                    // Orbe ciano — canto superior esquerdo
                    _orb(
                      dx: -dx * 0.6 + size.width * 0.18,
                      dy: -dy * 0.6 + size.height * 0.15,
                      r: 320,
                      color: const Color(0xFF00ACC1).withValues(
                        alpha: 0.22 + (t * 2 * 3.14159).abs().abs() * 0.08,
                      ),
                    ),
                    // Orbe laranja — canto inferior direito
                    _orb(
                      dx: -dx * 0.5 + size.width * 0.78,
                      dy: -dy * 0.5 + size.height * 0.65,
                      r: 280,
                      color: const Color(0xFFFF9800).withValues(
                        alpha:
                            0.15 + ((t * 2 + 1) * 3.14159).abs().abs() * 0.07,
                      ),
                    ),
                    // Orbe roxo — centro
                    _orb(
                      dx: -dx * 0.35 + size.width * 0.45,
                      dy: -dy * 0.35 + size.height * 0.3,
                      r: 200,
                      color: const Color(0xFF7C3AED).withValues(
                        alpha: 0.12 + ((t * 1.5) * 3.14159).abs().abs() * 0.05,
                      ),
                    ),
                  ],
                );
              },
            ),

            // ── LAYER 2: Grid + partículas (parallax 0.5x) ───────────────────
            Transform.translate(
              offset: Offset(-dx * 0.5, -dy * 0.5),
              child: AnimatedBuilder(
                animation: _aurora,
                builder: (_, __) => CustomPaint(
                  painter: _ParticlePainter(_aurora.value),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // ── LAYER 3: Badges tecnologia flutuantes (parallax 0.7x) ─────────
            if (!mobile) ...[
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _floatAnim,
                  builder: (_, __) => Stack(
                    children: [
                      _techBadge(
                        'Flutter',
                        const Color(0xFF54C5F8),
                        Icons.phone_iphone,
                        dx: -dx * 0.7,
                        dy: -dy * 0.7,
                        top: 90,
                        right: 340,
                      ),
                      _techBadge(
                        'Dart',
                        const Color(0xFF0175C2),
                        Icons.code,
                        dx: -dx * 0.65,
                        dy: -dy * 0.65,
                        top: 175,
                        right: 160,
                        floatOffset: _floatAnim.value * 12 - 6,
                      ),
                      _techBadge(
                        'MySQL',
                        const Color(0xFF4479A1),
                        Icons.storage,
                        dx: -dx * 0.8,
                        dy: -dy * 0.8,
                        top: 290,
                        right: 380,
                        floatOffset: _floatAnim.value * -8 + 4,
                      ),
                      _techBadge(
                        'GitHub',
                        Colors.white70,
                        Icons.hub,
                        dx: -dx * 0.6,
                        dy: -dy * 0.6,
                        top: 390,
                        right: 220,
                        floatOffset: _floatAnim.value * 10 - 5,
                      ),
                      _techBadge(
                        'Flutter Web',
                        AppColors.primary,
                        Icons.web,
                        dx: -dx * 0.75,
                        dy: -dy * 0.75,
                        top: 480,
                        right: 350,
                        floatOffset: _floatAnim.value * -6 + 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // ── Gradiente lateral esquerdo ────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF060D1A).withValues(alpha: 0.95),
                    const Color(0xFF060D1A).withValues(alpha: 0.70),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),

            // ── LAYER 4: Conteúdo (fixo — não move) ──────────────────────────
            Positioned.fill(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      mobile ? 24 : 64,
                      mobile ? 60 : 0,
                      mobile ? 24 : 64,
                      mobile ? 48 : 0,
                    ),
                    child: Column(
                      mainAxisSize: mobile
                          ? MainAxisSize.min
                          : MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge pulsante
                        AnimatedBuilder(
                          animation: _floatAnim,
                          builder: (_, __) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(
                                alpha: 0.12 + _floatAnim.value * 0.06,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.primary.withValues(
                                  alpha: 0.35 + _floatAnim.value * 0.15,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15 + _floatAnim.value * 0.10,
                                  ),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.6,
                                        ),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Observatório de Projetos Integradores',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: mobile ? 18 : 22),

                        // Título principal
                        Text(
                          'Descubra os',
                          style: TextStyle(
                            fontSize: mobile ? 28 : 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.1,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (b) => const LinearGradient(
                            colors: [
                              Color(0xFF00ACC1),
                              Color(0xFF80DEEA),
                              Color(0xFF00ACC1),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ).createShader(b),
                          child: Text(
                            'Projetos Integradores',
                            style: TextStyle(
                              fontSize: mobile ? 30 : 54,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),
                        Text(
                          'da nossa faculdade',
                          style: TextStyle(
                            fontSize: mobile ? 28 : 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: mobile ? 16 : 22),

                        // Subtítulo
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Text(
                            'Um repositório centralizado de todos os projetos desenvolvidos pelos alunos. Explore ideias inovadoras, colabore e inspire-se.',
                            style: TextStyle(
                              fontSize: mobile ? 13 : 16,
                              color: Colors.white.withValues(alpha: 0.65),
                              height: 1.7,
                            ),
                          ),
                        ),
                        SizedBox(height: mobile ? 28 : 36),

                        // Botões
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.explore_outlined,
                                size: 18,
                              ),
                              label: const Text(
                                'Explorar Projetos',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: mobile ? 20 : 28,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadowColor: AppColors.primary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              label: Text(
                                'Sobre o Observatório',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: mobile ? 20 : 28,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: mobile ? 28 : 36),

                        // Mini stats — preenche espaço e reforça credibilidade
                        Wrap(
                          spacing: 0,
                          runSpacing: 12,
                          children: [
                            _MiniStat(value: '150+', label: 'Projetos'),
                            _MiniDivider(),
                            _MiniStat(value: '500+', label: 'Alunos'),
                            _MiniDivider(),
                            _MiniStat(value: '20+', label: 'Turmas'),
                            _MiniDivider(),
                            _MiniStat(value: '15', label: 'Premiados'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orb({
    required double dx,
    required double dy,
    required double r,
    required Color color,
  }) {
    return Positioned(
      left: dx - r,
      top: dy - r,
      child: Container(
        width: r * 2,
        height: r * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }

  Widget _techBadge(
    String label,
    Color color,
    IconData icon, {
    required double dx,
    required double dy,
    required double top,
    required double right,
    double floatOffset = 0,
  }) {
    return Positioned(
      top: top + floatOffset,
      right: right + dx,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.18), blurRadius: 14),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PARTICLE PAINTER ─────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double t;
  _ParticlePainter(this.t);

  static const _pts = [
    (0.1, 0.2),
    (0.25, 0.7),
    (0.4, 0.15),
    (0.55, 0.6),
    (0.7, 0.25),
    (0.85, 0.75),
    (0.15, 0.5),
    (0.6, 0.4),
    (0.9, 0.1),
    (0.35, 0.85),
    (0.75, 0.55),
    (0.5, 0.9),
    (0.8, 0.35),
    (0.2, 0.35),
    (0.65, 0.8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Grid
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.025)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 70) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Partículas
    for (final (px, py) in _pts) {
      final x = px * size.width;
      final y = py * size.height + (t * 2 * 3.14159 + px * 6.28).abs() * 8;
      final alpha = 0.15 + ((t * 6.28 + py * 6.28).abs().abs()) * 0.25;
      final r = 1.5 + (px + py) * 2;
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = const Color(0xFF00ACC1).withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}

// ─── MINI STATS (hero) ────────────────────────────────────────────────────────
class _MiniStat extends StatelessWidget {
  final String value, label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.55),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _MiniDivider extends StatelessWidget {
  const _MiniDivider();
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 36,
    margin: const EdgeInsets.symmetric(vertical: 4),
    color: Colors.white.withValues(alpha: 0.15),
  );
}

// ─── STATS SECTION ────────────────────────────────────────────────────────────
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  static const _stats = [
    (
      value: '150+',
      label: 'Projetos Públicados',
      icon: Icons.code,
      bg: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1565C0),
    ),
    (
      value: '20+',
      label: 'Turmas Participantes',
      icon: Icons.trending_up,
      bg: Color(0xFFF3E5F5),
      iconColor: Color(0xFF6A1B9A),
    ),
    (
      value: '500+',
      label: 'Alunos Envolvidos',
      icon: Icons.lightbulb_outline,
      bg: Color(0xFFFCE4EC),
      iconColor: Color(0xFFC2185B),
    ),
    (
      value: '15',
      label: 'Projetos Premiados',
      icon: Icons.rocket_launch,
      bg: Color(0xFFFFF3E0),
      iconColor: Color(0xFFE65100),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 20 : 64, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: mobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildCard(_stats[0])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCard(_stats[1])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildCard(_stats[2])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCard(_stats[3])),
                      ],
                    ),
                  ],
                )
              : Row(
                  children:
                      _stats
                          .map((s) => Expanded(child: _buildCard(s)))
                          .expand((w) => [w, const SizedBox(width: 20)])
                          .toList()
                        ..removeLast(),
                ),
        ),
      ),
    );
  }

  Widget _buildCard(
    ({String value, String label, IconData icon, Color bg, Color iconColor}) s,
  ) {
    return _StatHoverCard(stat: s);
  }
}

// ─── FEATURED PROJECTS ────────────────────────────────────────────────────────
class _FeaturedProjectsSection extends StatefulWidget {
  const _FeaturedProjectsSection();

  @override
  State<_FeaturedProjectsSection> createState() =>
      _FeaturedProjectsSectionState();
}

class _FeaturedProjectsSectionState extends State<_FeaturedProjectsSection> {
  String _selectedCategory = 'Todos';

  List<_FeaturedProject> get _filtered => _selectedCategory == 'Todos'
      ? _kProjects
      : _kProjects.where((p) => p.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final tablet = Responsive.isTablet(context);
    final hPad = mobile
        ? 20.0
        : tablet
        ? 32.0
        : 64.0;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Projetos em Destaque',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Conheca os projetos mais inovadores desenvolvidos pelos nossos alunos',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 16),
                    label: const Text(
                      'Filtrar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Category chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _kCategories.map((cat) {
                    final active = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: active
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),

              // Grid
              if (mobile)
                Column(
                  children: _filtered
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _ProjectCard(project: p),
                        ),
                      )
                      .toList(),
                )
              else
                _buildGrid(tablet),

              const SizedBox(height: 40),

              // Ver todos
              Center(
                child: _HoverFilledButton(
                  label: 'Ver Todos os Projetos',
                  color: AppColors.primary,
                  onTap: () {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 16,
                  ),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(bool tablet) {
    final cols = tablet ? 2 : 3;
    final rows = <Widget>[];
    for (var i = 0; i < _filtered.length; i += cols) {
      final rowItems = _filtered.skip(i).take(cols).toList();
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowItems
                .map(
                  (p) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: rowItems.indexOf(p) < rowItems.length - 1
                            ? 20
                            : 0,
                      ),
                      child: _ProjectCard(project: p),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _ProjectCard extends StatefulWidget {
  final _FeaturedProject project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? AppColors.primary : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + category badge
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Image.network(
                      p.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, s) => Container(
                        color: p.categoryColor.withValues(alpha: 0.1),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: p.categoryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        p.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título muda de cor no hover
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _hovered
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                      child: Text(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: p.technologies
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                t,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            p.classGroup,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          p.year,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── WHY SECTION ──────────────────────────────────────────────────────────────
class _WhySection extends StatelessWidget {
  const _WhySection();

  static const _features = [
    (
      icon: Icons.search,
      title: 'Busca Avancada',
      desc:
          'Encontre projetos por categoria, turma, tecnologia ou palavras-chave.',
    ),
    (
      icon: Icons.menu_book,
      title: 'Documentacao Completa',
      desc: 'Acesse relatórios, código-fonte e apresentações de cada projeto.',
    ),
    (
      icon: Icons.emoji_events_outlined,
      title: 'Projetos Premiados',
      desc: 'Veja os projetos que se destacaram em competicoes e eventos.',
    ),
    (
      icon: Icons.group_outlined,
      title: 'Colaboração',
      desc: 'Conecte-se com os autores e colabore em novos projetos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final tablet = Responsive.isTablet(context);
    final hPad = mobile
        ? 20.0
        : tablet
        ? 32.0
        : 64.0;

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'Por que usar o SENAC DevNest?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Uma plataforma completa para explorar, compartilhar e colaborar em projetos acadêmicos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              mobile
                  ? Column(
                      children: _features
                          .map(
                            (f) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _FeatureCard(feature: f),
                            ),
                          )
                          .toList(),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _features
                          .map(
                            (f) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      _features.indexOf(f) <
                                          _features.length - 1
                                      ? 16
                                      : 0,
                                ),
                                child: _FeatureCard(feature: f),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final ({IconData icon, String title, String desc}) feature;
  const _FeatureCard({required this.feature});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? AppColors.primary : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: _hovered
                      ? const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF00ACC1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.15),
                            AppColors.primary.withValues(alpha: 0.15),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.feature.icon,
                  color: _hovered ? Colors.white : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.feature.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.feature.desc,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── STAT HOVER CARD ─────────────────────────────────────────────────────────
class _StatHoverCard extends StatefulWidget {
  final ({String value, String label, IconData icon, Color bg, Color iconColor})
  stat;
  const _StatHoverCard({required this.stat});

  @override
  State<_StatHoverCard> createState() => _StatHoverCardState();
}

class _StatHoverCardState extends State<_StatHoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.stat;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _hovered ? s.bg.withValues(alpha: 0.3) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? s.iconColor.withValues(alpha: 0.4)
                  : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: s.iconColor.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -10,
                right: -10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _hovered ? 90 : 80,
                  height: _hovered ? 90 : 80,
                  decoration: BoxDecoration(
                    color: s.bg,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: s.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.iconColor, size: 22),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    s.value,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── HOVER WIDGETS ────────────────────────────────────────────────────────────

/// Botão filled com escala + shadow suaves no hover
class _HoverFilledButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final double fontSize;

  const _HoverFilledButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.padding,
    this.fontSize = 14,
  });

  @override
  State<_HoverFilledButton> createState() => _HoverFilledButtonState();
}

class _HoverFilledButtonState extends State<_HoverFilledButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.88)
                  : widget.color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Botão outlined com fundo que aparece no hover
class _HoverOutlinedButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _HoverOutlinedButton({required this.label, required this.onTap});

  @override
  State<_HoverOutlinedButton> createState() => _HoverOutlinedButtonState();
}

class _HoverOutlinedButtonState extends State<_HoverOutlinedButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.textPrimary.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hovered ? AppColors.textPrimary : AppColors.border,
                width: 1.5,
              ),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Card com elevação e escala suaves no hover
class _HoverCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _HoverCard({required this.child, this.padding});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? AppColors.primary : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

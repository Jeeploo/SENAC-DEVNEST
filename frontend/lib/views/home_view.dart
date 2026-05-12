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

// ─── HERO ─────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final tablet = Responsive.isTablet(context);

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: mobile
            ? 20
            : tablet
            ? 32
            : 64,
        vertical: mobile ? 32 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: mobile ? _mobileHero(context) : _desktopHero(context, tablet),
        ),
      ),
    );
  }

  Widget _desktopHero(BuildContext context, bool tablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: tablet ? 6 : 5, child: _heroText(context)),
        const SizedBox(width: 40),
        Expanded(flex: tablet ? 5 : 5, child: _heroImage()),
      ],
    );
  }

  Widget _mobileHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroBadge(),
        const SizedBox(height: 20),
        _heroTitle(context),
        const SizedBox(height: 16),
        _heroSubtitle(),
        const SizedBox(height: 28),
        _heroImage(),
        const SizedBox(height: 28),
        _heroButtons(context),
        const SizedBox(height: 28),
        _heroStats(),
      ],
    );
  }

  Widget _heroText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroBadge(),
        const SizedBox(height: 24),
        _heroTitle(context),
        const SizedBox(height: 20),
        _heroSubtitle(),
        const SizedBox(height: 32),
        _heroButtons(context),
        const SizedBox(height: 40),
        _heroStats(),
      ],
    );
  }

  Widget _heroBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
        color: AppColors.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.trending_up, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            'Mais de 150 projetos públicados',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroTitle(BuildContext context) {
    final fontSize = Responsive.value(
      context,
      mobile: 30.0,
      tablet: 36.0,
      desktop: 44.0,
    );
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.15,
        ),
        children: const [
          TextSpan(text: 'Descubra os '),
          TextSpan(
            text: 'Projetos Integradores',
            style: TextStyle(color: AppColors.primary),
          ),
          TextSpan(text: ' da nossa faculdade'),
        ],
      ),
    );
  }

  Widget _heroSubtitle() {
    return const Text(
      'Um repositório centralizado de todos os projetos desenvolvidos pelos alunos. Explore ideias inovadoras, colabore e inspire-se.',
      style: TextStyle(
        fontSize: 15,
        color: AppColors.textSecondary,
        height: 1.7,
      ),
    );
  }

  Widget _heroButtons(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final buttons = [
      _HoverFilledButton(
        label: 'Explorar Projetos',
        icon: Icons.arrow_forward,
        color: AppColors.primary,
        onTap: () {},
      ),
      _HoverOutlinedButton(label: 'Sobre o Observatório', onTap: () {}),
    ];

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [buttons[0], const SizedBox(height: 10), buttons[1]],
      );
    }
    return Row(children: [buttons[0], const SizedBox(width: 14), buttons[1]]);
  }

  Widget _heroStats() {
    const stats = [('150+', 'Projetos'), ('20+', 'Turmas'), ('500+', 'Alunos')];
    return Row(
      children: stats
          .expand(
            (s) => [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.$1,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    s.$2,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
            ],
          )
          .toList(),
    );
  }

  Widget _heroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        'https://picsum.photos/seed/students-group/600/450',
        fit: BoxFit.cover,
        errorBuilder: (_, e, s) => Container(
          height: 380,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.secondary.withValues(alpha: 0.25),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.people_outline,
              size: 80,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
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
                  children:
                      _stats
                          .map(_buildCard)
                          .toList()
                          .expand((w) => [w, const SizedBox(height: 16)])
                          .toList()
                        ..removeLast(),
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
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final double fontSize;

  const _HoverFilledButton({
    required this.label,
    this.icon,
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
                if (widget.icon != null) ...[
                  const SizedBox(width: 8),
                  AnimatedSlide(
                    offset: _hovered ? const Offset(0.15, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    child: Icon(widget.icon, size: 16, color: Colors.white),
                  ),
                ],
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

  const _HoverCard(this.padding, {required this.child});

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

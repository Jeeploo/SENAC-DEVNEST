import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';

// ─── MODELS ──────────────────────────────────────────────────────────────────
class _Feedback {
  final String name;
  final String initials;
  final String role;
  final String project;
  final double stars;
  final String text;
  final String date;
  final int likes;
  final int replies;
  final Color avatarColor;
  final bool veryUseful;

  const _Feedback({
    required this.name,
    required this.initials,
    required this.role,
    required this.project,
    required this.stars,
    required this.text,
    required this.date,
    required this.likes,
    required this.replies,
    required this.avatarColor,
    this.veryUseful = true,
  });
}

// ─── MOCK DATA ────────────────────────────────────────────────────────────────
const _kFeedbacks = [
  _Feedback(
    name: 'Prof. Samantha Pimentel',
    initials: 'SP',
    role: 'Professora - Design',
    project: 'App de Gestao Academica',
    stars: 5,
    text: 'Interface excepcional! A paleta de cores esta harmoniosa e a hierarquia visual esta muito bem definida. A experiencia do usuario flui naturalmente. Sugiro apenas aumentar o contraste nos botoes secundarios para melhorar a acessibilidade.',
    date: '2024-04-10',
    likes: 28,
    replies: 4,
    avatarColor: Color(0xFF8E24AA),
    veryUseful: true,
  ),
  _Feedback(
    name: 'Prof. Heuryk Wylk',
    initials: 'HW',
    role: 'Professor - Banco de Dados',
    project: 'Sistema de Automacao Residencial',
    stars: 5,
    text: 'Modelagem de dados muito bem estruturada! A normalizacao esta correta e as queries estao otimizadas. Excelente uso de indices. Recomendo implementar procedures armazenadas para as operacoes mais complexas e considerar particionamento para escalabilidade futura.',
    date: '2024-04-12',
    likes: 35,
    replies: 6,
    avatarColor: Color(0xFF5C6BC0),
    veryUseful: true,
  ),
  _Feedback(
    name: 'Prof. Guibson Santana',
    initials: 'GS',
    role: 'Professor - Coding',
    project: 'Plataforma de Aprendizado Adaptativo',
    stars: 4.5,
    text: 'Codigo limpo e bem organizado! Boa aplicacao de principios SOLID e design patterns. A arquitetura em camadas esta excelente. Parabens pelo uso de TypeScript e pela documentacao clara. Sugiro implementar mais testes unitarios para aumentar a cobertura.',
    date: '2024-04-11',
    likes: 42,
    replies: 8,
    avatarColor: Color(0xFF00838F),
    veryUseful: true,
  ),
  _Feedback(
    name: 'Prof. Samantha Pimentel',
    initials: 'SP',
    role: 'Professora - Design',
    project: 'Prototipo de Impressora 3D Sustentavel',
    stars: 4,
    text: 'A apresentacao visual do prototipo esta otima! Os mockups e diagramas comunicam bem a proposta. Sugiro criar um guia de estilo mais detalhado e explorar mais a identidade visual do projeto para apresentacoes futuras.',
    date: '2024-04-09',
    likes: 19,
    replies: 2,
    avatarColor: Color(0xFF8E24AA),
    veryUseful: false,
  ),
  _Feedback(
    name: 'Prof. Guibson Santana',
    initials: 'GS',
    role: 'Professor - Coding',
    project: 'Sistema de Automacao Residencial',
    stars: 5,
    text: 'Implementacao exemplar! O codigo esta seguindo boas praticas, com separacao de responsabilidades clara. A API REST esta bem estruturada e documentada. Excelente uso de async/await. Apenas adicione tratamento de erros mais robusto nas chamadas de rede.',
    date: '2024-04-13',
    likes: 38,
    replies: 7,
    avatarColor: Color(0xFF00838F),
    veryUseful: true,
  ),
  _Feedback(
    name: 'Lucas Ferreira',
    initials: 'LF',
    role: 'Desenvolvedor Senior - Mobile',
    project: 'App de Gestao Academica',
    stars: 4,
    text: 'Interface muito intuitiva! O fluxo de navegacao esta excelente. A performance esta otima mesmo com muitos dados. Sugiro implementar cache local para melhorar a experiencia offline e adicionar animacoes nas transicoes.',
    date: '2024-04-13',
    likes: 15,
    replies: 1,
    avatarColor: Color(0xFF00ACC1),
    veryUseful: false,
  ),
];

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class FeedbacksView extends StatefulWidget {
  const FeedbacksView({super.key});

  @override
  State<FeedbacksView> createState() => _FeedbacksViewState();
}

class _FeedbacksViewState extends State<FeedbacksView> {
  String _filter = 'Todos';

  List<_Feedback> get _filtered {
    if (_filter == 'Mais Uteis') {
      return List.from(_kFeedbacks)
        ..sort((a, b) => b.likes.compareTo(a.likes));
    }
    return _kFeedbacks;
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final hPad = mobile ? 20.0 : 40.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: mobile ? const AppDrawer() : null,
      body: Column(
        children: [
          const AppNavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            const Text('Feedbacks Tecnicos',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            const Text(
                                'Avaliacoes e comentarios de professores, especialistas e profissionais',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary)),
                            const SizedBox(height: 24),

                            // Stats
                            _StatsRow(mobile: mobile),
                            const SizedBox(height: 24),

                            // Filters
                            Row(
                              children: [
                                _FilterTab(label: 'Todos',      active: _filter == 'Todos',      onTap: () => setState(() => _filter = 'Todos')),
                                const SizedBox(width: 8),
                                _FilterTab(label: 'Mais Uteis', active: _filter == 'Mais Uteis', onTap: () => setState(() => _filter = 'Mais Uteis')),
                                const Spacer(),
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.filter_list, size: 16),
                                  label: const Text('Filtrar',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.textPrimary,
                                    side: const BorderSide(color: AppColors.border),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Feedback list
                            ..._filtered.map((f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _FeedbackCard(feedback: f),
                                )),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // CTA Banner
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: const _CTABanner(),
                      ),
                    ),
                  ),

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

// ─── STATS ROW ────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final bool mobile;
  const _StatsRow({required this.mobile});

  static const _stats = [
    (value: '4.7',  label: 'Avaliacao Media',   icon: Icons.star_outline,       bg: Color(0xFFFFF8E1), color: Color(0xFFF9A825)),
    (value: '328',  label: 'Feedbacks Totais',  icon: Icons.chat_bubble_outline, bg: Color(0xFFE3F2FD), color: Color(0xFF1565C0)),
    (value: '89%',  label: 'Taxa Positiva',     icon: Icons.thumb_up_outlined,   bg: Color(0xFFE8F5E9), color: Color(0xFF2E7D32)),
    (value: '+42',  label: 'Esta Semana',       icon: Icons.trending_up,         bg: Color(0xFFF3E5F5), color: Color(0xFF6A1B9A)),
  ];

  @override
  Widget build(BuildContext context) {
    if (mobile) {
      // Mobile: scroll horizontal com largura fixa por card
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _stats.asMap().entries.map((e) => Padding(
            padding: EdgeInsets.only(right: e.key < _stats.length - 1 ? 12 : 0),
            child: SizedBox(width: 140, child: _StatCard(s: e.value)),
          )).toList(),
        ),
      );
    }
    return Row(
      children: _stats.map((s) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: _stats.indexOf(s) < _stats.length - 1 ? 16 : 0),
          child: _StatCard(s: s),
        ),
      )).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final ({String value, String label, IconData icon, Color bg, Color color}) s;
  const _StatCard({required this.s});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.all(mobile ? 14 : 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: mobile
          // Mobile: vertical (ícone em cima, valor, label)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(s.icon, color: s.color, size: 18),
                ),
                const SizedBox(height: 10),
                Text(s.value,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                Text(s.label,
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            )
          // Desktop/Tablet: horizontal
          : Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(s.icon, color: s.color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.value,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      Text(s.label,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ─── FILTER TAB ───────────────────────────────────────────────────────────────
class _FilterTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

// ─── STAR RATING ─────────────────────────────────────────────────────────────
class _StarRating extends StatelessWidget {
  final double stars;
  const _StarRating({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < stars.floor();
        final half = !filled && i < stars;
        return Icon(
          filled ? Icons.star : (half ? Icons.star_half : Icons.star_outline),
          color: const Color(0xFFF9A825),
          size: 18,
        );
      }),
    );
  }
}

// ─── FEEDBACK CARD ────────────────────────────────────────────────────────────
class _FeedbackCard extends StatelessWidget {
  final _Feedback feedback;
  const _FeedbackCard({required this.feedback});

  @override
  Widget build(BuildContext context) {
    final f = feedback;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: f.avatarColor,
                child: Text(f.initials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(f.role,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFB2EBF2)),
                      ),
                      child: Text(f.project,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary)),
                    ),
                  ],
                ),
              ),
              _StarRating(stars: f.stars),
            ],
          ),
          const SizedBox(height: 16),

          // Text
          Text(f.text,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.65)),
          const SizedBox(height: 16),

          // Footer
          Row(
            children: [
              Text(f.date,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(width: 16),
              const Icon(Icons.thumb_up_outlined,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text('${f.likes}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 14),
              const Icon(Icons.chat_bubble_outline,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text('${f.replies} respostas',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              if (f.veryUseful)
                Row(
                  children: [
                    const Icon(Icons.trending_up,
                        size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text('Muito util',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── CTA BANNER ──────────────────────────────────────────────────────────────
class _CTABanner extends StatelessWidget {
  const _CTABanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF8E24AA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        children: [
          const Text('Receba Feedback de Especialistas',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const SizedBox(height: 10),
          const Text(
              'Envie seu projeto e obtenha avaliacoes tecnicas de professores e profissionais da area',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.6)),
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Enviar Meu Projeto',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
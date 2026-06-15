import 'dart:math';
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/challenge_service.dart';
import '../services/evaluation_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_session.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';

// ─── DADOS MOCK (admin/genérico) ──────────────────────────────────────────────
const _kBarData = [
  ('2020', 12.0),
  ('2021', 25.0),
  ('2022', 38.0),
  ('2023', 52.0),
  ('2024', 68.0),
];
const _kLineData = [
  ('Jan', 1200.0),
  ('Fev', 1900.0),
  ('Mar', 2500.0),
  ('Abr', 3100.0),
  ('Mai', 2800.0),
  ('Jun', 3600.0),
];
const _kPieData = [
  ('IoT', 0.23, Color(0xFF1565C0)),
  ('Mobile', 0.19, Color(0xFF7B1FA2)),
  ('Web', 0.28, Color(0xFFD81B60)),
  ('Engenharia', 0.18, Color(0xFF2E7D32)),
  ('IA', 0.12, Color(0xFFE65100)),
];
const _kTopProjects = [
  ('Sistema de Automacao Residencial', 1284, 156),
  ('App de Gestão Acadêmica', 1156, 142),
  ('Plataforma de Aprendizado Adaptativo', 982, 128),
  ('Prototipo Impressora 3D Sustentavel', 874, 98),
];

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = AppSession.role;
    final mobile = Responsive.isMobile(context);
    final hPad = mobile ? 16.0 : 40.0;

    Widget content;
    if (role == 'aluno') {
      content = _AlunoDash(mobile: mobile);
    } else if (role == 'professor') {
      content = _ProfessorDash(mobile: mobile);
    } else if (role == 'empresa') {
      content = _EmpresaDash(mobile: mobile);
    } else {
      content = _AdminDash(mobile: mobile);
    }

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
                    padding:
                        EdgeInsets.fromLTRB(hPad, 28, hPad, 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: 1200),
                        child: content,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SHARED: STAT CARD ────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String value, label;
  final String? subtitle;
  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 14),
            Text(value,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32))),
            ],
          ],
        ),
      );
}

Widget _statsGrid({
  required bool mobile,
  required List<Widget> cards,
}) {
  if (mobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: EdgeInsets.only(
                      right: e.key < cards.length - 1 ? 12 : 0),
                  child: SizedBox(width: 160, child: e.value),
                ))
            .toList(),
      ),
    );
  }
  return Row(
    children: cards
        .asMap()
        .entries
        .map((e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: e.key < cards.length - 1 ? 16 : 0),
                child: e.value,
              ),
            ))
        .toList(),
  );
}

Widget _dashHeader({
  required String title,
  required String subtitle,
  required IconData icon,
  required Color color,
}) =>
    Row(children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
    ]);

Widget _sectionTitle(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(t,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary)),
    );

Widget _chartCard({required String title, required Widget child}) =>
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );

// ─── ALUNO DASHBOARD ──────────────────────────────────────────────────────────
class _AlunoDash extends StatelessWidget {
  final bool mobile;
  const _AlunoDash({required this.mobile});

  @override
  Widget build(BuildContext context) {
    final uid = AppSession.userId > 0 ? AppSession.userId : 1;
    final meusProjetos =
        kProjectsMock.where((p) => p.studentId == uid).toList();
    final alunoEvals = EvaluationService.all
        .where((e) => meusProjetos.any((p) => p.id == e.projectId))
        .toList();
    final notaMedia = alunoEvals.isEmpty
        ? 0.0
        : alunoEvals.map((e) => e.grade).reduce((a, b) => a + b) /
            alunoEvals.length;
    final desafiosDisponiveis = ChallengeService.publicados.length;
    final minhasPropostas = ChallengeService.byAluno(uid).length;

    final totalProjetos = meusProjetos.length;
    final submetidos = meusProjetos
        .where((p) => p.status == ProjectStatus.submitted)
        .length;
    final avaliados = meusProjetos
        .where((p) => p.status == ProjectStatus.evaluated)
        .length;
    final rascunhos = meusProjetos
        .where((p) => p.status == ProjectStatus.draft)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dashHeader(
          title: 'Meu Dashboard',
          subtitle:
              'Acompanhe seus projetos, avaliações e desafios',
          icon: Icons.school_outlined,
          color: AppColors.primary,
        ),
        const SizedBox(height: 24),

        // Stats de projetos
        _sectionTitle('Meus Projetos'),
        _statsGrid(mobile: mobile, cards: [
          _StatCard(
            icon: Icons.folder_outlined,
            iconBg: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1565C0),
            value: '$totalProjetos',
            label: 'Total de Projetos',
          ),
          _StatCard(
            icon: Icons.edit_note_outlined,
            iconBg: AppColors.statusPendingBg,
            iconColor: AppColors.statusPendingFg,
            value: '$rascunhos',
            label: 'Em Rascunho',
          ),
          _StatCard(
            icon: Icons.send_outlined,
            iconBg: const Color(0xFFE8EAF6),
            iconColor: const Color(0xFF3949AB),
            value: '$submetidos',
            label: 'Submetidos',
          ),
          _StatCard(
            icon: Icons.verified_outlined,
            iconBg: AppColors.statusApprovedBg,
            iconColor: AppColors.statusApprovedFg,
            value: '$avaliados',
            label: 'Avaliados',
          ),
        ]),
        const SizedBox(height: 20),

        // Nota média + desafios + propostas
        _statsGrid(mobile: mobile, cards: [
          _StatCard(
            icon: Icons.star_outline,
            iconBg: const Color(0xFFFFF8E1),
            iconColor: AppColors.accent,
            value: alunoEvals.isEmpty
                ? '—'
                : notaMedia.toStringAsFixed(1),
            label: 'Nota Média Recebida',
            subtitle: alunoEvals.isEmpty
                ? null
                : notaMedia >= 6.0
                    ? 'Aprovado'
                    : 'Em melhoria',
          ),
          _StatCard(
            icon: Icons.lightbulb_outline,
            iconBg: const Color(0xFFF3F0FF),
            iconColor: const Color(0xFF7C3AED),
            value: '$desafiosDisponiveis',
            label: 'Desafios Disponíveis',
          ),
          _StatCard(
            icon: Icons.description_outlined,
            iconBg: AppColors.statusApprovedBg,
            iconColor: AppColors.statusApprovedFg,
            value: '$minhasPropostas',
            label: 'Propostas Enviadas',
          ),
        ]),
        const SizedBox(height: 20),

        // Lista de projetos recentes
        if (meusProjetos.isNotEmpty) ...[
          _sectionTitle('Projetos Recentes'),
          _chartCard(
            title: 'Meus Projetos',
            child: Column(
              children: meusProjetos.take(5).map((p) {
                final eval = EvaluationService.forProject(p.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: p.status == ProjectStatus.evaluated
                            ? AppColors.statusApprovedDot
                            : p.status == ProjectStatus.submitted
                                ? AppColors.primary
                                : AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(p.title,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    if (eval != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: eval.isApproved
                              ? AppColors.statusApprovedBg
                              : AppColors.statusRejectedBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          eval.gradeFormatted,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: eval.isApproved
                                  ? AppColors.statusApprovedFg
                                  : AppColors.statusRejectedFg),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: p.status == ProjectStatus.submitted
                              ? AppColors.statusPendingBg
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.status == ProjectStatus.submitted
                              ? 'Pendente'
                              : 'Rascunho',
                          style: TextStyle(
                              fontSize: 11,
                              color: p.status ==
                                      ProjectStatus.submitted
                                  ? AppColors.statusPendingFg
                                  : AppColors.textMuted),
                        ),
                      ),
                  ]),
                );
              }).toList(),
            ),
          ),
        ] else ...[
          _chartCard(
            title: 'Seus Projetos',
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(children: [
                Icon(Icons.folder_open_outlined,
                    size: 40, color: AppColors.textMuted),
                SizedBox(height: 8),
                Text('Nenhum projeto submetido ainda.',
                    style: TextStyle(color: AppColors.textMuted)),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── PROFESSOR DASHBOARD ──────────────────────────────────────────────────────
class _ProfessorDash extends StatelessWidget {
  final bool mobile;
  const _ProfessorDash({required this.mobile});

  @override
  Widget build(BuildContext context) {
    final uid = AppSession.userId > 0 ? AppSession.userId : 2;
    final minhasAvals = EvaluationService.byTeacher(uid);
    final totalAvaliados = minhasAvals.length;
    final pendentes = kProjectsMock
        .where((p) => p.status == ProjectStatus.submitted)
        .length;
    final notaMedia = minhasAvals.isEmpty
        ? 0.0
        : minhasAvals.map((e) => e.grade).reduce((a, b) => a + b) /
            minhasAvals.length;
    final aprovados =
        minhasAvals.where((e) => e.grade >= 6.0).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dashHeader(
          title: 'Painel do Professor',
          subtitle:
              'Acompanhe avaliações e turmas sob sua responsabilidade',
          icon: Icons.person_outlined,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 24),

        _statsGrid(mobile: mobile, cards: [
          _StatCard(
            icon: Icons.pending_actions_outlined,
            iconBg: AppColors.statusPendingBg,
            iconColor: AppColors.statusPendingFg,
            value: '$pendentes',
            label: 'Pendentes de Avaliação',
          ),
          _StatCard(
            icon: Icons.check_circle_outline,
            iconBg: AppColors.statusApprovedBg,
            iconColor: AppColors.statusApprovedFg,
            value: '$totalAvaliados',
            label: 'Projetos Avaliados',
          ),
          _StatCard(
            icon: Icons.star_outline,
            iconBg: const Color(0xFFFFF8E1),
            iconColor: AppColors.accent,
            value: minhasAvals.isEmpty
                ? '—'
                : notaMedia.toStringAsFixed(1),
            label: 'Média das Avaliações',
          ),
          _StatCard(
            icon: Icons.thumb_up_outlined,
            iconBg: AppColors.statusApprovedBg,
            iconColor: AppColors.statusApprovedFg,
            value: '$aprovados',
            label: 'Aprovados',
          ),
        ]),
        const SizedBox(height: 20),

        if (pendentes > 0) ...[
          _sectionTitle('Projetos Aguardando Avaliação'),
          _chartCard(
            title: 'Fila de Avaliação',
            child: Column(
              children: kProjectsMock
                  .where((p) => p.status == ProjectStatus.submitted)
                  .take(6)
                  .map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              p.studentInitials ?? '??',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(p.title,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(
                                  '${p.studentName ?? '-'} · ${p.classGroupName ?? '-'}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.statusPendingBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Pendente',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.statusPendingFg)),
                          ),
                        ]),
                      ))
                  .toList(),
            ),
          ),
        ],

        if (minhasAvals.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionTitle('Últimas Avaliações'),
          _chartCard(
            title: 'Histórico de Notas',
            child: Column(
              children: minhasAvals.take(5).map((e) {
                final p = kProjectsMock
                    .where((x) => x.id == e.projectId)
                    .firstOrNull;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        p?.title ?? 'Projeto #${e.projectId}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: e.isApproved
                            ? AppColors.statusApprovedBg
                            : AppColors.statusRejectedBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        e.gradeFormatted,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: e.isApproved
                                ? AppColors.statusApprovedFg
                                : AppColors.statusRejectedFg),
                      ),
                    ),
                  ]),
                );
              }).toList(),
            ),
          ),
        ],

        if (minhasAvals.isEmpty && pendentes == 0)
          _chartCard(
            title: 'Avaliações',
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(children: [
                Icon(Icons.rate_review_outlined,
                    size: 40, color: AppColors.textMuted),
                SizedBox(height: 8),
                Text('Nenhuma avaliação registrada ainda.',
                    style: TextStyle(color: AppColors.textMuted)),
              ]),
            ),
          ),
      ],
    );
  }
}

// ─── ADMIN DASHBOARD ──────────────────────────────────────────────────────────
class _AdminDash extends StatelessWidget {
  final bool mobile;
  const _AdminDash({required this.mobile});

  @override
  Widget build(BuildContext context) {
    final totalProjetos = kProjectsMock.length;
    final avaliados =
        kProjectsMock.where((p) => p.status == ProjectStatus.evaluated).length;
    final submetidos = kProjectsMock
        .where((p) => p.status == ProjectStatus.submitted)
        .length;
    final desafios = ChallengeService.all.length;
    final propostas = ChallengeService.totalPropostas;

    final stats = [
      (
        value: '$totalProjetos',
        label: 'Total de Projetos',
        growth: '+12%',
        icon: Icons.bar_chart,
        bg: const Color(0xFFE3F2FD),
        color: const Color(0xFF1565C0),
      ),
      (
        value: '$submetidos',
        label: 'Projetos Submetidos',
        growth: '+8%',
        icon: Icons.upload_outlined,
        bg: const Color(0xFFE8EAF6),
        color: const Color(0xFF3949AB),
      ),
      (
        value: '$avaliados',
        label: 'Projetos Avaliados',
        growth: '+5%',
        icon: Icons.verified_outlined,
        bg: const Color(0xFFE8F5E9),
        color: AppColors.statusApprovedFg,
      ),
      (
        value: '$desafios',
        label: 'Desafios Publicados',
        growth: '+$desafios',
        icon: Icons.lightbulb_outline,
        bg: const Color(0xFFF3F0FF),
        color: const Color(0xFF7C3AED),
      ),
      (
        value: '$propostas',
        label: 'Propostas Recebidas',
        growth: '+$propostas',
        icon: Icons.description_outlined,
        bg: const Color(0xFFFFF8E1),
        color: AppColors.accent,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dashHeader(
          title: 'Painel do Coordenador',
          subtitle: 'Visão geral da plataforma SENAC DevNest',
          icon: Icons.admin_panel_settings_outlined,
          color: const Color(0xFF7C3AED),
        ),
        const SizedBox(height: 24),

        if (mobile)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: stats
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: EdgeInsets.only(
                            right:
                                e.key < stats.length - 1 ? 12 : 0),
                        child: SizedBox(
                            width: 160,
                            child: _AdminStatCard(s: e.value)),
                      ))
                  .toList(),
            ),
          )
        else
          Row(
            children: stats
                .asMap()
                .entries
                .map((e) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right:
                                e.key < stats.length - 1 ? 12 : 0),
                        child: _AdminStatCard(s: e.value),
                      ),
                    ))
                .toList(),
          ),

        const SizedBox(height: 20),
        _ChartRow(
          mobile: mobile,
          children: [
            _chartCard(
              title: 'Evolucao de Projetos por Ano',
              child: const _HoverBarChart(),
            ),
            _chartCard(
              title: 'Visualizações nos Ultimos 6 Meses',
              child: const _HoverLineChart(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ChartRow(
          mobile: mobile,
          children: [
            _chartCard(
              title: 'Projetos por Categoria',
              child: const _HoverPieChart(),
            ),
            _chartCard(
              title: 'Projetos Mais Visualizados',
              child: _TopProjectsList(),
            ),
          ],
        ),
      ],
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final ({
    String value,
    String label,
    String growth,
    IconData icon,
    Color bg,
    Color color,
  }) s;
  const _AdminStatCard({required this.s});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: s.bg,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(s.icon, color: s.color, size: 20),
                ),
                Text(s.growth,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32))),
              ],
            ),
            const SizedBox(height: 14),
            Text(s.value,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(s.label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      );
}

// ─── EMPRESA DASHBOARD ────────────────────────────────────────────────────────
class _EmpresaDash extends StatelessWidget {
  final bool mobile;
  const _EmpresaDash({required this.mobile});

  @override
  Widget build(BuildContext context) {
    final empresaId =
        AppSession.userId > 0 ? AppSession.userId : 101;
    final desafios = ChallengeService.forEmpresa(empresaId);
    final totalDesafios = desafios.length;
    final totalPropostas = desafios.fold(
        0, (s, d) => s + ChallengeService.proposalCountFor(d.id));
    final semResposta = desafios
        .where((d) => ChallengeService.proposalCountFor(d.id) == 0)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dashHeader(
          title: 'Dashboard da Empresa',
          subtitle:
              'Acompanhe seus desafios e propostas recebidas',
          icon: Icons.business_center_outlined,
          color: AppColors.accent,
        ),
        const SizedBox(height: 24),

        _statsGrid(mobile: mobile, cards: [
          _StatCard(
            icon: Icons.lightbulb_outline,
            iconBg: const Color(0xFFF3F0FF),
            iconColor: const Color(0xFF7C3AED),
            value: '$totalDesafios',
            label: 'Desafios Publicados',
          ),
          _StatCard(
            icon: Icons.description_outlined,
            iconBg: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1565C0),
            value: '$totalPropostas',
            label: 'Propostas Recebidas',
          ),
          _StatCard(
            icon: Icons.hourglass_empty_outlined,
            iconBg: AppColors.statusPendingBg,
            iconColor: AppColors.statusPendingFg,
            value: '$semResposta',
            label: 'Sem Proposta',
            subtitle: semResposta > 0 ? 'Atenção necessária' : null,
          ),
        ]),
        const SizedBox(height: 20),

        if (desafios.isNotEmpty) ...[
          _sectionTitle('Engajamento por Desafio'),
          _chartCard(
            title: 'Propostas por Desafio',
            child: Column(
              children: desafios.map((d) {
                final count =
                    ChallengeService.proposalCountFor(d.id);
                final maxCount = desafios.isNotEmpty
                    ? desafios
                        .map((x) =>
                            ChallengeService.proposalCountFor(x.id))
                        .reduce(max)
                    : 1;
                final ratio =
                    maxCount == 0 ? 0.0 : count / maxCount;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                            d.titulo,
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$count proposta${count != 1 ? 's' : ''}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: count > 0
                                  ? AppColors.primary
                                  : AppColors.textMuted),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 6,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            count == 0
                                ? AppColors.statusPendingFg
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ] else
          _chartCard(
            title: 'Seus Desafios',
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(children: [
                Icon(Icons.lightbulb_outline,
                    size: 40, color: AppColors.textMuted),
                SizedBox(height: 8),
                Text('Nenhum desafio publicado ainda.',
                    style: TextStyle(color: AppColors.textMuted)),
                SizedBox(height: 4),
                Text(
                  'Acesse a aba "Desafios" no painel para criar.',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ]),
            ),
          ),
      ],
    );
  }
}

// ─── CHART LAYOUT ─────────────────────────────────────────────────────────────
class _ChartRow extends StatelessWidget {
  final bool mobile;
  final List<Widget> children;
  const _ChartRow({required this.mobile, required this.children});
  @override
  Widget build(BuildContext context) {
    if (mobile) {
      return Column(
        children:
            children.expand((w) => [w, const SizedBox(height: 16)]).toList()
              ..removeLast(),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((w) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: children.indexOf(w) == 0 ? 16 : 0),
                  child: w,
                ),
              ))
          .toList(),
    );
  }
}

// ─── TOOLTIP HELPER ───────────────────────────────────────────────────────────
void _drawTooltip(Canvas canvas, String text, Offset pos, Size size) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  const pad = 8.0;
  final w = tp.width + pad * 2, h = tp.height + pad * 2;
  var dx = pos.dx - w / 2;
  var dy = pos.dy - h - 8;
  dx = dx.clamp(0, size.width - w);
  dy = dy.clamp(0, size.height - h);
  final rect = RRect.fromRectAndRadius(
    Rect.fromLTWH(dx, dy, w, h),
    const Radius.circular(6),
  );
  canvas.drawRRect(rect, Paint()..color = const Color(0xFF1A2035));
  tp.paint(canvas, Offset(dx + pad, dy + pad));
}

// ─── BAR CHART ────────────────────────────────────────────────────────────────
class _HoverBarChart extends StatefulWidget {
  const _HoverBarChart();
  @override
  State<_HoverBarChart> createState() => _HoverBarChartState();
}

class _HoverBarChartState extends State<_HoverBarChart> {
  int? _hovered;
  static const _h = 260.0;
  static const padL = 40.0, padR = 10.0, padT = 10.0, padB = 30.0;

  int? _hitTest(Offset pos, double width) {
    final chartW = width - padL - padR;
    final gap = chartW / _kBarData.length;
    final barW = gap * 0.55;
    for (int i = 0; i < _kBarData.length; i++) {
      final x = padL + i * gap + (gap - barW) / 2;
      if (pos.dx >= x &&
          pos.dx <= x + barW &&
          pos.dy >= padT &&
          pos.dy <= padT + (_h - padB - padT)) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _h,
        child: LayoutBuilder(
          builder: (ctx, box) => MouseRegion(
            cursor: _hovered != null
                ? SystemMouseCursors.click
                : MouseCursor.defer,
            onHover: (e) => setState(
                () => _hovered = _hitTest(e.localPosition, box.maxWidth)),
            onExit: (_) => setState(() => _hovered = null),
            child: CustomPaint(
              size: Size(box.maxWidth, _h),
              painter:
                  _BarPainter(data: _kBarData, hovered: _hovered),
            ),
          ),
        ),
      );
}

class _BarPainter extends CustomPainter {
  final List<(String, double)> data;
  final int? hovered;
  const _BarPainter({required this.data, required this.hovered});

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 40.0, padR = 10.0, padT = 10.0, padB = 30.0;
    final chartW = size.width - padL - padR;
    final chartH = size.height - padB - padT;
    final maxVal = data.map((d) => d.$2).reduce(max);
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    const ts = TextStyle(fontSize: 10, color: AppColors.textMuted);

    for (int i = 0; i <= 4; i++) {
      final y = padT + chartH - (i / 4) * chartH;
      final val = (maxVal * i / 4).round();
      canvas.drawLine(
          Offset(padL, y), Offset(padL + chartW, y), axisPaint);
      final tp = TextPainter(
        text: TextSpan(text: '$val', style: ts),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
          canvas, Offset(padL - tp.width - 4, y - tp.height / 2));
    }

    final gap = chartW / data.length;
    final barW = gap * 0.55;
    for (int i = 0; i < data.length; i++) {
      final (label, val) = data[i];
      final isH = hovered == i;
      final barH = (val / maxVal) * chartH;
      final x = padL + i * gap + (gap - barW) / 2;
      final y = padT + chartH - barH;
      final color = isH ? AppColors.accent : AppColors.primary;
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [color.withValues(alpha: 0.7), color],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(x, y, barW, barH));
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, y, barW, barH),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        paint,
      );
      final tp = TextPainter(
        text: TextSpan(text: label, style: ts),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(x + barW / 2 - tp.width / 2, padT + chartH + 6));
      if (isH) {
        _drawTooltip(
            canvas, '${val.round()} projetos', Offset(x + barW / 2, y), size);
      }
    }
  }

  @override
  bool shouldRepaint(_BarPainter o) => o.hovered != hovered;
}

// ─── LINE CHART ───────────────────────────────────────────────────────────────
class _HoverLineChart extends StatefulWidget {
  const _HoverLineChart();
  @override
  State<_HoverLineChart> createState() => _HoverLineChartState();
}

class _HoverLineChartState extends State<_HoverLineChart> {
  int? _hovered;
  static const _h = 260.0;
  static const padL = 48.0, padR = 10.0;

  int? _hitTest(Offset pos, double width) {
    final chartW = width - padL - padR;
    final relX = pos.dx - padL;
    if (relX < 0 || relX > chartW) return null;
    final gap = chartW / (_kLineData.length - 1);
    return (relX / gap).round().clamp(0, _kLineData.length - 1);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _h,
        child: LayoutBuilder(
          builder: (ctx, box) => MouseRegion(
            cursor: _hovered != null
                ? SystemMouseCursors.click
                : MouseCursor.defer,
            onHover: (e) => setState(
                () => _hovered = _hitTest(e.localPosition, box.maxWidth)),
            onExit: (_) => setState(() => _hovered = null),
            child: CustomPaint(
              size: Size(box.maxWidth, _h),
              painter:
                  _LinePainter(data: _kLineData, hovered: _hovered),
            ),
          ),
        ),
      );
}

class _LinePainter extends CustomPainter {
  final List<(String, double)> data;
  final int? hovered;
  const _LinePainter({required this.data, required this.hovered});

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 48.0,
        padR = 10.0,
        padT = 10.0,
        padB = 30.0;
    final chartW = size.width - padL - padR,
        chartH = size.height - padB - padT;
    final maxVal = data.map((d) => d.$2).reduce(max);
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    const ts = TextStyle(fontSize: 10, color: AppColors.textMuted);

    for (int i = 0; i <= 4; i++) {
      final y = padT + chartH - (i / 4) * chartH;
      final val = ((maxVal * i / 4) / 100).round() * 100;
      canvas.drawLine(
          Offset(padL, y), Offset(padL + chartW, y), axisPaint);
      final tp = TextPainter(
        text: TextSpan(text: '$val', style: ts),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
          canvas, Offset(padL - tp.width - 4, y - tp.height / 2));
    }

    final pts = data.asMap().entries.map((e) {
      final x = padL + e.key * (chartW / (data.length - 1));
      final y = padT + chartH - (e.value.$2 / maxVal) * chartH;
      return Offset(x, y);
    }).toList();

    final fp = Path()..moveTo(pts.first.dx, padT + chartH);
    for (final p in pts) {
      fp.lineTo(p.dx, p.dy);
    }
    fp.lineTo(pts.last.dx, padT + chartH);
    fp.close();
    canvas.drawPath(
      fp,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(
            Rect.fromLTWH(padL, padT, chartW, chartH)),
    );

    final lp = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final cp1 =
          Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 =
          Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      lp.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
      lp,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    for (int i = 0; i < pts.length; i++) {
      final isH = hovered == i;
      canvas.drawCircle(pts[i], isH ? 7 : 5,
          Paint()..color = isH ? AppColors.accent : AppColors.primary);
      canvas.drawCircle(
          pts[i], isH ? 4 : 3, Paint()..color = Colors.white);
      final tp = TextPainter(
        text: TextSpan(text: data[i].$1, style: ts),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(pts[i].dx - tp.width / 2, padT + chartH + 6));
    }

    if (hovered != null) {
      final p = pts[hovered!];
      canvas.drawLine(
        Offset(p.dx, padT),
        Offset(p.dx, padT + chartH),
        Paint()
          ..color = AppColors.primary.withValues(alpha: 0.3)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke
          ..shader = null,
      );
      _drawTooltip(
          canvas, '${data[hovered!].$1}: ${data[hovered!].$2.round()} views', p, size);
    }
  }

  @override
  bool shouldRepaint(_LinePainter o) => o.hovered != hovered;
}

// ─── PIE CHART ────────────────────────────────────────────────────────────────
class _HoverPieChart extends StatefulWidget {
  const _HoverPieChart();
  @override
  State<_HoverPieChart> createState() => _HoverPieChartState();
}

class _HoverPieChartState extends State<_HoverPieChart> {
  int? _hovered;
  static const _h = 300.0;

  int? _hitTest(Offset pos, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = min(cx, cy) - 40;
    final dx = pos.dx - cx, dy = pos.dy - cy;
    final dist = sqrt(dx * dx + dy * dy);
    if (dist > r) return null;
    var angle = atan2(dy, dx) + pi / 2;
    if (angle < 0) angle += 2 * pi;
    double start = 0;
    for (int i = 0; i < _kPieData.length; i++) {
      final sweep = 2 * pi * _kPieData[i].$2;
      if (angle >= start && angle < start + sweep) return i;
      start += sweep;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _h,
        child: LayoutBuilder(
          builder: (ctx, box) => MouseRegion(
            cursor: _hovered != null
                ? SystemMouseCursors.click
                : MouseCursor.defer,
            onHover: (e) => setState(() =>
                _hovered =
                    _hitTest(e.localPosition, Size(box.maxWidth, _h))),
            onExit: (_) => setState(() => _hovered = null),
            child: CustomPaint(
              size: Size(box.maxWidth, _h),
              painter:
                  _PiePainter(data: _kPieData, hovered: _hovered),
            ),
          ),
        ),
      );
}

class _PiePainter extends CustomPainter {
  final List<(String, double, Color)> data;
  final int? hovered;
  const _PiePainter({required this.data, required this.hovered});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = min(cx, cy) - 40;
    const ts =
        TextStyle(fontSize: 10, fontWeight: FontWeight.w600);

    double startAngle = -pi / 2;
    for (int i = 0; i < data.length; i++) {
      final (label, pct, color) = data[i];
      final sweep = 2 * pi * pct;
      final isH = hovered == i;
      final mid = startAngle + sweep / 2;
      final offset = isH ? 8.0 : 0.0;
      final ox = cos(mid) * offset, oy = sin(mid) * offset;

      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(cx + ox, cy + oy),
            radius: isH ? r + 6 : r),
        startAngle,
        sweep,
        true,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(cx + ox, cy + oy),
            radius: isH ? r + 6 : r),
        startAngle,
        sweep,
        true,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      final lx2 = cx + (r + 22) * cos(mid);
      final ly2 = cy + (r + 22) * sin(mid);
      canvas.drawLine(
        Offset(cx + r * cos(mid), cy + r * sin(mid)),
        Offset(lx2, ly2),
        Paint()
          ..color = color
          ..strokeWidth = 1.2,
      );
      final tp = TextPainter(
        text: TextSpan(
            text: '$label: ${(pct * 100).round()}%',
            style: ts.copyWith(color: color)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(lx2 - (cos(mid) > 0 ? 0 : tp.width), ly2 - tp.height / 2));

      startAngle += sweep;
    }

    if (hovered != null) {
      final (label, pct, _) = data[hovered!];
      _drawTooltip(canvas, '$label: ${(pct * 100).round()}%',
          Offset(cx, cy), size);
    }
  }

  @override
  bool shouldRepaint(_PiePainter o) => o.hovered != hovered;
}

// ─── TOP PROJECTS ─────────────────────────────────────────────────────────────
class _TopProjectsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: _kTopProjects.asMap().entries.map((e) {
          final (name, views, likes) = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text('${e.key + 1}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.remove_red_eye_outlined,
                          size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Text('$views views',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary)),
                      const SizedBox(width: 10),
                      const Icon(Icons.trending_up,
                          size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Text('$likes likes',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary)),
                    ]),
                  ],
                ),
              ),
            ]),
          );
        }).toList(),
      );
}

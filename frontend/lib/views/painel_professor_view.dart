import 'package:flutter/material.dart';
import '../controllers/professor_controller.dart';
import '../models/project.dart';
import '../services/ai_analysis_service.dart';
import '../services/evaluation_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_session.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class PainelProfessorView extends StatefulWidget {
  const PainelProfessorView({super.key});

  @override
  State<PainelProfessorView> createState() => _PainelProfessorViewState();
}

class _PainelProfessorViewState extends State<PainelProfessorView> {
  final _ctrl = ProfessorController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final hPad = Responsive.value<double>(
        context, mobile: 16, tablet: 24, desktop: 32);
    final vPad = Responsive.value<double>(
        context, mobile: 20, tablet: 24, desktop: 28);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: (mobile || Responsive.isTablet(context))
          ? const AppDrawer()
          : null,
      body: Column(
        children: [
          const AppNavBar(),
          Expanded(
            child: ListenableBuilder(
              listenable: _ctrl,
              builder: (context, _) => SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: hPad, vertical: vPad),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfHeader(),
                              const SizedBox(height: 20),
                              _ProfStatsRow(ctrl: _ctrl),
                              const SizedBox(height: 20),
                              _FilterRow(ctrl: _ctrl),
                              const SizedBox(height: 16),
                              _ProjectsCard(ctrl: _ctrl),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HEADER ──────────────────────────────────────────────────────────────────
class _ProfHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final nome = AppSession.name;

    return Row(
      children: [
        Container(
          width: mobile ? 38 : 44,
          height: mobile ? 38 : 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.school_outlined,
              color: AppColors.primary, size: mobile ? 20 : 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Painel do Professor',
                style: TextStyle(
                  fontSize: mobile ? 18 : 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                mobile
                    ? 'Avalie os PIs dos alunos'
                    : 'Visualize e avalie os Projetos Integradores submetidos pelos alunos',
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        if (nome.isNotEmpty) ...[
          const SizedBox(width: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─── STATS ROW ────────────────────────────────────────────────────────────────
class _ProfStatsRow extends StatelessWidget {
  final ProfessorController ctrl;
  const _ProfStatsRow({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final cards = [
      _SC(
        value: '${ctrl.totalAll}',
        label: 'Total de PIs',
        icon: Icons.description_outlined,
        bg: const Color(0xFFE3F2FD),
        color: const Color(0xFF1565C0),
      ),
      _SC(
        value: '${ctrl.totalPending}',
        label: 'Aguardando Avaliação',
        icon: Icons.access_time_outlined,
        bg: const Color(0xFFFFF8E1),
        color: const Color(0xFFF9A825),
      ),
      _SC(
        value: '${ctrl.totalEvaluatedByMe}',
        label: 'Avaliados por Mim',
        icon: Icons.fact_check_outlined,
        bg: const Color(0xFFE8F5E9),
        color: AppColors.statusApprovedFg,
      ),
    ];

    if (mobile) {
      return Column(
        children: [
          Row(children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 12),
            Expanded(child: cards[1]),
          ]),
          const SizedBox(height: 12),
          cards[2],
        ],
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
}

class _SC extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color bg, color;
  const _SC({
    required this.value,
    required this.label,
    required this.icon,
    required this.bg,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

// ─── FILTROS ──────────────────────────────────────────────────────────────────
class _FilterRow extends StatelessWidget {
  final ProfessorController ctrl;
  const _FilterRow({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final turmaWidget = _TurmaDropdown(ctrl: ctrl);
    final tabsWidget = _StatusTabs(ctrl: ctrl);

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          turmaWidget,
          const SizedBox(height: 10),
          tabsWidget,
        ],
      );
    }

    return Row(
      children: [
        SizedBox(width: 220, child: turmaWidget),
        const Spacer(),
        tabsWidget,
      ],
    );
  }
}

class _TurmaDropdown extends StatelessWidget {
  final ProfessorController ctrl;
  const _TurmaDropdown({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ctrl.turma != null
              ? AppColors.primary
              : AppColors.border,
        ),
      ),
      child: DropdownButton<String?>(
        value: ctrl.turma,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        style: const TextStyle(
            fontSize: 13, color: AppColors.textPrimary),
        hint: const Text(
          'Filtrar por turma',
          style:
              TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('Todas as turmas'),
          ),
          ...ctrl.turmas.map((t) =>
              DropdownMenuItem<String?>(value: t, child: Text(t))),
        ],
        onChanged: ctrl.setTurma,
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  final ProfessorController ctrl;
  const _StatusTabs({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Tab(
            label: 'Todos',
            active: ctrl.filter == ProfFilter.all,
            onTap: () => ctrl.setFilter(ProfFilter.all),
          ),
          const SizedBox(width: 8),
          _Tab(
            label: 'Pendentes',
            badge: ctrl.totalPending,
            active: ctrl.filter == ProfFilter.pending,
            onTap: () => ctrl.setFilter(ProfFilter.pending),
          ),
          const SizedBox(width: 8),
          _Tab(
            label: 'Avaliados',
            active: ctrl.filter == ProfFilter.evaluated,
            onTap: () => ctrl.setFilter(ProfFilter.evaluated),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final int? badge;
  final bool active;
  final VoidCallback onTap;
  const _Tab(
      {required this.label,
      this.badge,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color:
              active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color:
                  active ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color:
                    active ? Colors.white : AppColors.textSecondary,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withValues(alpha: 0.3)
                      : const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badge',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? Colors.white
                        : const Color(0xFFF9A825),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── PROJECTS CARD ────────────────────────────────────────────────────────────
class _ProjectsCard extends StatelessWidget {
  final ProfessorController ctrl;
  const _ProjectsCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.all(mobile ? 16 : 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Row(
              children: [
                _CardTitle(),
              ],
            )
          else
            const _CardTitle(),
          const SizedBox(height: 16),
          Responsive.isDesktop(context)
              ? _ProfTable(ctrl: ctrl)
              : _ProfCardList(ctrl: ctrl),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projetos Integradores',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Clique em "Avaliar" para registrar nota e feedback',
            style:
                TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      );
}

// ─── DESKTOP TABLE ────────────────────────────────────────────────────────────
class _ProfTable extends StatelessWidget {
  final ProfessorController ctrl;
  const _ProfTable({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final projects = ctrl.filteredProjects;
    if (projects.isEmpty) return _empty();

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.4),
        1: FlexColumnWidth(1.8),
        2: FlexColumnWidth(1.0),
        3: FlexColumnWidth(1.1),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(2.8),
      },
      children: [
        _headerRow(),
        ...projects
            .asMap()
            .entries
            .map((e) => _dataRow(context, e.key, e.value)),
      ],
    );
  }

  TableRow _headerRow() {
    const cols = [
      'PROJETO',
      'ALUNO',
      'TURMA',
      'NOTA',
      'STATUS',
      'AÇÕES'
    ];
    return TableRow(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColors.border))),
      children: cols
          .asMap()
          .entries
          .map((e) => Padding(
                padding:
                    const EdgeInsets.only(bottom: 12, right: 8),
                child: Text(
                  e.value,
                  textAlign: e.key == cols.length - 1
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 0.05,
                  ),
                ),
              ))
          .toList(),
    );
  }

  TableRow _dataRow(BuildContext context, int idx, Project p) {
    final eval = EvaluationService.forProject(p.id);
    final date =
        '${p.createdAt.day.toString().padLeft(2, '0')}/${p.createdAt.month.toString().padLeft(2, '0')}/${p.createdAt.year}';

    return TableRow(
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(color: Color(0xFFF3F4F6)))),
      children: [
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor:
                    kAvatarColors[idx % kAvatarColors.length],
                child: Text(
                  p.studentInitials ?? '??',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  p.studentName ?? '-',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            p.classGroupName ?? '-',
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
          ),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: eval != null
              ? _GradeChip(eval.grade)
              : const Text('—',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textMuted)),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Wrap(spacing: 6, runSpacing: 4, children: [
            StatusBadge(p.status),
            if (p.isResubmission)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4)),
                ),
                child: const Text('Reenvio',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent)),
              ),
          ]),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 4,
            runSpacing: 4,
            children: [
              if (p.status == ProjectStatus.submitted)
                ActionBtn(
                  label: 'Avaliar',
                  icon: Icons.rate_review_outlined,
                  borderColor: AppColors.primary,
                  textColor: AppColors.primary,
                  onPressed: () => _EvalDialog.show(
                    context,
                    project: p,
                    existing: null,
                    onSaved: () => _findCtrl(context)
                        ?.markEvaluated(p.id),
                  ),
                )
              else
                ActionBtn(
                  label: 'Ver Avaliação',
                  icon: Icons.visibility_outlined,
                  borderColor: AppColors.secondary,
                  textColor: AppColors.secondary,
                  onPressed: () => _EvalDialog.show(
                    context,
                    project: p,
                    existing: eval,
                    onSaved: null,
                  ),
                ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _cell(Widget child) =>
      Padding(padding: const EdgeInsets.only(right: 8), child: child);

  Widget _empty() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Nenhum projeto encontrado.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );

  ProfessorController? _findCtrl(BuildContext ctx) {
    final state = ctx.findAncestorStateOfType<_PainelProfessorViewState>();
    return state?._ctrl;
  }
}

// ─── MOBILE / TABLET CARDS ────────────────────────────────────────────────────
class _ProfCardList extends StatelessWidget {
  final ProfessorController ctrl;
  const _ProfCardList({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final projects = ctrl.filteredProjects;
    if (projects.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Nenhum projeto encontrado.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return Column(
      children: projects
          .asMap()
          .entries
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProjCard(
                  project: e.value,
                  idx: e.key,
                  ctrl: ctrl,
                ),
              ))
          .toList(),
    );
  }
}

class _ProjCard extends StatelessWidget {
  final Project project;
  final int idx;
  final ProfessorController ctrl;
  const _ProjCard(
      {required this.project,
      required this.idx,
      required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final p = project;
    final eval = EvaluationService.forProject(p.id);
    final date =
        '${p.createdAt.day.toString().padLeft(2, '0')}/${p.createdAt.month.toString().padLeft(2, '0')}/${p.createdAt.year}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  p.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(p.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor:
                    kAvatarColors[idx % kAvatarColors.length],
                child: Text(
                  p.studentInitials ?? '??',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  p.studentName ?? '-',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.group_outlined,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                p.classGroupName ?? '-',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.calendar_today_outlined,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          if (eval != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.grade_outlined,
                    size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  'Nota: ${eval.gradeFormatted}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: eval.isApproved
                        ? AppColors.statusApprovedFg
                        : AppColors.statusRejectedFg,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: p.status == ProjectStatus.submitted
                ? ElevatedButton.icon(
                    onPressed: () => _EvalDialog.show(
                      context,
                      project: p,
                      existing: null,
                      onSaved: () => ctrl.markEvaluated(p.id),
                    ),
                    icon: const Icon(Icons.rate_review_outlined,
                        size: 16),
                    label: const Text(
                      'Avaliar Projeto',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: () => _EvalDialog.show(
                      context,
                      project: p,
                      existing: eval,
                      onSaved: null,
                    ),
                    icon: const Icon(Icons.visibility_outlined,
                        size: 16),
                    label: const Text(
                      'Ver Avaliação',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── GRADE CHIP ───────────────────────────────────────────────────────────────
class _GradeChip extends StatelessWidget {
  final double grade;
  const _GradeChip(this.grade);

  @override
  Widget build(BuildContext context) {
    final approved = grade >= 6.0;
    final color = approved
        ? AppColors.statusApprovedFg
        : AppColors.statusRejectedFg;
    final bg = approved
        ? AppColors.statusApprovedBg
        : AppColors.statusRejectedBg;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        grade.toStringAsFixed(2),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─── EVALUATION DIALOG ────────────────────────────────────────────────────────
class _EvalDialog extends StatefulWidget {
  final Project project;
  final EvaluationEntry? existing;
  final VoidCallback? onSaved;

  const _EvalDialog({
    required this.project,
    required this.existing,
    required this.onSaved,
  });

  static Future<void> show(
    BuildContext ctx, {
    required Project project,
    required EvaluationEntry? existing,
    required VoidCallback? onSaved,
  }) =>
      showDialog(
        context: ctx,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        builder: (_) => _EvalDialog(
          project: project,
          existing: existing,
          onSaved: onSaved,
        ),
      );

  @override
  State<_EvalDialog> createState() => _EvalDialogState();
}

class _EvalDialogState extends State<_EvalDialog> {
  late double _metodologia;
  late double _inovacao;
  late double _implementacao;
  late double _documentacao;
  late double _apresentacao;
  late final TextEditingController _feedbackCtrl;
  bool _saving = false;

  ProjectAnalysis? _aiResult;
  bool _aiLoading = false;
  bool _aiExpanded = true;

  bool get _readOnly => widget.existing != null && widget.onSaved == null;

  double get _grade =>
      (_metodologia + _inovacao + _implementacao + _documentacao + _apresentacao) /
      5.0;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _metodologia = e?.criterioMetodologia ?? 5.0;
    _inovacao = e?.criterioInovacao ?? 5.0;
    _implementacao = e?.criterioImplementacao ?? 5.0;
    _documentacao = e?.criterioDocumentacao ?? 5.0;
    _apresentacao = e?.criterioApresentacao ?? 5.0;
    _feedbackCtrl = TextEditingController(text: e?.feedback ?? '');
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  Future<void> _analyzeWithAI() async {
    setState(() { _aiLoading = true; _aiResult = null; });
    final p = widget.project;
    final techs = (p.technologies ?? '')
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    final result = await MockAiAnalysisService().analyzeProject(
      title: p.title,
      description: p.description,
      technologies: techs,
      classGroup: p.classGroupName ?? '',
      feedback: _feedbackCtrl.text.trim(),
    );
    if (mounted) {
      setState(() {
        _aiResult = result;
        _aiLoading = false;
        _aiExpanded = true;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 300));
    EvaluationService.save(
      projectId: widget.project.id,
      teacherId: AppSession.userId,
      teacherName: AppSession.name.isNotEmpty
          ? AppSession.name
          : 'Professor',
      criterioMetodologia: _metodologia,
      criterioInovacao: _inovacao,
      criterioImplementacao: _implementacao,
      criterioDocumentacao: _documentacao,
      criterioApresentacao: _apresentacao,
      feedback: _feedbackCtrl.text.trim(),
    );
    widget.onSaved?.call();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final narrow = w < 700;
    final approved = _grade >= 6.0;
    final modalW = (w * 0.92).clamp(340.0, 960.0);

    // ── Rubrica column content ────────────────────────────────────
    Widget rubricaColumn = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rubrica de Avaliação',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cada critério: 0,0 a 10,0 — Nota Final = média dos 5',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          _CriterioSlider(
            label: 'Metodologia e Planejamento',
            value: _metodologia,
            readOnly: _readOnly,
            onChanged: (v) => setState(() => _metodologia = v),
          ),
          _CriterioSlider(
            label: 'Inovação e Criatividade',
            value: _inovacao,
            readOnly: _readOnly,
            onChanged: (v) => setState(() => _inovacao = v),
          ),
          _CriterioSlider(
            label: 'Implementação Técnica',
            value: _implementacao,
            readOnly: _readOnly,
            onChanged: (v) => setState(() => _implementacao = v),
          ),
          _CriterioSlider(
            label: 'Qualidade da Documentação',
            value: _documentacao,
            readOnly: _readOnly,
            onChanged: (v) => setState(() => _documentacao = v),
          ),
          _CriterioSlider(
            label: 'Apresentação e Comunicação',
            value: _apresentacao,
            readOnly: _readOnly,
            onChanged: (v) => setState(() => _apresentacao = v),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: approved
                  ? AppColors.statusApprovedBg
                  : AppColors.statusRejectedBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: approved
                    ? AppColors.statusApprovedDot
                    : AppColors.statusRejectedDot,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  approved
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  color: approved
                      ? AppColors.statusApprovedFg
                      : AppColors.statusRejectedFg,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nota Final: ${_grade.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: approved
                              ? AppColors.statusApprovedFg
                              : AppColors.statusRejectedFg,
                        ),
                      ),
                      Text(
                        approved
                            ? 'Aprovado — nota ≥ 6,00'
                            : 'Não aprovado — nota < 6,00',
                        style: TextStyle(
                          fontSize: 11,
                          color: approved
                              ? AppColors.statusApprovedFg
                              : AppColors.statusRejectedFg,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // ── IA column content ─────────────────────────────────────────
    Widget iaColumn = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Análise por IA',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Utilize a IA para obter sugestões de avaliação baseadas no projeto',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          if (!_readOnly)
            _AiAnalyzeButton(
              loading: _aiLoading,
              onTap: _analyzeWithAI,
            ),
          if (_aiResult != null) ...[
            if (!_readOnly) const SizedBox(height: 12),
            _AiResultPanel(
              result: _aiResult!,
              expanded: _aiExpanded,
              onToggle: () =>
                  setState(() => _aiExpanded = !_aiExpanded),
            ),
          ],
          if (_readOnly && _aiResult == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Nenhuma análise de IA registrada para esta avaliação.',
                style: TextStyle(
                    fontSize: 12, color: AppColors.textMuted),
              ),
            ),
        ],
      ),
    );

    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(
          horizontal: w < 400 ? 8 : 20, vertical: 24),
      child: SizedBox(
        width: modalW,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.rate_review_outlined,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _readOnly
                              ? 'Avaliação Registrada'
                              : 'Avaliar Projeto',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          widget.project.title,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close,
                        size: 20, color: AppColors.textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // ── Body ─────────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aluno + turma info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary
                                .withValues(alpha: 0.15),
                            child: Text(
                              widget.project.studentInitials ?? '??',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.project.studentName ?? '-',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  widget.project.classGroupName ?? '-',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          if (_readOnly && widget.existing != null)
                            _GradeChip(widget.existing!.grade),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Two-column layout (rubrica + IA) ──────────
                    if (!narrow)
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: rubricaColumn),
                            const SizedBox(width: 16),
                            Expanded(child: iaColumn),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          rubricaColumn,
                          const SizedBox(height: 16),
                          iaColumn,
                        ],
                      ),

                    const SizedBox(height: 16),

                    // ── Feedback (full width) ─────────────────────
                    const Text(
                      'Feedback para o Aluno',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _feedbackCtrl,
                      maxLines: 4,
                      readOnly: _readOnly,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText:
                            'Descreva os pontos fortes, melhorias sugeridas e observações gerais...',
                        hintStyle: const TextStyle(
                            fontSize: 13, color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.primary),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),

                    if (_readOnly &&
                        widget.existing?.teacherName != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Avaliado por: ${widget.existing!.teacherName}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Footer ───────────────────────────────────────────
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: _readOnly
                  ? SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(
                              color: AppColors.border),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Fechar',
                            style: TextStyle(fontSize: 14)),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saving ? null : _save,
                            icon: _saving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.save_outlined, size: 16),
                            label: Text(
                              _saving
                                  ? 'Salvando...'
                                  : 'Salvar Avaliação',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: const BorderSide(
                                color: AppColors.border),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10)),
                          ),
                          child: const Text('Cancelar',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── AI ANALYZE BUTTON ───────────────────────────────────────────────────────
class _AiAnalyzeButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;
  const _AiAnalyzeButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: loading ? null : onTap,
        icon: loading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.auto_awesome_outlined, size: 16),
        label: Text(
          loading ? 'Analisando com IA...' : 'Analisar com IA',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6C3DE8),
          side: const BorderSide(color: Color(0xFF6C3DE8)),
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

// ─── AI RESULT PANEL ─────────────────────────────────────────────────────────
class _AiResultPanel extends StatelessWidget {
  final ProjectAnalysis result;
  final bool expanded;
  final VoidCallback onToggle;
  const _AiResultPanel({
    required this.result,
    required this.expanded,
    required this.onToggle,
  });

  static const _purple = Color(0xFF6C3DE8);
  static const _purpleBg = Color(0xFFF3EFFD);
  static const _purpleBorder = Color(0xFFCBB8F8);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _purpleBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _purpleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — sempre visível
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: Colors.white, size: 15),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Análise por IA',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _purple,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: _purple,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Body — expansível
          if (expanded) ...[
            const Divider(height: 1, color: _purpleBorder),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disclaimer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 13, color: _purple),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Análise gerada por IA — a nota final é definida pelo professor',
                            style: TextStyle(
                                fontSize: 11,
                                color: _purple,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Pontos fortes
                  _SectionTitle(
                      icon: Icons.thumb_up_alt_outlined,
                      label: 'Pontos Fortes'),
                  const SizedBox(height: 6),
                  ...result.strengths.map(
                    (s) => _BulletItem(text: s, color: _purple),
                  ),
                  const SizedBox(height: 12),

                  // Sugestões por critério
                  _SectionTitle(
                      icon: Icons.tips_and_updates_outlined,
                      label: 'Sugestões por Critério'),
                  const SizedBox(height: 6),
                  ...result.criterioSugestoes.entries.map(
                    (e) => _CriterioItem(
                      criterio: e.key,
                      texto: e.value,
                      faixa: result.criterioFaixas[e.key],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF6C3DE8)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6C3DE8),
            ),
          ),
        ],
      );
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;
  const _BulletItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4, left: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textPrimary)),
            ),
          ],
        ),
      );
}

class _CriterioItem extends StatelessWidget {
  final String criterio;
  final String texto;
  final String? faixa;
  const _CriterioItem(
      {required this.criterio, required this.texto, this.faixa});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    criterio,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (faixa != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C3DE8).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Sugerido: $faixa',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C3DE8),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              texto,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
}

// ─── CRITERIO SLIDER ─────────────────────────────────────────────────────────
class _CriterioSlider extends StatelessWidget {
  final String label;
  final double value;
  final bool readOnly;
  final ValueChanged<double> onChanged;

  const _CriterioSlider({
    required this.label,
    required this.value,
    required this.readOnly,
    required this.onChanged,
  });

  Color _color(double v) {
    if (v >= 8.0) return AppColors.statusApprovedFg;
    if (v >= 6.0) return const Color(0xFFF9A825);
    return AppColors.statusRejectedFg;
  }

  @override
  Widget build(BuildContext context) {
    final c = _color(value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                width: 44,
                alignment: Alignment.centerRight,
                child: Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: c,
              inactiveTrackColor: c.withValues(alpha: 0.2),
              thumbColor: c,
              overlayColor: c.withValues(alpha: 0.1),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 7),
            ),
            child: Slider(
              value: value,
              min: 0.0,
              max: 10.0,
              divisions: 20,
              label: value.toStringAsFixed(1),
              onChanged: readOnly ? null : onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

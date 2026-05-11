import 'package:flutter/material.dart';
import '../controllers/admin_controller.dart';
import '../models/project.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/project_detail_dialog.dart';

class AdminPanelView extends StatefulWidget {
  const AdminPanelView({super.key});

  @override
  State<AdminPanelView> createState() => _AdminPanelViewState();
}

class _AdminPanelViewState extends State<AdminPanelView> {
  final _controller = AdminController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Responsive.isMobile(context) || Responsive.isTablet(context)
          ? const AppDrawer()
          : null,
      body: Column(
        children: [
          const AppNavBar(),
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.value(context,
                                mobile: 16.0, tablet: 24.0, desktop: 32.0),
                            vertical: Responsive.value(context,
                                mobile: 20.0, tablet: 24.0, desktop: 28.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _PageHeader(),
                              const SizedBox(height: 20),
                              _StatsGrid(controller: _controller),
                              const SizedBox(height: 20),
                              _ProjectsCard(controller: _controller),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const AppFooter(),
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

// ─── PAGE HEADER ─────────────────────────────────────────────────────────────
class _PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Row(
      children: [
        Container(
          width: mobile ? 38 : 44,
          height: mobile ? 38 : 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F7FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.shield_outlined,
              color: AppColors.secondary, size: mobile ? 20 : 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gestao e Aprovacao de Projetos',
                  style: TextStyle(
                      fontSize: mobile ? 17 : 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(
                  mobile
                      ? 'Revisao de PIs submetidos'
                      : 'Painel exclusivo da coordenacao para revisao de PIs submetidos',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── STATS GRID (responsivo) ──────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final AdminController controller;
  const _StatsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);

    final cards = [
      _StatCard(
        icon: Icons.grid_view_rounded,
        iconBg: const Color(0xFFE0F7FA),
        iconColor: AppColors.primary,
        value: '${controller.totalSubmissions}',
        valueColor: AppColors.primary,
        label: 'Total de Submissoes',
        topRight: const Text('Total',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ),
      _StatCard(
        icon: Icons.access_time_rounded,
        iconBg: const Color(0xFFFFF3E0),
        iconColor: AppColors.accent,
        value: '${controller.totalPending}',
        valueColor: AppColors.accent,
        label: 'Projetos Pendentes',
        topRight: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20)),
          child: Text('${controller.totalPending} aguardando',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE65100))),
        ),
      ),
      _StatCard(
        icon: Icons.file_copy_outlined,
        iconBg: const Color(0xFFE0F2F1),
        iconColor: AppColors.secondary,
        value: '${controller.totalEvaluated}',
        valueColor: AppColors.secondary,
        label: 'Avaliados',
        topRight: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
              color: AppColors.statusApprovedBg,
              borderRadius: BorderRadius.circular(20)),
          child: Text('${controller.totalEvaluated} avaliados',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.statusApprovedFg)),
        ),
      ),
    ];

    if (mobile) {
      // Mobile: coluna única
      return Column(
        children: cards
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: c,
                ))
            .toList(),
      );
    }

    if (Responsive.isTablet(context)) {
      // Tablet: 2 cards na primeira linha + 1 embaixo
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 14),
              Expanded(child: cards[1]),
            ],
          ),
          const SizedBox(height: 14),
          cards[2],
        ],
      );
    }

    // Desktop: 3 cards em linha
    return Row(
      children: cards
          .map((c) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: cards.indexOf(c) < cards.length - 1 ? 16 : 0),
                  child: c,
                ),
              ))
          .toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final Color valueColor;
  final String label;
  final Widget topRight;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.valueColor,
    required this.label,
    required this.topRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                width: 36, height: 36,
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              topRight,
            ],
          ),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 28 : 32,
                  fontWeight: FontWeight.w700,
                  color: valueColor)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── PROJECTS CARD ───────────────────────────────────────────────────────────
class _ProjectsCard extends StatelessWidget {
  final AdminController controller;
  const _ProjectsCard({required this.controller});

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
          // Header + filtros
          if (Responsive.isDesktop(context)) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CardTitle(),
                const Spacer(),
                _FilterTabs(controller: controller),
              ],
            ),
          ] else ...[
            const _CardTitle(),
            const SizedBox(height: 12),
            _FilterTabs(controller: controller),
          ],
          const SizedBox(height: 16),
          // Tabela só no desktop — cards no mobile e tablet
          if (Responsive.isDesktop(context))
            _ProjectsTable(controller: controller)
          else
            _ProjectCardList(controller: controller),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fila de Revisao de Projetos',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        SizedBox(height: 3),
        Text('Gerencie as submissoes de Projetos Integradores',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }
}

// ─── FILTER TABS ─────────────────────────────────────────────────────────────
class _FilterTabs extends StatelessWidget {
  final AdminController controller;
  const _FilterTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Tab(label: 'Todos',    active: controller.filter == AdminFilter.all,      onTap: () => controller.setFilter(AdminFilter.all)),
          SizedBox(width: mobile ? 6 : 8),
          _Tab(label: 'Pendente', badge: controller.totalPending, active: controller.filter == AdminFilter.pending,   onTap: () => controller.setFilter(AdminFilter.pending)),
          SizedBox(width: mobile ? 6 : 8),
          _Tab(label: 'Avaliado', active: controller.filter == AdminFilter.evaluated, onTap: () => controller.setFilter(AdminFilter.evaluated)),
          SizedBox(width: mobile ? 6 : 8),
          _Tab(label: 'Reprovado',active: controller.filter == AdminFilter.rejected,  onTap: () => controller.setFilter(AdminFilter.rejected)),
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
  const _Tab({required this.label, this.badge, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: active ? Colors.white : AppColors.textSecondary)),
            if (badge != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withValues(alpha: 0.3)
                      : AppColors.statusRejectedBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$badge',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : AppColors.statusRejectedFg)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── MOBILE: PROJECT CARDS ────────────────────────────────────────────────────
class _ProjectCardList extends StatelessWidget {
  final AdminController controller;
  const _ProjectCardList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final projects = controller.filteredProjects;
    if (projects.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
            child: Text('Nenhum projeto encontrado.',
                style: TextStyle(color: AppColors.textMuted))),
      );
    }
    return Column(
      children: projects.asMap().entries.map((e) =>
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _MobileProjectCard(
              project: e.value,
              index: e.key,
              controller: controller,
            ),
          )).toList(),
    );
  }
}

class _MobileProjectCard extends StatelessWidget {
  final Project project;
  final int index;
  final AdminController controller;
  const _MobileProjectCard({required this.project, required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    final p = project;
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
                child: Text(p.title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ),
              const SizedBox(width: 8),
              StatusBadge(p.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: kAvatarColors[index % kAvatarColors.length],
                child: Text(p.studentInitials ?? '??',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(p.studentName ?? '-',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.group_outlined, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(p.classGroupName ?? '-',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(date,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          if (p.status == ProjectStatus.submitted) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ProjectDetailDialog.show(
                      context,
                      project: p,
                      onApprove: controller.approveProject,
                      onReject: (proj, feedback) => controller.rejectProject(proj),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 14),
                    label: const Text('Aprovar', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.statusApprovedFg,
                      side: const BorderSide(color: Color(0xFFA7D7A8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ProjectDetailDialog.show(
                      context,
                      project: p,
                      onApprove: controller.approveProject,
                      onReject: (proj, feedback) => controller.rejectProject(proj),
                    ),
                    icon: const Icon(Icons.cancel_outlined, size: 14),
                    label: const Text('Reprovar', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.statusRejectedFg,
                      side: const BorderSide(color: Color(0xFFF4B8B8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.remove_red_eye_outlined, size: 14),
              label: const Text('Ver Detalhes', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── DESKTOP/TABLET: TABLE ────────────────────────────────────────────────────
class _ProjectsTable extends StatelessWidget {
  final AdminController controller;
  const _ProjectsTable({required this.controller});

  @override
  Widget build(BuildContext context) {
    final projects = controller.filteredProjects;
    if (projects.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
            child: Text('Nenhum projeto encontrado.',
                style: TextStyle(color: AppColors.textMuted))),
      );
    }
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(2.0),
        2: FlexColumnWidth(1.0),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(3.4),
      },
      children: [
        _headerRow(),
        ...projects.asMap().entries.map((e) => _dataRow(context, e.key, e.value)),
      ],
    );
  }

  TableRow _headerRow() {
    const cols = ['PROJETO', 'ALUNO LIDER', 'TURMA', 'SUBMISSAO', 'STATUS', 'ACOES'];
    return TableRow(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border))),
      children: cols.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12, right: 8),
            child: Text(e.value,
                textAlign: e.key == cols.length - 1 ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 0.05)),
          )).toList(),
    );
  }

  TableRow _dataRow(BuildContext context, int index, Project p) {
    final date =
        '${p.createdAt.day.toString().padLeft(2, '0')}/${p.createdAt.month.toString().padLeft(2, '0')}/${p.createdAt.year}';

    return TableRow(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
      children: [
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(p.title,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: kAvatarColors[index % kAvatarColors.length],
              child: Text(p.studentInitials ?? '??',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(width: 8),
            Flexible(child: Text(p.studentName ?? '-',
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
          ]),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(p.classGroupName ?? '-',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(date,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: StatusBadge(p.status),
        )),
        _cell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 4,
            runSpacing: 4,
            children: [
              ActionBtn(
                label: 'Detalhes',
                icon: Icons.remove_red_eye_outlined,
                borderColor: const Color(0xFFD1D5DB),
                textColor: AppColors.textSecondary,
                onPressed: () => ProjectDetailDialog.show(
                  context,
                  project: p,
                  onApprove: controller.approveProject,
                  onReject: (proj, feedback) => controller.rejectProject(proj),
                ),
              ),
              if (p.status == ProjectStatus.submitted) ...[
                ActionBtn(
                  label: 'Aprovar',
                  icon: Icons.check_circle_outline,
                  borderColor: const Color(0xFFA7D7A8),
                  textColor: AppColors.statusApprovedFg,
                  onPressed: () => ProjectDetailDialog.show(
                    context,
                    project: p,
                    onApprove: controller.approveProject,
                    onReject: (proj, feedback) => controller.rejectProject(proj),
                  ),
                ),
                ActionBtn(
                  label: 'Reprovar',
                  icon: Icons.cancel_outlined,
                  borderColor: const Color(0xFFF4B8B8),
                  textColor: AppColors.statusRejectedFg,
                  onPressed: () => ProjectDetailDialog.show(
                    context,
                    project: p,
                    onApprove: controller.approveProject,
                    onReject: (proj, feedback) => controller.rejectProject(proj),
                  ),
                ),
              ],
            ],
          ),
        )),
      ],
    );
  }

  Widget _cell(Widget child) =>
      Padding(padding: const EdgeInsets.only(right: 8), child: child);
}
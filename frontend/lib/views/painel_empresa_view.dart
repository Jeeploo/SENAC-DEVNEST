import 'package:flutter/material.dart';
import '../services/challenge_service.dart';
import '../services/interest_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_session.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';
import 'desafios_empresa_section.dart';

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class PainelEmpresaView extends StatelessWidget {
  const PainelEmpresaView({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final hPad = Responsive.value<double>(
        context, mobile: 16, tablet: 24, desktop: 32);
    final vPad = Responsive.value<double>(
        context, mobile: 20, tablet: 24, desktop: 28);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: (mobile || Responsive.isTablet(context))
            ? const AppDrawer()
            : null,
        body: Column(
          children: [
            const AppNavBar(),
            Container(
              color: AppColors.surface,
              child: const TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: 'Propostas Recebidas'),
                  Tab(text: 'Meus Desafios'),
                  Tab(text: 'Talentos & Projetos'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _PropostasTab(hPad: hPad, vPad: vPad),
                  const DesafiosEmpresaSection(),
                  const _TalentosTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── TAB: PROPOSTAS RECEBIDAS ─────────────────────────────────────────────────
class _PropostasTab extends StatelessWidget {
  final double hPad, vPad;
  const _PropostasTab({required this.hPad, required this.vPad});

  @override
  Widget build(BuildContext context) {
    final empresaId =
        AppSession.userId > 0 ? AppSession.userId : 101;
    final desafios = ChallengeService.forEmpresa(empresaId);
    final totalPropostas = desafios.fold(
        0, (s, d) => s + ChallengeService.proposalCountFor(d.id));
    final desafiosSemResposta = desafios
        .where((d) => ChallengeService.proposalCountFor(d.id) == 0)
        .length;

    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _Header(),
                    const SizedBox(height: 20),

                    // Stats
                    _StatsRow(
                      totalDesafios: desafios.length,
                      totalPropostas: totalPropostas,
                      semResposta: desafiosSemResposta,
                    ),
                    const SizedBox(height: 24),

                    if (desafios.isEmpty)
                      _emptyState()
                    else ...[
                      const Text(
                        'Propostas por Desafio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...desafios.map((d) {
                        final props =
                            ChallengeService.proposalsFor(d.id);
                        return _DesafioPropostasCard(
                            desafio: d, propostas: props);
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined,
                size: 40, color: AppColors.textMuted),
            SizedBox(height: 10),
            Text('Nenhum desafio publicado ainda.',
                style: TextStyle(color: AppColors.textMuted)),
            SizedBox(height: 4),
            Text('Vá à aba "Meus Desafios" para criar um.',
                style: TextStyle(
                    fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      );
}

// ─── HEADER ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final empresa = AppSession.name;

    return Row(
      children: [
        Container(
          width: mobile ? 38 : 44,
          height: mobile ? 38 : 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.inbox_outlined,
              color: Colors.white, size: mobile ? 20 : 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Propostas Recebidas',
                style: TextStyle(
                  fontSize: mobile ? 18 : 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                mobile
                    ? 'Respostas dos alunos aos seus desafios'
                    : 'Visualize todas as propostas que os alunos enviaram para seus desafios',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        if (empresa.isNotEmpty) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.business_outlined,
                    size: 13, color: AppColors.accent),
                const SizedBox(width: 6),
                Text(
                  empresa,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
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
class _StatsRow extends StatelessWidget {
  final int totalDesafios, totalPropostas, semResposta;
  const _StatsRow({
    required this.totalDesafios,
    required this.totalPropostas,
    required this.semResposta,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final cards = [
      _SC(
        icon: Icons.lightbulb_outline,
        iconBg: const Color(0xFFF3F0FF),
        iconColor: const Color(0xFF7C3AED),
        value: '$totalDesafios',
        label: 'Desafios Ativos',
      ),
      _SC(
        icon: Icons.description_outlined,
        iconBg: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1565C0),
        value: '$totalPropostas',
        label: 'Propostas Recebidas',
      ),
      _SC(
        icon: Icons.hourglass_empty_outlined,
        iconBg: AppColors.statusPendingBg,
        iconColor: AppColors.statusPendingFg,
        value: '$semResposta',
        label: 'Desafios Sem Proposta',
      ),
    ];

    if (mobile) {
      return Column(children: [
        Row(children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 12),
          Expanded(child: cards[1]),
        ]),
        const SizedBox(height: 12),
        cards[2],
      ]);
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
  final IconData icon;
  final Color iconBg, iconColor;
  final String value, label;
  const _SC({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
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
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      )),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      );
}

// ─── DESAFIO + PROPOSTAS CARD ─────────────────────────────────────────────────
class _DesafioPropostasCard extends StatefulWidget {
  final Desafio desafio;
  final List<Proposta> propostas;
  const _DesafioPropostasCard(
      {required this.desafio, required this.propostas});

  @override
  State<_DesafioPropostasCard> createState() =>
      _DesafioPropostasCardState();
}

class _DesafioPropostasCardState
    extends State<_DesafioPropostasCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.desafio;
    final props = widget.propostas;
    final hasProps = props.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasProps
                ? AppColors.primary.withValues(alpha: 0.25)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: hasProps
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.lightbulb_outline,
                    color:
                        hasProps ? AppColors.primary : AppColors.textMuted,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.titulo,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Row(children: [
                        _tag(d.area, AppColors.primary),
                        const SizedBox(width: 6),
                        _tag(d.dificuldade,
                            d.dificuldade == 'Avançado'
                                ? AppColors.statusRejectedFg
                                : d.dificuldade == 'Intermediário'
                                    ? AppColors.statusPendingFg
                                    : AppColors.statusApprovedFg),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: hasProps
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${props.length} proposta${props.length != 1 ? 's' : ''}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: hasProps
                            ? AppColors.primary
                            : AppColors.textMuted),
                  ),
                ),
                if (hasProps) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _expanded = !_expanded),
                    child: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ]),
            ),

            // Expanded propostas list
            if (_expanded && hasProps) ...[
              const Divider(height: 1, color: AppColors.border),
              ...props.map((p) => _PropostaRow(proposta: p)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color color) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color)),
      );
}

class _PropostaRow extends StatelessWidget {
  final Proposta proposta;
  const _PropostaRow({required this.proposta});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              proposta.nomeAluno.isNotEmpty
                  ? proposta.nomeAluno[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(proposta.nomeAluno,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(
                  proposta.descricaoSolucao,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: proposta.status == 'pendente'
                  ? AppColors.statusPendingBg
                  : AppColors.statusApprovedBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              proposta.status == 'pendente' ? 'Pendente' : 'Aceita',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: proposta.status == 'pendente'
                      ? AppColors.statusPendingFg
                      : AppColors.statusApprovedFg),
            ),
          ),
        ]),
      );
}

// ─── MODEL: PROJETO DE ALUNO (mock local) ─────────────────────────────────────
class _TalentProject {
  final int id;
  final int alunoId;
  final String alunoNome;
  final String titulo;
  final String descricao;
  final List<String> techs;
  final String turma;
  const _TalentProject({
    required this.id,
    required this.alunoId,
    required this.alunoNome,
    required this.titulo,
    required this.descricao,
    required this.techs,
    required this.turma,
  });
}

const _kMockProjects = [
  _TalentProject(
    id: 1, alunoId: 1, alunoNome: 'Ana Costa',
    titulo: 'Sistema de Automação Residencial',
    descricao: 'Plataforma IoT para controle automatizado de dispositivos residenciais via app mobile.',
    techs: ['React Native', 'Node.js', 'MQTT', 'PostgreSQL'],
    turma: 'ADS 2024.1',
  ),
  _TalentProject(
    id: 2, alunoId: 2, alunoNome: 'Bruno Silva',
    titulo: 'App de Gestão Acadêmica',
    descricao: 'Aplicativo para gerenciamento de notas, frequências e comunicação entre alunos e professores.',
    techs: ['Flutter', 'Firebase', 'Dart'],
    turma: 'ADS 2024.1',
  ),
  _TalentProject(
    id: 3, alunoId: 3, alunoNome: 'Carol Mendes',
    titulo: 'Plataforma E-commerce Sustentável',
    descricao: 'Marketplace focado em produtos sustentáveis com rastreabilidade de cadeia de produção.',
    techs: ['Vue.js', 'Laravel', 'MySQL'],
    turma: 'ADS 2023.2',
  ),
  _TalentProject(
    id: 4, alunoId: 4, alunoNome: 'Diego Lima',
    titulo: 'Sistema de Monitoramento Ambiental',
    descricao: 'Coleta e visualização de dados ambientais em tempo real com alertas e dashboards.',
    techs: ['Python', 'Django', 'PostgreSQL', 'React'],
    turma: 'GTI 2024.1',
  ),
  _TalentProject(
    id: 5, alunoId: 5, alunoNome: 'Eva Rodrigues',
    titulo: 'Fintech de Micropagamentos',
    descricao: 'Plataforma de pagamentos digitais com foco em micropagamentos para o setor educacional.',
    techs: ['Node.js', 'React', 'MongoDB', 'Stripe'],
    turma: 'DS 2024.1',
  ),
];

// ─── TAB: TALENTOS & PROJETOS ─────────────────────────────────────────────────
class _TalentosTab extends StatefulWidget {
  const _TalentosTab();

  @override
  State<_TalentosTab> createState() => _TalentosTabState();
}

class _TalentosTabState extends State<_TalentosTab> {
  int get _empresaId => AppSession.userId > 0 ? AppSession.userId : 101;

  void _toggleInteresse(_TalentProject p) {
    if (!InterestService.hasInteresse(_empresaId, p.id)) {
      InterestService.registerInterest(
        empresaId: _empresaId,
        empresaNome: AppSession.name.isNotEmpty ? AppSession.name : 'Empresa',
        projetoId: p.id,
        projetoTitulo: p.titulo,
        alunoId: p.alunoId,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final hPad = mobile ? 16.0 : 40.0;
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.secondary, AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.people_outline, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vitrine de Talentos',
                            style: TextStyle(
                              fontSize: mobile ? 18 : 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text(
                            'Descubra projetos dos alunos e demonstre interesse',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Project cards
                ..._kMockProjects.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TalentCard(
                    project: p,
                    interested: InterestService.hasInteresse(_empresaId, p.id),
                    onToggle: () => _toggleInteresse(p),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── TALENT CARD ──────────────────────────────────────────────────────────────
class _TalentCard extends StatelessWidget {
  final _TalentProject project;
  final bool interested;
  final VoidCallback onToggle;
  const _TalentCard({
    required this.project,
    required this.interested,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: interested
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  p.alunoNome[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.titulo,
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${p.alunoNome} · ${p.turma}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              if (interested)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.statusApprovedBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline, size: 13, color: AppColors.statusApprovedFg),
                      SizedBox(width: 4),
                      Text('Interesse Registrado',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.statusApprovedFg)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            p.descricao,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: p.techs.take(4).map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.primary)),
                  )).toList(),
                ),
              ),
              const SizedBox(width: 10),
              if (!interested)
                ElevatedButton.icon(
                  onPressed: onToggle,
                  icon: const Icon(Icons.favorite_border, size: 15),
                  label: const Text('Demonstrar Interesse',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.favorite, size: 15),
                  label: const Text('Interesse Enviado',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

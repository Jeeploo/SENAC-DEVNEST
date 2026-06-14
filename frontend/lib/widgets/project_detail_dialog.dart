import 'package:flutter/material.dart';
import '../models/project.dart';
import '../theme/app_colors.dart';
import '../utils/app_session.dart';
import '../services/app_services.dart';
import '../services/ai_analysis_service.dart';
import 'shared_widgets.dart';

enum _DialogState { view, approving, rejecting, analyzing, evaluating }

class ProjectDetailDialog extends StatefulWidget {
  final Project project;
  final Future<void> Function(Project) onApprove;
  final Future<void> Function(Project, String feedback) onReject;

  const ProjectDetailDialog({
    super.key,
    required this.project,
    required this.onApprove,
    required this.onReject,
  });

  static Future<void> show(
    BuildContext context, {
    required Project project,
    required Future<void> Function(Project) onApprove,
    required Future<void> Function(Project, String) onReject,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => ProjectDetailDialog(
        project: project,
        onApprove: onApprove,
        onReject: onReject,
      ),
    );
  }

  @override
  State<ProjectDetailDialog> createState() => _ProjectDetailDialogState();
}

class _ProjectDetailDialogState extends State<ProjectDetailDialog> {
  _DialogState _state = _DialogState.view;
  final _feedbackController = TextEditingController();
  bool _loading = false;
  ProjectAnalysis? _aiResult;
  bool _aiLoading = false;

  // Rubrica de avaliação
  final Map<String, double> _rubricas = {
    'Documentação Técnica': 7.0,
    'Funcionamento do Sistema': 7.0,
    'Inovação e Criatividade': 7.0,
    'Apresentação e Interface': 7.0,
    'Trabalho em Equipe': 7.0,
  };
  final _avalFeedbackCtrl = TextEditingController();
  bool _avalSalva = false;

  double get _notaFinal {
    final soma = _rubricas.values.fold(0.0, (a, b) => a + b);
    return soma / _rubricas.length;
  }

  Project get p => widget.project;

  @override
  void dispose() {
    _feedbackController.dispose();
    _avalFeedbackCtrl.dispose();
    super.dispose();
  }

  Future<void> _analyzeWithAi() async {
    setState(() { _state = _DialogState.analyzing; _aiLoading = true; _aiResult = null; });
    final techs = _techChips;
    final result = await AppServices.ai.analyzeProject(
      title: p.title,
      description: p.description,
      technologies: techs,
      classGroup: p.classGroupName ?? '',
    );
    if (mounted) setState(() { _aiResult = result; _aiLoading = false; });
  }

  Future<void> _confirmApprove() async {
    setState(() => _loading = true);
    await widget.onApprove(p);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _confirmReject() async {
    if (_feedbackController.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await widget.onReject(p, _feedbackController.text.trim());
    if (mounted) Navigator.pop(context);
  }

  // Formata data: "21 de abril de 2024"
  String _formatDate(DateTime dt) {
    const months = [
      '', 'janeiro', 'fevereiro', 'marco', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
    ];
    return '${dt.day} de ${months[dt.month]} de ${dt.year}';
  }

  // Divide o campo tecnologias por vírgula em chips
  List<String> get _techChips {
    if (p.technologies == null || p.technologies!.isEmpty) return [];
    return p.technologies!.split(',').map((t) => t.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final dialogW = screenW < 600 ? screenW * 0.95 : 660.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenW < 600 ? 10 : 40,
        vertical: 32,
      ),
      child: SizedBox(
        width: dialogW,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Conteúdo scrollável
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 24),
                    _buildDescription(),
                    const SizedBox(height: 20),
                    _buildCoordinator(),
                    const SizedBox(height: 20),
                    _buildTechnologies(),
                    const SizedBox(height: 16),
                    _buildRepository(),
                    const SizedBox(height: 20),
                    _buildDate(),
                    const SizedBox(height: 24),
                    if (_state == _DialogState.approving) _buildApproveConfirm(),
                    if (_state == _DialogState.rejecting) _buildRejectForm(),
                    if (_state == _DialogState.analyzing) _buildAiAnalysis(),
                    if (_state == _DialogState.evaluating) _buildRubrica(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // Rodapé fixo com botões
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(p.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(p.studentName ?? '-',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
            const Text('·',
                style: TextStyle(color: AppColors.textMuted)),
            Text(p.classGroupName ?? '-',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
            const Text('·',
                style: TextStyle(color: AppColors.textMuted)),
            StatusBadge(p.status),
          ],
        ),
      ],
    );
  }

  // ─── DESCRIÇÃO ─────────────────────────────────────────────────────────────
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Descricao do Projeto',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(p.description,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.6)),
        ),
      ],
    );
  }

  // ─── COORDENADOR ───────────────────────────────────────────────────────────
  Widget _buildCoordinator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Coorientador',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        SizedBox(height: 6),
        Text('Prof. Heuryk Wylk',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }

  // ─── TECNOLOGIAS ───────────────────────────────────────────────────────────
  Widget _buildTechnologies() {
    if (_techChips.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tecnologias Utilizadas',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _techChips
              .map((tech) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD4C8FF)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.diamond_outlined,
                            size: 12, color: Color(0xFF7C3AED)),
                        const SizedBox(width: 4),
                        Text(tech,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7C3AED))),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ─── REPOSITÓRIO ───────────────────────────────────────────────────────────
  Widget _buildRepository() {
    if (p.githubLink == null || p.githubLink!.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.code, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Repositorio',
                style: TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
          const Icon(Icons.open_in_new,
              size: 14, color: AppColors.textMuted),
        ],
      ),
    );
  }

  // ─── DATA ──────────────────────────────────────────────────────────────────
  Widget _buildDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Data de Submissao',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        Text(_formatDate(p.createdAt),
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }

  // ─── CONFIRMAÇÃO DE APROVAÇÃO ──────────────────────────────────────────────
  Widget _buildApproveConfirm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.statusApprovedBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA7D7A8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppColors.statusApprovedFg, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confirmar Aprovacao',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.statusApprovedFg)),
                SizedBox(height: 4),
                Text(
                    'Este projeto sera publicado na vitrine do Observatorio PI e ficara visivel para todos.',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.statusApprovedFg,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── FORMULÁRIO DE REPROVAÇÃO ──────────────────────────────────────────────
  Widget _buildRejectForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.statusRejectedBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF4B8B8)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_outlined,
                  color: AppColors.statusRejectedFg, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Justificativa da Reprovacao',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.statusRejectedFg)),
                    SizedBox(height: 4),
                    Text(
                        'Esta justificativa sera enviada ao aluno para que ele possa revisar e resubmeter o projeto.',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.statusRejectedFg,
                            height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText:
                'Descreva os motivos da reprovacao e as melhorias necessarias...',
            hintStyle: const TextStyle(
                fontSize: 13, color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }


  // ─── ANÁLISE COM IA ────────────────────────────────────────────────────────
  Widget _buildAiAnalysis() {
    if (_aiLoading) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFBBCCFF)),
        ),
        child: const Column(children: [
          CircularProgressIndicator(color: Color(0xFF1A237E)),
          SizedBox(height: 16),
          Text('A IA está analisando o projeto...', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          SizedBox(height: 4),
          Text('Avaliando tecnologias, descrição e complexidade',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted), textAlign: TextAlign.center),
        ]),
      );
    }
    if (_aiResult == null) return const SizedBox.shrink();
    final r = _aiResult!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Score card
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF00ACC1)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${r.score.toStringAsFixed(1)}/10',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
              child: Text(r.badge, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Complexidade: ${r.complexity}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
            const SizedBox(height: 4),
            Text('${_techChips.length} tecnologias', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ]),
        ]),
      ),
      const SizedBox(height: 14),
      // Resumo
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFBBCCFF))),
        child: Text(r.summary, style: const TextStyle(fontSize: 12, color: Color(0xFF1A237E), height: 1.6)),
      ),
      const SizedBox(height: 14),
      // Pontos fortes
      const Text('Pontos Fortes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      ...r.strengths.map((s) => Padding(padding: const EdgeInsets.only(bottom: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 15),
          const SizedBox(width: 8),
          Expanded(child: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5))),
        ]))),
      const SizedBox(height: 10),
      // Sugestões
      const Text('Sugestões de Melhoria', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      ...r.improvements.map((s) => Padding(padding: const EdgeInsets.only(bottom: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.arrow_forward_ios, color: Color(0xFFF57F17), size: 11),
          const SizedBox(width: 8),
          Expanded(child: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5))),
        ]))),
      const SizedBox(height: 10),
      Container(width: double.infinity, padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
        child: const Text('Análise gerada por IA — use como suporte à avaliação, não como nota definitiva.',
            style: TextStyle(fontSize: 10, color: AppColors.textMuted), textAlign: TextAlign.center)),
    ]);
  }


  // ─── RUBRICA DE AVALIAÇÃO ─────────────────────────────────────────────────
  Widget _buildRubrica() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          const Icon(Icons.rate_review_outlined, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Avaliação por Rubrica',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            Text('Prof. ${AppSession.name.isEmpty ? "Professor" : AppSession.name.split("@").first}',
                style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ])),
          // Nota final em destaque
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: [
              Text(_notaFinal.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
              const Text('/ 10', style: TextStyle(fontSize: 10, color: Colors.white70)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 16),

      // Critérios com sliders
      ..._rubricas.entries.map((entry) {
        final cor = entry.value >= 8.0
            ? AppColors.statusApprovedFg
            : entry.value >= 6.0
                ? const Color(0xFFF57F17)
                : AppColors.statusRejectedFg;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(entry.key,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cor.withValues(alpha: 0.3)),
                ),
                child: Text(entry.value.toStringAsFixed(1),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cor)),
              ),
            ]),
            const SizedBox(height: 6),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: cor,
                inactiveTrackColor: cor.withValues(alpha: 0.15),
                thumbColor: cor,
                overlayColor: cor.withValues(alpha: 0.12),
                trackHeight: 5,
              ),
              child: Slider(
                value: entry.value,
                min: 0, max: 10, divisions: 20,
                onChanged: _avalSalva ? null : (v) => setState(() => _rubricas[entry.key] = v),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Insuficiente (0)', style: TextStyle(fontSize: 9, color: Colors.grey[400])),
              Text('Excelente (10)',   style: TextStyle(fontSize: 9, color: Colors.grey[400])),
            ]),
          ]),
        );
      }),

      const SizedBox(height: 4),
      // Feedback textual
      const Text('Feedback para o Aluno',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      const SizedBox(height: 6),
      TextField(
        controller: _avalFeedbackCtrl,
        maxLines: 3,
        enabled: !_avalSalva,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Descreva os pontos fortes e o que pode ser melhorado...',
          hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.statusApprovedFg)),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),

      if (_avalSalva) ...[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.statusApprovedBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFA7D7A8)),
          ),
          child: const Row(children: [
            Icon(Icons.check_circle_outline, color: AppColors.statusApprovedFg, size: 18),
            SizedBox(width: 8),
            Expanded(child: Text('Avaliação registrada com sucesso!',
                style: TextStyle(fontSize: 12, color: AppColors.statusApprovedFg, fontWeight: FontWeight.w600))),
          ]),
        ),
      ],

      const SizedBox(height: 16),
      if (!_avalSalva)
        SizedBox(width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _avalSalva = true),
            icon: const Icon(Icons.save_outlined, size: 16),
            label: const Text('Salvar Avaliação', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white, elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          )),
    ]);
  }

  // ─── RODAPÉ (botões) ────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Botão IA — sempre visível no estado view
          if (_state == _DialogState.view) ...[
            SizedBox(width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _analyzeWithAi,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Analisar com IA',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white, elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )),
            const SizedBox(height: 10),
          ],

          // Botão voltar quando analisando ou avaliando
          if (_state == _DialogState.analyzing || _state == _DialogState.evaluating) ...[
            SizedBox(width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => setState(() {
                  _state = _DialogState.view;
                  _avalSalva = false;
                }),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Voltar', style: TextStyle(fontSize: 14)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )),
            const SizedBox(height: 10),
          ],

          // Botões de ação por estado
          if (_state == _DialogState.view && p.status == ProjectStatus.submitted)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecione uma acao para este projeto:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _state = _DialogState.approving),
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                        label: const Text('Aprovar',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.statusApprovedFg,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _state = _DialogState.rejecting),
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        label: const Text('Reprovar',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.statusRejectedFg,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          if (_state == _DialogState.approving) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _confirmApprove,
                    icon: _loading
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Confirmar Aprovacao',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusApprovedFg,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => setState(() => _state = _DialogState.view),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Cancelar',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textSecondary)),
                ),
              ],
            ),
          ],

          if (_state == _DialogState.rejecting) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _confirmReject,
                    icon: _loading
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Confirmar Reprovacao',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusRejectedFg,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => setState(() => _state = _DialogState.view),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Cancelar',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textSecondary)),
                ),
              ],
            ),
          ],

          // Botão Fechar sempre visível
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Fechar',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}
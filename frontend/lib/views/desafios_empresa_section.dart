import 'package:flutter/material.dart';
import '../services/challenge_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_session.dart';
import '../utils/responsive.dart';

// ─── SEÇÃO DESAFIOS (painel empresa) ──────────────────────────────────────────
class DesafiosEmpresaSection extends StatefulWidget {
  const DesafiosEmpresaSection({super.key});
  @override
  State<DesafiosEmpresaSection> createState() => _DesafiosEmpresaSectionState();
}

class _DesafiosEmpresaSectionState extends State<DesafiosEmpresaSection> {
  int get _empresaId => AppSession.userId > 0 ? AppSession.userId : 101;

  List<Desafio> get _desafios =>
      ChallengeService.all.where((d) => d.empresaId == _empresaId).toList();

  void _openForm([Desafio? edit]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _DesafioFormDialog(empresaId: _empresaId, editing: edit),
    );
    if (result == true) setState(() {});
  }

  void _showPropostas(Desafio d) {
    showDialog(
      context: context,
      builder: (_) => _PropostasDialog(desafio: d),
    );
  }

  void _confirmDelete(Desafio d) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Excluir Desafio',
            style:
                TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        content:
            Text('Deseja excluir o desafio "${d.titulo}"? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusRejectedFg,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              ChallengeService.delete(d.id);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final hPad = mobile ? 16.0 : 40.0;
    final desafios = _desafios;
    final totalPropostas = desafios.fold(
        0, (s, d) => s + ChallengeService.proposalCountFor(d.id));
    final semResposta =
        desafios.where((d) => ChallengeService.proposalCountFor(d.id) == 0).length;

    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.lightbulb_outline,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Meus Desafios Tecnológicos',
                                style: TextStyle(
                                  fontSize: mobile ? 18 : 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Publique desafios e receba propostas dos alunos',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _openForm(),
                          icon: const Icon(Icons.add, size: 16),
                          label: Text(mobile ? 'Novo' : 'Novo Desafio'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Stats
                    _DesafioStats(
                      total: desafios.length,
                      totalPropostas: totalPropostas,
                      semResposta: semResposta,
                      mobile: mobile,
                    ),
                    const SizedBox(height: 20),

                    // Lista
                    if (desafios.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 56),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 48,
                              color: const Color(0xFF7C3AED)
                                  .withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Nenhum desafio publicado ainda.',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () => _openForm(),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Criar primeiro desafio'),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: desafios
                            .map((d) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _DesafioCard(
                                    desafio: d,
                                    onEdit: () => _openForm(d),
                                    onDelete: () => _confirmDelete(d),
                                    onVerPropostas: () => _showPropostas(d),
                                  ),
                                ))
                            .toList(),
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

// ─── STATS ────────────────────────────────────────────────────────────────────
class _DesafioStats extends StatelessWidget {
  final int total, totalPropostas, semResposta;
  final bool mobile;
  const _DesafioStats({
    required this.total,
    required this.totalPropostas,
    required this.semResposta,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SCard(
        icon: Icons.lightbulb_outline,
        bg: const Color(0xFFF3F0FF),
        color: const Color(0xFF7C3AED),
        value: '$total',
        label: 'Desafios Publicados',
      ),
      _SCard(
        icon: Icons.description_outlined,
        bg: const Color(0xFFE3F2FD),
        color: const Color(0xFF1565C0),
        value: '$totalPropostas',
        label: 'Propostas Recebidas',
      ),
      _SCard(
        icon: Icons.hourglass_empty_outlined,
        bg: const Color(0xFFFFF8E1),
        color: AppColors.statusPendingFg,
        value: '$semResposta',
        label: 'Sem Proposta',
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
                  padding: EdgeInsets.only(right: e.key < 2 ? 16 : 0),
                  child: e.value,
                ),
              ))
          .toList(),
    );
  }
}

class _SCard extends StatelessWidget {
  final IconData icon;
  final Color bg, color;
  final String value, label;
  const _SCard({
    required this.icon,
    required this.bg,
    required this.color,
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
                  color: bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 19),
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
                          color: AppColors.textPrimary)),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      );
}

// ─── DESAFIO CARD ─────────────────────────────────────────────────────────────
class _DesafioCard extends StatelessWidget {
  final Desafio desafio;
  final VoidCallback onEdit, onDelete, onVerPropostas;
  const _DesafioCard({
    required this.desafio,
    required this.onEdit,
    required this.onDelete,
    required this.onVerPropostas,
  });

  Color get _diffColor => switch (desafio.dificuldade) {
        'Iniciante' => AppColors.statusApprovedFg,
        'Avançado' => AppColors.statusRejectedFg,
        _ => AppColors.statusPendingFg,
      };

  Color get _diffBg => switch (desafio.dificuldade) {
        'Iniciante' => AppColors.statusApprovedBg,
        'Avançado' => AppColors.statusRejectedBg,
        _ => AppColors.statusPendingBg,
      };

  @override
  Widget build(BuildContext context) {
    final propostas = ChallengeService.proposalCountFor(desafio.id);
    final prazo = desafio.prazo;
    final prazoStr =
        '${prazo.day.toString().padLeft(2, '0')}/${prazo.month.toString().padLeft(2, '0')}/${prazo.year}';
    final mobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(desafio.titulo,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(desafio.area,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: _diffBg,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(desafio.dificuldade,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _diffColor)),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            desafio.descricao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.calendar_today_outlined,
                size: 13, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text('Prazo: $prazoStr',
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(width: 16),
            const Icon(Icons.description_outlined,
                size: 13, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              '$propostas proposta${propostas != 1 ? 's' : ''}',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary),
            ),
          ]),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(children: [
            if (propostas > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onVerPropostas,
                  icon: const Icon(Icons.people_outline, size: 14),
                  label: Text(
                    mobile
                        ? 'Propostas ($propostas)'
                        : 'Ver Propostas ($propostas)',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              )
            else
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Aguardando propostas',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                ),
              ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 14),
              label:
                  const Text('Editar', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 14),
              label: const Text('Excluir',
                  style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.statusRejectedFg,
                side: const BorderSide(color: AppColors.statusRejectedDot),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// ─── FORM DIALOG ──────────────────────────────────────────────────────────────
class _DesafioFormDialog extends StatefulWidget {
  final int empresaId;
  final Desafio? editing;
  const _DesafioFormDialog({required this.empresaId, this.editing});

  @override
  State<_DesafioFormDialog> createState() => _DesafioFormDialogState();
}

class _DesafioFormDialogState extends State<_DesafioFormDialog> {
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  String _dificuldade = 'Intermediário';
  DateTime _prazo = DateTime.now().add(const Duration(days: 60));

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _tituloCtrl.text = e.titulo;
      _descCtrl.text = e.descricao;
      _areaCtrl.text = e.area;
      _dificuldade = e.dificuldade;
      _prazo = e.prazo;
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  bool get _valid =>
      _tituloCtrl.text.trim().isNotEmpty &&
      _descCtrl.text.trim().isNotEmpty &&
      _areaCtrl.text.trim().isNotEmpty;

  void _save() {
    if (!_valid) return;
    final e = widget.editing;
    if (e != null) {
      e.titulo = _tituloCtrl.text.trim();
      e.descricao = _descCtrl.text.trim();
      e.area = _areaCtrl.text.trim();
      e.dificuldade = _dificuldade;
      e.prazo = _prazo;
      ChallengeService.update(e);
    } else {
      ChallengeService.create(
        empresaId: widget.empresaId,
        titulo: _tituloCtrl.text.trim(),
        descricao: _descCtrl.text.trim(),
        area: _areaCtrl.text.trim(),
        prazo: _prazo,
        dificuldade: _dificuldade,
      );
    }
    Navigator.pop(context, true);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _prazo,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _prazo = picked);
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(fontSize: 13, color: AppColors.textMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFF7C3AED), width: 2),
        ),
      );

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary));

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isEdit = widget.editing != null;
    final prazoStr =
        '${_prazo.day.toString().padLeft(2, '0')}/${_prazo.month.toString().padLeft(2, '0')}/${_prazo.year}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(
          horizontal: w < 600 ? 16 : 60, vertical: 32),
      child: SizedBox(
        width: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          isEdit
                              ? 'Editar Desafio'
                              : 'Novo Desafio Tecnológico',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close,
                            size: 20, color: AppColors.textMuted),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    _label('Título do Desafio *'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _tituloCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: _dec(
                          'Ex: Sistema de Monitoramento Inteligente'),
                    ),
                    const SizedBox(height: 16),

                    _label('Área / Categoria *'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _areaCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration:
                          _dec('Ex: Mobile / IA, Web / E-commerce'),
                    ),
                    const SizedBox(height: 16),

                    _label('Descrição *'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _descCtrl,
                      onChanged: (_) => setState(() {}),
                      maxLines: 4,
                      decoration: _dec(
                          'Descreva o desafio, objetivos, tecnologias esperadas...'),
                    ),
                    const SizedBox(height: 16),

                    Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Dificuldade'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _dificuldade,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.border),
                                ),
                              ),
                              items: [
                                'Iniciante',
                                'Intermediário',
                                'Avançado'
                              ]
                                  .map((d) => DropdownMenuItem(
                                      value: d, child: Text(d)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _dificuldade = v!),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Prazo'),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.border),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(children: [
                                  const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16,
                                      color: AppColors.textMuted),
                                  const SizedBox(width: 8),
                                  Text(prazoStr,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textPrimary)),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
              child: Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _valid ? _save : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isEdit
                          ? 'Salvar Alterações'
                          : 'Publicar Desafio',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PROPOSTAS DIALOG ─────────────────────────────────────────────────────────
class _PropostasDialog extends StatelessWidget {
  final Desafio desafio;
  const _PropostasDialog({required this.desafio});

  @override
  Widget build(BuildContext context) {
    final propostas = ChallengeService.proposalsFor(desafio.id);
    final w = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(
          horizontal: w < 600 ? 16 : 60, vertical: 32),
      child: SizedBox(
        width: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(desafio.titulo,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(
                                '${propostas.length} proposta${propostas.length != 1 ? 's' : ''} recebida${propostas.length != 1 ? 's' : ''}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted),
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
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 16),
                    ...propostas.map((p) => _PropostaItem(proposta: p)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Fechar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropostaItem extends StatelessWidget {
  final Proposta proposta;
  const _PropostaItem({required this.proposta});

  @override
  Widget build(BuildContext context) {
    final data = proposta.dataEnvio;
    final dataStr =
        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                proposta.nomeAluno.substring(0, 1),
                style: const TextStyle(
                    fontSize: 13,
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
                  Text(dataStr,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            proposta.descricaoSolucao,
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}

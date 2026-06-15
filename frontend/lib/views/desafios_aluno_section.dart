import 'package:flutter/material.dart';
import '../services/challenge_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_session.dart';
import '../utils/responsive.dart';

// ─── SEÇÃO DESAFIOS (painel aluno) ────────────────────────────────────────────
class DesafiosAlunoSection extends StatefulWidget {
  const DesafiosAlunoSection({super.key});
  @override
  State<DesafiosAlunoSection> createState() => _DesafiosAlunoSectionState();
}

class _DesafiosAlunoSectionState extends State<DesafiosAlunoSection> {
  String? _filterArea;
  String? _filterDiff;

  int get _alunoId => AppSession.userId > 0 ? AppSession.userId : 1;

  List<Desafio> get _desafios {
    var list = ChallengeService.publicados;
    if (_filterArea != null) {
      list = list.where((d) => d.area == _filterArea).toList();
    }
    if (_filterDiff != null) {
      list = list.where((d) => d.dificuldade == _filterDiff).toList();
    }
    return list;
  }

  List<String> get _areas => ChallengeService.publicados
      .map((d) => d.area)
      .toSet()
      .toList()
    ..sort();

  void _sendProposal(Desafio d) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _PropostaFormDialog(
        desafio: d,
        alunoId: _alunoId,
        nomeAluno:
            AppSession.name.isNotEmpty ? AppSession.name : 'Aluno',
      ),
    );
    if (result == true) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final hPad = mobile ? 16.0 : 40.0;
    final desafios = _desafios;
    final minhasPropostas = ChallengeService.byAluno(_alunoId);

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
                    Row(children: [
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
                        child: const Icon(Icons.emoji_objects_outlined,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Desafios das Empresas',
                              style: TextStyle(
                                fontSize: mobile ? 18 : 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Resolva desafios reais e se destaque para o mercado',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Filtros
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        _FChip(
                          label: 'Todos',
                          active:
                              _filterArea == null && _filterDiff == null,
                          onTap: () => setState(() {
                            _filterArea = null;
                            _filterDiff = null;
                          }),
                        ),
                        ..._areas.map((a) => Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: _FChip(
                                label: a,
                                active: _filterArea == a,
                                onTap: () => setState(() {
                                  _filterArea =
                                      _filterArea == a ? null : a;
                                  _filterDiff = null;
                                }),
                              ),
                            )),
                        ...['Iniciante', 'Intermediário', 'Avançado']
                            .map((d) => Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: _FChip(
                                    label: d,
                                    active: _filterDiff == d,
                                    activeColor: d == 'Iniciante'
                                        ? AppColors.statusApprovedFg
                                        : d == 'Avançado'
                                            ? AppColors.statusRejectedFg
                                            : AppColors.statusPendingFg,
                                    onTap: () => setState(() {
                                      _filterDiff =
                                          _filterDiff == d ? null : d;
                                      _filterArea = null;
                                    }),
                                  ),
                                )),
                      ]),
                    ),
                    const SizedBox(height: 20),

                    // Lista de desafios
                    if (desafios.isEmpty)
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 48),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Column(children: [
                          Icon(Icons.search_off,
                              size: 48, color: AppColors.textMuted),
                          SizedBox(height: 12),
                          Text('Nenhum desafio encontrado.',
                              style:
                                  TextStyle(color: AppColors.textMuted)),
                        ]),
                      )
                    else
                      Column(
                        children: desafios
                            .map((d) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: _DesafioCard(
                                    desafio: d,
                                    jaEnviou:
                                        ChallengeService.alunoJaEnviou(
                                            d.id, _alunoId),
                                    onEnviar: () => _sendProposal(d),
                                  ),
                                ))
                            .toList(),
                      ),

                    // Minhas Propostas
                    if (minhasPropostas.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      const Text(
                        'Minhas Propostas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...minhasPropostas.map((p) {
                        final titulo = ChallengeService.all
                            .where((x) => x.id == p.desafioId)
                            .firstOrNull
                            ?.titulo ?? '-';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _MinhaPropostaCard(
                              proposta: p, desafioTitulo: titulo),
                        );
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
}

// ─── FILTER CHIP ──────────────────────────────────────────────────────────────
class _FChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color? activeColor;
  final VoidCallback onTap;
  const _FChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? color : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── DESAFIO CARD (aluno) ─────────────────────────────────────────────────────
class _DesafioCard extends StatelessWidget {
  final Desafio desafio;
  final bool jaEnviou;
  final VoidCallback onEnviar;
  const _DesafioCard({
    required this.desafio,
    required this.jaEnviou,
    required this.onEnviar,
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
    final prazo = desafio.prazo;
    final prazoStr =
        '${prazo.day.toString().padLeft(2, '0')}/${prazo.month.toString().padLeft(2, '0')}/${prazo.year}';
    final propostas = ChallengeService.proposalCountFor(desafio.id);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: jaEnviou
              ? AppColors.statusApprovedDot.withValues(alpha: 0.4)
              : AppColors.border,
        ),
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
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.calendar_today_outlined,
                size: 13, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text('Prazo: $prazoStr',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(width: 16),
            const Icon(Icons.people_outline,
                size: 13, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text('$propostas participante${propostas != 1 ? 's' : ''}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted)),
          ]),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          if (jaEnviou)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.statusApprovedBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.statusApprovedDot),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 15, color: AppColors.statusApprovedFg),
                  SizedBox(width: 6),
                  Text(
                    'Proposta enviada',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusApprovedFg),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onEnviar,
                icon: const Icon(Icons.send_outlined, size: 14),
                label: const Text('Enviar Proposta',
                    style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
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

// ─── PROPOSTA FORM DIALOG ─────────────────────────────────────────────────────
class _PropostaFormDialog extends StatefulWidget {
  final Desafio desafio;
  final int alunoId;
  final String nomeAluno;
  const _PropostaFormDialog({
    required this.desafio,
    required this.alunoId,
    required this.nomeAluno,
  });

  @override
  State<_PropostaFormDialog> createState() => _PropostaFormDialogState();
}

class _PropostaFormDialogState extends State<_PropostaFormDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _valid => _ctrl.text.trim().length >= 20;

  void _send() {
    ChallengeService.sendProposal(
      desafioId: widget.desafio.id,
      alunoId: widget.alunoId,
      nomeAluno: widget.nomeAluno,
      descricaoSolucao: _ctrl.text.trim(),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(
          horizontal: w < 600 ? 16 : 60, vertical: 32),
      child: SizedBox(
        width: 520,
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enviar Proposta',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.desafio.titulo,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted),
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
                    const SizedBox(height: 20),
                    const Text(
                      'Descreva sua solução proposta *',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _ctrl,
                      onChanged: (_) => setState(() {}),
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText:
                            'Descreva como você resolveria o desafio, tecnologias que usaria, abordagem, diferenciais...',
                        hintStyle: const TextStyle(
                            fontSize: 13, color: AppColors.textMuted),
                        contentPadding: const EdgeInsets.all(14),
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xFF7C3AED), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mínimo 20 caracteres (${_ctrl.text.length} digitados)',
                      style: TextStyle(
                          fontSize: 11,
                          color: _valid
                              ? AppColors.statusApprovedFg
                              : AppColors.textMuted),
                    ),
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
                  child: ElevatedButton.icon(
                    onPressed: _valid ? _send : null,
                    icon: const Icon(Icons.send_outlined, size: 16),
                    label: const Text('Enviar',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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

// ─── MINHA PROPOSTA CARD ──────────────────────────────────────────────────────
class _MinhaPropostaCard extends StatelessWidget {
  final Proposta proposta;
  final String desafioTitulo;
  const _MinhaPropostaCard({
    required this.proposta,
    required this.desafioTitulo,
  });

  @override
  Widget build(BuildContext context) {
    final data = proposta.dataEnvio;
    final dataStr =
        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(desafioTitulo,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.statusApprovedBg,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('Enviada',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.statusApprovedFg)),
            ),
          ]),
          const SizedBox(height: 6),
          Text(
            proposta.descricaoSolucao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4),
          ),
          const SizedBox(height: 6),
          Text('Enviado em $dataStr',
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

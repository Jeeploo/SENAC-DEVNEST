import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../utils/app_session.dart';
import '../widgets/shared_widgets.dart';

// ─── PERFIS CADASTRÁVEIS ──────────────────────────────────────────────────────
enum _PerfilCadastro { aluno, professor, empresa }

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  _PerfilCadastro _perfil = _PerfilCadastro.aluno;

  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _turmaCtrl = TextEditingController();
  final _cursoCtrl = TextEditingController();
  final _empresaCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  bool _sucesso = false;
  String? _erro;

  final _turmas = [
    'ADS 2024.1',
    'ADS 2024.2',
    'ADS 2023.1',
    'ADS 2023.2',
    'GTI 2024.1',
    'GTI 2024.2',
    'DS 2024.1',
    'DS 2023.2',
  ];
  String? _turmaSelecionada;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _turmaCtrl.dispose();
    _cursoCtrl.dispose();
    _empresaCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_nomeCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _senhaCtrl.text.isEmpty) {
      setState(() => _erro = 'Preencha todos os campos obrigatórios.');
      return;
    }
    if (_perfil == _PerfilCadastro.aluno && _turmaSelecionada == null) {
      setState(() => _erro = 'Selecione a turma do aluno.');
      return;
    }
    setState(() {
      _loading = true;
      _erro = null;
    });
    await Future.delayed(const Duration(milliseconds: 800)); // simula API
    setState(() {
      _loading = false;
      _sucesso = true;
    });
    _limpar();
  }

  void _limpar() {
    _nomeCtrl.clear();
    _emailCtrl.clear();
    _senhaCtrl.clear();
    _turmaCtrl.clear();
    _cursoCtrl.clear();
    _empresaCtrl.clear();
    setState(() {
      _turmaSelecionada = null;
      _erro = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Redirecionar se não for admin
    if (!AppSession.isAdmin) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 56,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 16),
              const Text(
                'Acesso restrito',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apenas coordenadores podem cadastrar usuários.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      );
    }

    final mobile = Responsive.isMobile(context);
    final hPad = mobile ? 16.0 : 40.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: mobile ? const AppDrawer() : null,
      body: Column(
        children: [
          const AppNavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 60,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 32),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
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
                                      color: AppColors.accent.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.person_add_outlined,
                                      color: AppColors.accent,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cadastro de Usuários',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Somente coordenadores podem cadastrar novos usuários na plataforma.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),

                              // Seleção de perfil
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
                                    const Text(
                                      'Tipo de Usuário',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        _PerfilBtn(
                                          label: 'Aluno',
                                          icon: Icons.school_outlined,
                                          color: AppColors.primary,
                                          selected:
                                              _perfil == _PerfilCadastro.aluno,
                                          onTap: () => setState(() {
                                            _perfil = _PerfilCadastro.aluno;
                                            _limpar();
                                          }),
                                        ),
                                        const SizedBox(width: 10),
                                        _PerfilBtn(
                                          label: 'Professor',
                                          icon: Icons.menu_book_outlined,
                                          color: const Color(0xFF2E7D32),
                                          selected:
                                              _perfil ==
                                              _PerfilCadastro.professor,
                                          onTap: () => setState(() {
                                            _perfil = _PerfilCadastro.professor;
                                            _limpar();
                                          }),
                                        ),
                                        const SizedBox(width: 10),
                                        _PerfilBtn(
                                          label: 'Empresa Parceira',
                                          icon: Icons.business_outlined,
                                          color: const Color(0xFF7B1FA2),
                                          selected:
                                              _perfil ==
                                              _PerfilCadastro.empresa,
                                          onTap: () => setState(() {
                                            _perfil = _PerfilCadastro.empresa;
                                            _limpar();
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Formulário
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _secTitle(_perfilLabel()),
                                    const SizedBox(height: 20),

                                    // Nome
                                    _lbl('Nome Completo *'),
                                    _txt(_nomeCtrl, 'Nome do usuário'),
                                    const SizedBox(height: 16),

                                    // Email
                                    _lbl('Email Institucional *'),
                                    _txt(
                                      _emailCtrl,
                                      _perfilEmailHint(),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 16),

                                    // Senha
                                    _lbl('Senha Provisória *'),
                                    _senha(),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'O usuário deverá trocar a senha no primeiro acesso.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Campos específicos por perfil
                                    if (_perfil == _PerfilCadastro.aluno) ...[
                                      _lbl('Turma *'),
                                      _dropTurma(),
                                      const SizedBox(height: 16),
                                      _lbl('Curso'),
                                      _txt(
                                        _cursoCtrl,
                                        'Ex: Análise e Desenvolvimento de Sistemas',
                                      ),
                                    ],
                                    if (_perfil ==
                                        _PerfilCadastro.professor) ...[
                                      _lbl('Disciplina / Área'),
                                      _txt(
                                        _cursoCtrl,
                                        'Ex: Banco de Dados, Programação Web',
                                      ),
                                    ],
                                    if (_perfil == _PerfilCadastro.empresa) ...[
                                      _lbl('Nome da Empresa *'),
                                      _txt(
                                        _empresaCtrl,
                                        'Razão social da empresa',
                                      ),
                                      const SizedBox(height: 16),
                                      _lbl('Área de Atuação'),
                                      _txt(
                                        _cursoCtrl,
                                        'Ex: Tecnologia da Informação, Desenvolvimento de Software',
                                      ),
                                    ],

                                    // Erro
                                    if (_erro != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.statusRejectedBg,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFF4B8B8),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: AppColors.statusRejectedFg,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _erro!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors
                                                      .statusRejectedFg,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    // Sucesso
                                    if (_sucesso) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.statusApprovedBg,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFA7D7A8),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle_outline,
                                              color: AppColors.statusApprovedFg,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            const Expanded(
                                              child: Text(
                                                'Usuário cadastrado com sucesso! O acesso já está disponível.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors
                                                      .statusApprovedFg,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 24),
                                    // Botões
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: _loading
                                                ? null
                                                : _salvar,
                                            icon: _loading
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : const Icon(
                                                    Icons.person_add,
                                                    size: 18,
                                                  ),
                                            label: Text(
                                              _loading
                                                  ? 'Cadastrando...'
                                                  : 'Cadastrar Usuário',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        OutlinedButton(
                                          onPressed: () {
                                            _limpar();
                                            setState(() => _sucesso = false);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                AppColors.textSecondary,
                                            side: const BorderSide(
                                              color: AppColors.border,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Limpar',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Aviso de segurança
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF8E1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFFFE082),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      Icons.info_outline,
                                      color: Color(0xFFF9A825),
                                      size: 18,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Somente o Administrador/Coordenador possui acesso a esta página. '
                                        'As credenciais cadastradas devem ser compartilhadas com o usuário de forma segura.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF795500),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

  String _perfilLabel() {
    switch (_perfil) {
      case _PerfilCadastro.aluno:
        return 'Dados do Aluno';
      case _PerfilCadastro.professor:
        return 'Dados do Professor';
      case _PerfilCadastro.empresa:
        return 'Dados da Empresa Parceira';
    }
  }

  String _perfilEmailHint() {
    switch (_perfil) {
      case _PerfilCadastro.aluno:
        return 'aluno@senac.br';
      case _PerfilCadastro.professor:
        return 'professor@senac.br';
      case _PerfilCadastro.empresa:
        return 'contato@empresa.com.br';
    }
  }

  Widget _secTitle(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
  );
  Widget _lbl(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
  );

  Widget _txt(
    TextEditingController c,
    String h, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: TextField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: h,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
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
  );

  Widget _senha() => TextField(
    controller: _senhaCtrl,
    obscureText: _obscure,
    style: const TextStyle(fontSize: 13),
    decoration: InputDecoration(
      hintText: 'Mínimo 8 caracteres',
      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
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
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 18,
          color: AppColors.textMuted,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    ),
  );

  Widget _dropTurma() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: _turmaSelecionada != null ? AppColors.primary : AppColors.border,
      ),
    ),
    child: DropdownButton<String>(
      value: _turmaSelecionada,
      isExpanded: true,
      underline: const SizedBox.shrink(),
      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      hint: const Text(
        'Selecione a turma',
        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
      ),
      onChanged: (v) => setState(() => _turmaSelecionada = v),
      items: _turmas
          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
          .toList(),
    ),
  );
}

// ─── BOTÃO DE PERFIL ──────────────────────────────────────────────────────────
class _PerfilBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _PerfilBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? color : AppColors.textMuted, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? color : AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

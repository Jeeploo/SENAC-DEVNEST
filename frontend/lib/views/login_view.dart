import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_widgets.dart';

// ─── ESTADOS DA TELA ─────────────────────────────────────────────────────────
enum _LoginState { selection, studentLogin, adminLogin }

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  _LoginState _state = _LoginState.selection;
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure    = true;
  bool _loading    = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _goTo(String route) => Navigator.pushReplacementNamed(context, route);

  Future<void> _submit(String route) async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) {
      setState(() => _error = 'Preencha email e senha.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 600)); // simula auth
    if (mounted) _goTo(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        _PublicNavBar(onLoginTap: () => setState(() => _state = _LoginState.selection)),
        Expanded(child: SingleChildScrollView(child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 60,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Center(child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim, child: child),
                  child: _state == _LoginState.selection
                      ? _SelectionCard(key: const ValueKey('sel'), onStudent: ()=>setState(()=>_state=_LoginState.studentLogin), onAdmin: ()=>setState(()=>_state=_LoginState.adminLogin), onVisitor: ()=>_goTo('/'))
                      : _LoginCard(
                          key: ValueKey(_state),
                          isAdmin: _state == _LoginState.adminLogin,
                          emailCtrl: _emailCtrl, passCtrl: _passCtrl,
                          obscure: _obscure, loading: _loading, error: _error,
                          onToggleObscure: () => setState(() => _obscure = !_obscure),
                          onBack: () { setState(() { _state = _LoginState.selection; _error = null; _emailCtrl.clear(); _passCtrl.clear(); }); },
                          onSubmit: () => _submit(_state == _LoginState.adminLogin ? '/admin' : '/student-panel'),
                        ),
                )),
              ),
              const AppFooter(),
            ],
          ),
        ))),
      ]),
    );
  }
}

// ─── NAVBAR PÚBLICA ───────────────────────────────────────────────────────────
class _PublicNavBar extends StatelessWidget {
  final VoidCallback onLoginTap;
  const _PublicNavBar({required this.onLoginTap});

  static const _links = ['Inicio', 'Dashboard Geral', 'Networking Publico', 'Feedbacks Gerais'];

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 600;
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 32),
      child: Row(children: [
        // Logo
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Row(children: [
            Container(width:36, height:36,
              decoration: BoxDecoration(gradient: const LinearGradient(colors:[AppColors.primary,AppColors.secondary], begin:Alignment.topLeft, end:Alignment.bottomRight), borderRadius:BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: const Text('PI', style: TextStyle(color:Colors.white, fontWeight:FontWeight.w800, fontSize:13))),
            const SizedBox(width:10),
            const Column(mainAxisAlignment:MainAxisAlignment.center, crossAxisAlignment:CrossAxisAlignment.start, children:[
              Text('SENAC DevNest', style:TextStyle(fontSize:14, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
              Text('Projetos Integradores', style:TextStyle(fontSize:10, color:AppColors.textMuted)),
            ]),
          ]),
        ),
        if (!mobile) ...[
          Expanded(child: Center(child: Row(mainAxisSize:MainAxisSize.min,
            children: _links.map((l) => Padding(padding:const EdgeInsets.only(right:24),
              child: Text(l, style:const TextStyle(fontSize:13, color:AppColors.textSecondary)))).toList()))),
          const Icon(Icons.search, color:AppColors.textSecondary, size:22),
          const SizedBox(width:16),
          ElevatedButton(
            onPressed: onLoginTap,
            style: ElevatedButton.styleFrom(backgroundColor:AppColors.accent, foregroundColor:Colors.white, elevation:0,
                padding:const EdgeInsets.symmetric(horizontal:18, vertical:10), shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(8))),
            child: const Text('Entrar / Cadastrar', style:TextStyle(fontSize:13, fontWeight:FontWeight.w600)),
          ),
        ] else ...[
          const Spacer(),
          ElevatedButton(
            onPressed: onLoginTap,
            style: ElevatedButton.styleFrom(backgroundColor:AppColors.accent, foregroundColor:Colors.white, elevation:0,
                padding:const EdgeInsets.symmetric(horizontal:14, vertical:8), shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(8))),
            child: const Text('Entrar', style:TextStyle(fontSize:12, fontWeight:FontWeight.w600)),
          ),
        ],
      ]),
    );
  }
}

// ─── SELECTION CARD ───────────────────────────────────────────────────────────
class _SelectionCard extends StatelessWidget {
  final VoidCallback onStudent, onAdmin, onVisitor;
  const _SelectionCard({super.key, required this.onStudent, required this.onAdmin, required this.onVisitor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(20), border:Border.all(color:AppColors.border),
        boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:0.06), blurRadius:24, offset:const Offset(0,8))]),
      child: Column(crossAxisAlignment:CrossAxisAlignment.center, children:[
        // Logo
        Container(width:56, height:56,
          decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppColors.primary,AppColors.secondary], begin:Alignment.topLeft, end:Alignment.bottomRight), borderRadius:BorderRadius.circular(14)),
          alignment:Alignment.center,
          child:const Text('SD', style:TextStyle(color:Colors.white, fontWeight:FontWeight.w800, fontSize:20))),
        const SizedBox(height:20),
        const Text('Bem-vindo ao SENAC DevNest',
            textAlign:TextAlign.center,
            style:TextStyle(fontSize:20, fontWeight:FontWeight.w800, color:AppColors.textPrimary)),
        const SizedBox(height:8),
        const Text('Selecione seu tipo de acesso para continuar',
            textAlign:TextAlign.center,
            style:TextStyle(fontSize:13, color:AppColors.textSecondary)),
        const SizedBox(height:28),

        // Opções
        _AccessOption(icon:Icons.school_outlined, iconBg:const Color(0xFFE0F7FA), iconColor:AppColors.primary,
            title:'Acesso de Aluno', subtitle:'Enviar projetos, acompanhar submissoes e receber feedbacks', onTap:onStudent),
        const SizedBox(height:12),
        _AccessOption(icon:Icons.shield_outlined, iconBg:const Color(0xFFFFF3E0), iconColor:AppColors.accent,
            title:'Acesso de Administrador', subtitle:'Revisar projetos, gerenciar submissoes e metricas globais', onTap:onAdmin),
        const SizedBox(height:12),
        _AccessOption(icon:Icons.person_outline, iconBg:const Color(0xFFF3F4F6), iconColor:AppColors.textSecondary,
            title:'Continuar como Visitante', subtitle:'Explorar projetos publicos sem fazer login', onTap:onVisitor),

        const SizedBox(height:24),
        Container(
          padding:const EdgeInsets.all(12),
          decoration:BoxDecoration(color:AppColors.background, borderRadius:BorderRadius.circular(10)),
          child:const Text(
              'Este e um prototipo de demonstracao. Em producao, seria necessario autenticacao real via credenciais institucionais.',
              textAlign:TextAlign.center,
              style:TextStyle(fontSize:11, color:AppColors.textMuted, height:1.5)),
        ),
      ]),
    );
  }
}

class _AccessOption extends StatefulWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final VoidCallback onTap;
  const _AccessOption({required this.icon, required this.iconBg, required this.iconColor, required this.title, required this.subtitle, required this.onTap});
  @override
  State<_AccessOption> createState() => _AccessOptionState();
}

class _AccessOptionState extends State<_AccessOption> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.primary.withValues(alpha: 0.04) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _hovered ? AppColors.primary : AppColors.border, width: _hovered ? 1.5 : 1),
          ),
          child: Row(children:[
            Container(width:44, height:44,
              decoration:BoxDecoration(color:widget.iconBg, borderRadius:BorderRadius.circular(10)),
              child:Icon(widget.icon, color:widget.iconColor, size:22)),
            const SizedBox(width:14),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
              Text(widget.title, style:const TextStyle(fontSize:14, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
              const SizedBox(height:2),
              Text(widget.subtitle, style:const TextStyle(fontSize:11, color:AppColors.textSecondary, height:1.4)),
            ])),
            Icon(Icons.chevron_right, color:_hovered ? AppColors.primary : AppColors.textMuted, size:20),
          ]),
        ),
      ),
    );
  }
}

// ─── LOGIN CARD ───────────────────────────────────────────────────────────────
class _LoginCard extends StatelessWidget {
  final bool isAdmin;
  final TextEditingController emailCtrl, passCtrl;
  final bool obscure, loading;
  final String? error;
  final VoidCallback onToggleObscure, onBack, onSubmit;

  const _LoginCard({
    super.key,
    required this.isAdmin,
    required this.emailCtrl,
    required this.passCtrl,
    required this.obscure,
    required this.loading,
    required this.error,
    required this.onToggleObscure,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final color  = isAdmin ? AppColors.accent : AppColors.primary;
    final icon   = isAdmin ? Icons.shield_outlined : Icons.school_outlined;
    final title  = isAdmin ? 'Acesso Administrativo' : 'Acesso do Aluno';
    final hint   = isAdmin ? 'coordenador@senac.br' : 'aluno@senac.br';

    return Container(
      width: 440,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(20), border:Border.all(color:AppColors.border),
        boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:0.06), blurRadius:24, offset:const Offset(0,8))]),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        // Back
        GestureDetector(
          onTap: onBack,
          child: Row(mainAxisSize:MainAxisSize.min, children:[
            const Icon(Icons.arrow_back, size:16, color:AppColors.textSecondary),
            const SizedBox(width:4),
            const Text('Voltar', style:TextStyle(fontSize:13, color:AppColors.textSecondary)),
          ]),
        ),
        const SizedBox(height:24),

        // Header
        Row(children:[
          Container(width:44, height:44,
            decoration:BoxDecoration(color:color.withValues(alpha:0.12), borderRadius:BorderRadius.circular(12)),
            child:Icon(icon, color:color, size:22)),
          const SizedBox(width:14),
          Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
            Text(title, style:const TextStyle(fontSize:18, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
            Text(isAdmin ? 'Coordenadores e professores' : 'Alunos matriculados',
                style:const TextStyle(fontSize:12, color:AppColors.textMuted)),
          ]),
        ]),
        const SizedBox(height:28),

        // Email
        _fieldLabel('Email institucional'),
        const SizedBox(height:6),
        TextField(
          controller: emailCtrl,
          style: const TextStyle(fontSize:13),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize:13, color:AppColors.textMuted),
            prefixIcon: const Icon(Icons.email_outlined, size:18, color:AppColors.textMuted),
            filled: true, fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius:BorderRadius.circular(10), borderSide:BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10), borderSide:const BorderSide(color:AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10), borderSide:BorderSide(color:color)),
            contentPadding: const EdgeInsets.symmetric(horizontal:14, vertical:14),
          ),
        ),
        const SizedBox(height:16),

        // Senha
        _fieldLabel('Senha'),
        const SizedBox(height:6),
        TextField(
          controller: passCtrl,
          obscureText: obscure,
          style: const TextStyle(fontSize:13),
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: const TextStyle(fontSize:13, color:AppColors.textMuted),
            prefixIcon: const Icon(Icons.lock_outline, size:18, color:AppColors.textMuted),
            suffixIcon: IconButton(icon:Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size:18, color:AppColors.textMuted), onPressed:onToggleObscure),
            filled: true, fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius:BorderRadius.circular(10), borderSide:BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10), borderSide:const BorderSide(color:AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10), borderSide:BorderSide(color:color)),
            contentPadding: const EdgeInsets.symmetric(horizontal:14, vertical:14),
          ),
        ),

        // Erro
        if (error != null) ...[
          const SizedBox(height:10),
          Text(error!, style:const TextStyle(fontSize:12, color:AppColors.statusRejectedFg)),
        ],
        const SizedBox(height:24),

        // Botão entrar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: loading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: color, foregroundColor: Colors.white, elevation:0,
              padding: const EdgeInsets.symmetric(vertical:14),
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
            ),
            child: loading
                ? const SizedBox(width:20, height:20, child:CircularProgressIndicator(strokeWidth:2, color:Colors.white))
                : const Text('Entrar', style:TextStyle(fontSize:14, fontWeight:FontWeight.w600)),
          ),
        ),
        const SizedBox(height:16),

        // Info registro
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color:AppColors.background, borderRadius:BorderRadius.circular(10)),
          child: Row(crossAxisAlignment:CrossAxisAlignment.start, children:[
            const Icon(Icons.info_outline, size:14, color:AppColors.textMuted),
            const SizedBox(width:8),
            Expanded(child: Text(
              isAdmin
                ? 'Apenas coordenadores podem criar contas de alunos. Entre em contato com o suporte para acesso.'
                : 'Seu cadastro e feito pelo coordenador da sua turma. Caso nao tenha acesso, solicite ao seu orientador.',
              style:const TextStyle(fontSize:11, color:AppColors.textMuted, height:1.5))),
          ]),
        ),
      ]),
    );
  }

  Widget _fieldLabel(String text) => Text(text, style:const TextStyle(fontSize:13, fontWeight:FontWeight.w600, color:AppColors.textPrimary));
}
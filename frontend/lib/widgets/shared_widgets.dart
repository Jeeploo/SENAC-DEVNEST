import 'package:flutter/material.dart';
import '../utils/app_session.dart';
import '../models/project.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

// ─── ROTAS ───────────────────────────────────────────────────────────────────
const _kAllRoutes = {
  'Início': '/',
  'Dashboard Geral': '/dashboard',
  'Networking': '/networking',
  'Feedbacks': '/feedbacks',
  'Meu Painel': '/student-panel',
  'Painel Admin': '/admin',
  'Cadastrar': '/cadastro',
};

// Links dinâmicos baseados no perfil logado
List<String> _navLinks() {
  final links = <String>['Início', 'Dashboard Geral', 'Networking'];
  // Empresa não recebe feedback — apenas aluno, professor e coordenador
  if (!AppSession.isEmpresa) {
    links.add('Feedbacks');
  }
  if (AppSession.isAluno) {
    links.add('Meu Painel');
  }
  if (AppSession.isAdmin || AppSession.isProfessor) {
    links.add('Painel Admin');
  }
  if (AppSession.isAdmin) {
    links.add('Cadastrar');
  }
  return links;
}

void _logout(BuildContext context) {
  AppSession.logout();
  Navigator.pushReplacementNamed(context, '/login');
}

// ─── NAVBAR ──────────────────────────────────────────────────────────────────
class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavBar({super.key});

  List<String> get _links => _navLinks();

  @override
  Size get preferredSize => const Size.fromHeight(60);

  void _navigate(BuildContext context, String label) {
    final route = _kAllRoutes[label];
    if (route == null) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 16 : 32,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: _buildLogo(),
          ),
          if (Responsive.isDesktop(context)) ...[
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _links.map((l) {
                    final route = _kAllRoutes[l];
                    final isActive = route != null && route == currentRoute;
                    return Padding(
                      padding: const EdgeInsets.only(right: 28),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _navigate(context, l),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: isActive
                                ? const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                  )
                                : null,
                            child: Text(
                              l,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? AppColors.secondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 16),
            _ctaButton(context),
          ] else if (Responsive.isTablet(context)) ...[
            const Spacer(),
            const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            _ctaButton(context),
            const SizedBox(width: 8),
            _menuButton(context),
          ] else ...[
            const Spacer(),
            _menuButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Text(
            'SD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SENAC DevNest',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Projetos Integradores',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ctaButton(BuildContext context) {
    if (AppSession.isLoggedIn) {
      return OutlinedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout, size: 16),
        label: const Text(
          'Sair',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.statusRejectedFg,
          side: const BorderSide(color: Color(0xFFF4B8B8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    return ElevatedButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Entrar / Cadastrar',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _menuButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: AppColors.textSecondary),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}

// ─── DRAWER (mobile/tablet) ───────────────────────────────────────────────────
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _baseLinks = [
    ('Início', Icons.home_outlined, '/'),
    ('Dashboard', Icons.dashboard_outlined, '/dashboard'),
    ('Networking', Icons.people_outline, '/networking'),
    ('Feedbacks', Icons.feedback_outlined, '/feedbacks'),
  ];

  List<(String, IconData, String)> get _drawerLinks {
    final base = <(String, IconData, String)>[
      ('Início', Icons.home_outlined, '/'),
      ('Dashboard', Icons.dashboard_outlined, '/dashboard'),
      ('Networking', Icons.people_outline, '/networking'),
    ];
    if (!AppSession.isEmpresa) {
      base.add(('Feedbacks', Icons.feedback_outlined, '/feedbacks'));
    }
    if (AppSession.isAluno) {
      base.add(('Meu Painel', Icons.school_outlined, '/student-panel'));
    }
    if (AppSession.isAdmin || AppSession.isProfessor) {
      base.add(('Painel Admin', Icons.shield_outlined, '/admin'));
    }
    if (AppSession.isAdmin) {
      base.add(('Cadastrar', Icons.person_add, '/cadastro'));
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'SD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SENAC DevNest',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 8),
            ..._drawerLinks.map((item) {
              final isActive = item.$3.isNotEmpty && item.$3 == currentRoute;
              return ListTile(
                leading: Icon(
                  item.$2,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  size: 20,
                ),
                title: Text(
                  item.$1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                tileColor: isActive
                    ? AppColors.primary.withValues(alpha: 0.06)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  if (item.$3.isNotEmpty) {
                    Navigator.pushReplacementNamed(context, item.$3);
                  }
                },
              );
            }),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: AppSession.isLoggedIn
                    ? OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _logout(context);
                        },
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text(
                          'Sair',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.statusRejectedFg,
                          side: const BorderSide(color: Color(0xFFF4B8B8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Entrar / Cadastrar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── STATUS BADGE ─────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final ProjectStatus status;
  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    late Color bg, fg, dot;
    late String label;

    switch (status) {
      case ProjectStatus.draft:
        bg = const Color(0xFFF3F4F6);
        fg = AppColors.textSecondary;
        dot = AppColors.textMuted;
        label = 'Rascunho';
      case ProjectStatus.submitted:
        bg = AppColors.statusPendingBg;
        fg = AppColors.statusPendingFg;
        dot = AppColors.statusPendingDot;
        label = 'Pendente';
      case ProjectStatus.evaluated:
        bg = AppColors.statusApprovedBg;
        fg = AppColors.statusApprovedFg;
        dot = AppColors.statusApprovedDot;
        label = 'Avaliado';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ACTION BUTTON ────────────────────────────────────────────────────────────
class ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ActionBtn({
    super.key,
    required this.label,
    required this.icon,
    required this.borderColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 12, color: textColor),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}

// ─── FOOTER ──────────────────────────────────────────────────────────────────
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);

    return Container(
      color: AppColors.navDark,
      padding: EdgeInsets.fromLTRB(mobile ? 20 : 32, 40, mobile ? 20 : 32, 20),
      child: Column(
        children: [
          mobile ? _mobileFooter() : _desktopFooter(context),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF2A3350)),
          const SizedBox(height: 12),
          const Text(
            '© 2024 SENAC DevNest — Todos os direitos reservados.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF666666), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _desktopFooter(BuildContext context) {
    final tablet = Responsive.isTablet(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _brand()),
        if (!tablet) ...[
          Expanded(
            child: _col('Navegacao', [
              'Projetos',
              'Sobre',
              'Turmas',
              'Contato',
            ]),
          ),
          Expanded(
            child: _col('Categorias', [
              'IoT e Automacao',
              'Dev Mobile',
              'Inteligencia Artificial',
              'Engenharia',
            ]),
          ),
        ],
        Expanded(child: _social()),
      ],
    );
  }

  Widget _mobileFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _brand(),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _col('Navegacao', [
                'Projetos',
                'Sobre',
                'Turmas',
                'Contato',
              ]),
            ),
            Expanded(
              child: _col('Categorias', [
                'IoT e Automacao',
                'Dev Mobile',
                'IA',
                'Engenharia',
              ]),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _social(),
      ],
    );
  }

  Widget _brand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Text(
            'SD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'SENAC DevNest',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const Text(
          'Projetos Integradores',
          style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 11),
        ),
        const SizedBox(height: 10),
        const Text(
          'Repositório oficial dos Projetos\nIntegradores da nossa faculdade.',
          style: TextStyle(color: Color(0xFF999999), fontSize: 12, height: 1.6),
        ),
      ],
    );
  }

  Widget _col(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              i,
              style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _social() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conecte-se',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children:
              [
                    Icons.code,
                    Icons.link,
                    Icons.camera_alt_outlined,
                    Icons.mail_outline,
                  ]
                  .map(
                    (icon) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3350),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF374060)),
                        ),
                        child: Icon(
                          icon,
                          color: const Color(0xFFCCCCCC),
                          size: 17,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

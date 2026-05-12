import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'views/home_view.dart';
import 'views/cadastro_view.dart';
import 'views/admin_panel_view.dart';
import 'views/networking_view.dart';
import 'views/feedbacks_view.dart';
import 'views/dashboard_view.dart';
import 'views/student_panel_view.dart';
import 'views/login_view.dart';

void main() {
  runApp(const SenacDevNestApp());
}

// Mapa de rotas → builders
final _routes = <String, WidgetBuilder>{
  '/': (_) => const HomeView(),
  '/login': (_) => const LoginView(),
  '/admin': (_) => const AdminPanelView(),
  '/networking': (_) => const NetworkingView(),
  '/feedbacks': (_) => const FeedbacksView(),
  '/dashboard': (_) => const DashboardView(),
  '/student-panel': (_) => const StudentPanelView(),
  '/cadastro': (_) => const CadastroView(),
};

// Transição fade para todas as rotas
Route<dynamic> _fadeRoute(RouteSettings settings) {
  final builder = _routes[settings.name] ?? _routes['/']!;
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, _) => builder(context),
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, _, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}

class SenacDevNestApp extends StatelessWidget {
  const SenacDevNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENAC DevNest',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/login',
      onGenerateRoute: _fadeRoute,
    );
  }
}

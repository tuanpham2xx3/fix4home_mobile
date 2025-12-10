import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/check_email_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/congratulations_screen.dart';
import '../../features/home/presentation/main_navigation.dart';
import '../../features/home/presentation/service_menu_screen.dart';
import '../../data/services/menu_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}


final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/home', // Changed to /home for debug mode
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/check-email',
        builder: (context, state) => const CheckEmailScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: '/congratulations',
        builder: (context, state) => const CongratulationsScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/service-menu/:key',
        builder: (context, state) {
          final serviceKey = state.pathParameters['key'] ?? '';
          // Get title from MenuService instead of URL to avoid encoding issues
          final serviceTitle = MenuService.getServiceTitle(serviceKey);
          return ServiceMenuScreen(
            serviceKey: serviceKey,
            serviceTitle: serviceTitle,
          );
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final loggingIn = state.matchedLocation == '/login';
      final registering = state.matchedLocation == '/register';
      final checkingEmail = state.matchedLocation == '/check-email';
      final resettingPassword = state.matchedLocation.startsWith('/reset-password');
      final congratulations = state.matchedLocation == '/congratulations';
      final serviceMenu = state.matchedLocation.startsWith('/service-menu') || 
                          state.uri.path.startsWith('/service-menu');

      return authState.when(
        data: (authStateValue) {
          final loggedIn = authStateValue.when(
            initial: () => false,
            loading: () => false,
            authenticated: (_) => true,
            unauthenticated: () => false,
            error: (_) => false,
          );
          final isPublicPage = loggingIn || registering || checkingEmail || resettingPassword || congratulations;

          // Allow service-menu for authenticated users
          if (serviceMenu && loggedIn) {
            return null;
          }

          if (!loggedIn && !isPublicPage) {
            return '/login';
          }

          if (loggedIn && (loggingIn || registering)) {
            return '/home';
          }

          return null;
        },
        loading: () => '/splash',
        error: (_, __) => '/login',
      );
    },
  );
});

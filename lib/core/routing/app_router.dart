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
import '../../features/home/presentation/search_screen.dart';
import '../../features/home/presentation/quick_booking_screen.dart';
import '../../features/home/presentation/booking_success_screen.dart';
import '../../features/home/presentation/chat_detail_screen.dart';
import '../../features/home/presentation/price_list_screen.dart';
import '../../features/home/presentation/price_group_screen.dart';
import '../../features/home/presentation/price_detail_screen.dart';
import '../../features/home/presentation/news_list_screen.dart';
import '../../features/home/presentation/news_detail_screen.dart';
import '../../features/home/presentation/notifications_screen.dart';
import '../../data/services/menu_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}


// Create a listenable for auth state changes without rebuilding the router
class AuthNotifier extends ChangeNotifier {
  final Ref ref;
  AuthNotifier(this.ref) {
    ref.listen(authControllerProvider, (_, __) {
      notifyListeners();
    });
  }
}

final authNotifierProvider = Provider<AuthNotifier>((ref) => AuthNotifier(ref));

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login', // Default to login screen
    refreshListenable: ref.watch(authNotifierProvider),
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
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/quick-booking',
        builder: (context, state) {
          final serviceName = state.uri.queryParameters['serviceName'];
          return QuickBookingScreen(
            serviceName: serviceName,
          );
        },
      ),
      GoRoute(
        path: '/booking-success',
        builder: (context, state) => const BookingSuccessScreen(),
      ),
      GoRoute(
        path: '/chat/:conversationId',
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId'] ?? '';
          return ChatDetailScreen(conversationId: conversationId);
        },
      ),
      GoRoute(
        path: '/price',
        builder: (context, state) => const PriceListScreen(),
      ),
      GoRoute(
        path: '/price/:groupName',
        builder: (context, state) {
          final groupName = state.pathParameters['groupName'] ?? '';
          return PriceGroupScreen(groupName: groupName);
        },
      ),
      GoRoute(
        path: '/price/:groupName/:itemName',
        builder: (context, state) {
          final groupName = state.pathParameters['groupName'] ?? '';
          final itemName = state.pathParameters['itemName'] ?? '';
          return PriceDetailScreen(
            groupName: groupName,
            itemName: itemName,
          );
        },
      ),
      GoRoute(
        path: '/news',
        builder: (context, state) => const NewsListScreen(),
      ),
      GoRoute(
        path: '/news/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return NewsDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Get auth state inside redirect handler instead of watching it at router level
      final authState = ref.read(authControllerProvider);
      
      // Get current path from both matchedLocation and uri.path for accuracy
      final matchedLocation = state.matchedLocation;
      final currentPath = state.uri.path;
      
      // DEBUG: Log every redirect attempt
      print('🔍 ROUTER DEBUG: matchedLocation=$matchedLocation, currentPath=$currentPath, authState=${authState.runtimeType}');
      
      final loggingIn = matchedLocation == '/login' || currentPath == '/login';
      final registering = matchedLocation == '/register' || currentPath == '/register';
      final checkingEmail = matchedLocation == '/check-email' || currentPath == '/check-email';
      final resettingPassword = matchedLocation.startsWith('/reset-password') || 
                                currentPath.startsWith('/reset-password');
      final congratulations = matchedLocation == '/congratulations' || 
                             currentPath == '/congratulations';
      final serviceMenu = matchedLocation.startsWith('/service-menu') || 
                          currentPath.startsWith('/service-menu');
      final quickBooking = matchedLocation == '/quick-booking' ||
                          currentPath == '/quick-booking';
      final bookingSuccess = matchedLocation == '/booking-success' ||
                            currentPath == '/booking-success';
      final chat = matchedLocation.startsWith('/chat') ||
                   currentPath.startsWith('/chat');
      final price = matchedLocation.startsWith('/price') ||
                   currentPath.startsWith('/price');
      final news = matchedLocation.startsWith('/news') ||
                   currentPath.startsWith('/news');
      final notifications = matchedLocation == '/notifications' ||
                           currentPath == '/notifications';

      final isPublicPage = loggingIn || registering || checkingEmail || resettingPassword || congratulations;

      return authState.when(
        data: (authStateValue) {
          // DISABLED: All automatic redirects for login/register screens
          // Only manual navigation via buttons is allowed
          print('🔍 DATA HANDLER: loggingIn=$loggingIn, registering=$registering');
          if (loggingIn || registering) {
            print('✅ STAYING on login/register screen - NO REDIRECT');
            return null;  // NEVER redirect from login or register
          }
          
          final loggedIn = authStateValue.when(
            initial: () => false,
            loading: () => false,
            authenticated: (_) => true,
            unauthenticated: () => false,
            error: (_) => false,
          );

          // Allow authenticated users to access protected screens
          if ((serviceMenu || quickBooking || bookingSuccess || chat || price || news || notifications) && loggedIn) {
            return null;
          }

          // SIMPLIFIED: Only redirect non-authenticated users away from protected pages
          // But NEVER touch public pages (login, register, etc)
          if (!loggedIn && !isPublicPage) {
            return '/login';
          }

          return null;
        },
        loading: () {
          // DISABLED: Never redirect during loading if on login/register
          print('🔍 LOADING HANDLER: loggingIn=$loggingIn, registering=$registering');
          if (loggingIn || registering) {
            print('✅ STAYING on login/register screen during loading - NO REDIRECT');
            return null;
          }
          print('⚠️ Redirecting to splash');
          return '/splash';
        },
        error: (_, __) {
          // DISABLED: Never redirect on error if on any public page
          print('🔍 ERROR HANDLER: isPublicPage=$isPublicPage, registering=$registering');
          if (isPublicPage) {
            print('✅ STAYING on public page on error - NO REDIRECT');
            return null;
          }
          // Only redirect if on a protected page
          print('⚠️ Error on protected page, redirecting to login');
          return '/login';
        },
      );
    },
  );
});

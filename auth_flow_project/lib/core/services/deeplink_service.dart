import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_links/uni_links.dart';
import '../../features/auth/application/auth_controller.dart';
import '../routing/app_router.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return DeepLinkService(ref);
});

class DeepLinkService {
  final Ref _ref;
  StreamSubscription? _sub;

  DeepLinkService(this._ref) {
    _init();
  }

  void _init() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  void _handleUri(Uri uri) {
    if (uri.scheme == 'myapp' && uri.host == 'auth') {
      final path = uri.path;
      if (path == '/activate') {
        final token = uri.queryParameters['token'];
        if (token != null) {
          _ref.read(authControllerProvider.notifier).activateAccount(token);
          _ref.read(routerProvider).go('/login');
          // In a real app, you would show a success message
        }
      } else if (path == '/reset') {
        final token = uri.queryParameters['token'];
        if (token != null) {
          _ref.read(routerProvider).go('/reset-password?token=$token');
        }
      }
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}

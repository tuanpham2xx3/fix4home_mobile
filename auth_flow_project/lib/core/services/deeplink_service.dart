import 'dart:async';
import 'package:flutter/material.dart';
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

  // A context is needed to show SnackBars. We can get it from the router.
  BuildContext? get _context => _ref.read(routerProvider).routerDelegate.navigatorKey.currentContext;

  DeepLinkService(this._ref) {
    _init();
  }

  void _init() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    }, onError: (err) {
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(content: Text('Failed to handle deep link: $err')),
        );
      }
    });
  }

  Future<void> _handleUri(Uri uri) async {
    if (uri.scheme == 'myapp' && uri.host == 'auth') {
      final path = uri.path;
      if (path == '/activate') {
        final token = uri.queryParameters['token'];
        if (token != null) {
          try {
            await _ref.read(authControllerProvider.notifier).activateAccount(token);
            if (_context != null) {
              ScaffoldMessenger.of(_context!).showSnackBar(
                const SnackBar(content: Text('Account activated successfully!')),
              );
            }
          } catch (e) {
             if (_context != null) {
              ScaffoldMessenger.of(_context!).showSnackBar(
                SnackBar(content: Text('Failed to activate account: $e')),
              );
            }
          }
          _ref.read(routerProvider).go('/login');
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

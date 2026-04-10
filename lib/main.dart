import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/firebase_options.dart';
import 'package:seedling/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    // Firebase may already be initialized on Android
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }
  runApp(const ProviderScope(child: SeedlingApp()));
}

class SeedlingApp extends ConsumerWidget {
  const SeedlingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Seedling',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/features/child/child_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/services/ai_service.dart' show AiService;
import 'package:seedling/services/firestore_service.dart';

class SessionCompleteScreen extends ConsumerStatefulWidget {
  const SessionCompleteScreen({super.key});

  @override
  ConsumerState<SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends ConsumerState<SessionCompleteScreen> {
  bool _saving = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _saveSession();
  }

  Future<void> _saveSession() async {
    setState(() => _saving = true);

    final session = ref.read(childSessionProvider);
    final activeChild = ref.read(activeChildProfileProvider);
    final authAsync = ref.read(authStateProvider);
    final userId = authAsync.valueOrNull?.uid;
    final firestoreService = ref.read(firestoreServiceProvider);
    final aiService = AiService();

    if (userId == null || activeChild == null || session.sessionId == null) {
      setState(() { _saving = false; _done = true; });
      return;
    }

    try {
      await firestoreService.endChildSession(
        userId: userId,
        childId: activeChild.id,
        sessionId: session.sessionId!,
        completedActivities:
            session.completedActivities.map((e) => e.toMap()).toList(),
        durationMinutes: session.elapsedMinutes,
      );

      if (session.completedActivities.isNotEmpty) {
        try {
          await aiService.generateSessionReport(
            childId: activeChild.id,
            sessionId: session.sessionId!,
            activities:
                session.completedActivities.map((e) => e.toMap()).toList(),
            durationMinutes: session.elapsedMinutes,
          );
          await firestoreService.clearReportStatus(
            userId: userId,
            childId: activeChild.id,
            sessionId: session.sessionId!,
          );
        } catch (e) {
          await firestoreService.markReportFailed(
            userId: userId,
            childId: activeChild.id,
            sessionId: session.sessionId!,
            error: e.toString(),
          );
        }
      }
    } catch (_) {
      // endChildSession failed — can't mark report status without sessionId guaranteed
    } finally {
      if (mounted) setState(() { _saving = false; _done = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(childSessionProvider);
    final count = session.completedActivities.length;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F4EF),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 24),
                  const Text(
                    'Great job today!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    count == 0
                        ? 'You had a session today.'
                        : 'You did $count ${count == 1 ? "activity" : "activities"}!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.seedGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _done
                          ? () {
                              ref.read(childSessionProvider.notifier).reset();
                              context.go('/');
                            }
                          : null,
                      child: _saving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Done - tell my parent!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

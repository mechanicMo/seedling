import 'package:cloud_functions/cloud_functions.dart';
import 'package:seedling/models/models.dart';

class AiService {
  AiService({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  /// Calls the `getParentGuidance` Cloud Function.
  /// Returns the AI response and guide reference IDs.
  /// Throws [FirebaseFunctionsException] on error.
  Future<({String response, List<String> guideRefs, String sessionId})>
      getParentGuidance({
    required String situation,
    required String childId,
  }) async {
    final callable = _functions.httpsCallable('getParentGuidance');
    final result = await callable.call<Map<String, dynamic>>({
      'situation': situation,
      'childId': childId,
    });

    final data = result.data;
    return (
      response: data['response'] as String,
      guideRefs: List<String>.from(data['guide_refs'] as List? ?? []),
      sessionId: data['session_id'] as String,
    );
  }

  /// Calls the `generateSessionReport` Cloud Function.
  /// Called after a child session ends.
  Future<SessionReport> generateSessionReport({
    required String childId,
    required String sessionId,
    required List<Map<String, dynamic>> activities,
    required int durationMinutes,
  }) async {
    final callable = _functions.httpsCallable('generateSessionReport');
    final result = await callable.call<Map<String, dynamic>>({
      'childId': childId,
      'sessionId': sessionId,
      'activities': activities,
      'duration_minutes': durationMinutes,
    });

    return SessionReport.fromMap(Map<String, dynamic>.from(result.data));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    required String displayName,
    @Default('free') String tier,
    DateTime? createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser.fromJson({
      ...data,
      'id': doc.id,
      // Firestore Timestamps need manual conversion
      if (data['created_at'] is Timestamp)
        'createdAt': (data['created_at'] as Timestamp).toDate().toIso8601String(),
    });
  }
}

extension AppUserFirestore on AppUser {
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'display_name': displayName,
      'tier': tier,
      'created_at': FieldValue.serverTimestamp(),
    };
  }
}

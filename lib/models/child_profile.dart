import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:seedling/core/constants/app_constants.dart';

part 'child_profile.freezed.dart';
part 'child_profile.g.dart';

@freezed
class ContentSelection with _$ContentSelection {
  const factory ContentSelection({
    @Default(AppConstants.allCategories) List<String> enabledCategories,
    @Default(AppConstants.allActivityTypes) List<String> enabledActivityTypes,
  }) = _ContentSelection;

  factory ContentSelection.fromJson(Map<String, dynamic> json) =>
      _$ContentSelectionFromJson(json);
}

@freezed
class ChildProfile with _$ChildProfile {
  const ChildProfile._();

  const factory ChildProfile({
    required String id,
    required String name,
    required DateTime birthDate,
    required String ageRange,
    @Default(AppConstants.defaultSessionTimerMinutes) int sessionTimerMinutes,
    @Default(ContentSelection()) ContentSelection contentSelection,
  }) = _ChildProfile;

  factory ChildProfile.fromJson(Map<String, dynamic> json) =>
      _$ChildProfileFromJson(json);

  factory ChildProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final contentSelectionData = data['content_selection'] as Map<String, dynamic>?;
    return ChildProfile(
      id: doc.id,
      name: data['name'] as String,
      birthDate: data['birth_date'] is Timestamp
          ? (data['birth_date'] as Timestamp).toDate()
          : DateTime.parse(data['birth_date'] as String),
      ageRange: data['age_range'] as String,
      sessionTimerMinutes: data['session_timer_minutes'] as int? ??
          AppConstants.defaultSessionTimerMinutes,
      contentSelection: contentSelectionData != null
          ? ContentSelection(
              enabledCategories: List<String>.from(
                  contentSelectionData['enabled_categories'] as List? ??
                      AppConstants.allCategories),
              enabledActivityTypes: List<String>.from(
                  contentSelectionData['enabled_activity_types'] as List? ??
                      AppConstants.allActivityTypes),
            )
          : const ContentSelection(),
    );
  }

  /// Derives age range string from birth date. Call when creating or updating a profile.
  static String calculateAgeRange(DateTime birthDate) {
    final now = DateTime.now();
    int ageInMonths = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    if (now.day < birthDate.day) ageInMonths--;
    final ageInYears = ageInMonths / 12;

    if (ageInYears < 3) return AppConstants.ageRange0to3;
    if (ageInYears < 7) return AppConstants.ageRange3to7;
    return AppConstants.ageRange7to12;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'birth_date': Timestamp.fromDate(birthDate),
      'age_range': ageRange,
      'session_timer_minutes': sessionTimerMinutes,
      'content_selection': {
        'enabled_categories': contentSelection.enabledCategories,
        'enabled_activity_types': contentSelection.enabledActivityTypes,
      },
    };
  }
}

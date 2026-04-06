import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/models/models.dart';
import 'package:seedling/core/constants/app_constants.dart';

void main() {
  group('ChildProfile.calculateAgeRange', () {
    test('returns 0-3 for child under 3 years old', () {
      final birthDate = DateTime.now().subtract(const Duration(days: 365 * 2));
      expect(ChildProfile.calculateAgeRange(birthDate), AppConstants.ageRange0to3);
    });

    test('returns 3-7 for child aged 3 to 6', () {
      final birthDate = DateTime.now().subtract(const Duration(days: 365 * 4));
      expect(ChildProfile.calculateAgeRange(birthDate), AppConstants.ageRange3to7);
    });

    test('returns 7-12 for child aged 7 and above', () {
      final birthDate = DateTime.now().subtract(const Duration(days: 365 * 8));
      expect(ChildProfile.calculateAgeRange(birthDate), AppConstants.ageRange7to12);
    });

    test('returns 3-7 for child exactly at 3rd birthday', () {
      final birthDate = DateTime(
        DateTime.now().year - 3,
        DateTime.now().month,
        DateTime.now().day,
      );
      expect(ChildProfile.calculateAgeRange(birthDate), AppConstants.ageRange3to7);
    });
  });

  group('ContentSelection defaults', () {
    test('all categories enabled by default', () {
      const selection = ContentSelection();
      expect(selection.enabledCategories, AppConstants.allCategories);
    });

    test('all activity types enabled by default', () {
      const selection = ContentSelection();
      expect(selection.enabledActivityTypes, AppConstants.allActivityTypes);
    });
  });

  group('ChildProfile serialization', () {
    test('toFirestore removes id field', () {
      final profile = ChildProfile(
        id: 'test-id',
        name: 'Sherani',
        birthDate: DateTime(2023, 2, 15),
        ageRange: AppConstants.ageRange0to3,
      );
      final map = profile.toFirestore();
      expect(map.containsKey('id'), false);
      expect(map['name'], 'Sherani');
    });
  });
}

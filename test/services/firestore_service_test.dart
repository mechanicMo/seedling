import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/models/models.dart';
import 'package:seedling/services/firestore_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = FirestoreService(firestore: fakeFirestore);
  });

  group('FirestoreService - child profiles', () {
    const userId = 'user-123';

    test('createChildProfile saves document and returns profile with id', () async {
      final profile = ChildProfile(
        id: '',
        name: 'Sherani',
        birthDate: DateTime(2023, 2, 15),
        ageRange: AppConstants.ageRange0to3,
      );

      final created = await service.createChildProfile(userId, profile);

      expect(created.id, isNotEmpty);
      expect(created.name, 'Sherani');
    });

    test('getChildProfiles returns profiles for user', () async {
      final profile = ChildProfile(
        id: '',
        name: 'Test Child',
        birthDate: DateTime(2020, 6, 1),
        ageRange: AppConstants.ageRange3to7,
      );
      await service.createChildProfile(userId, profile);

      final profiles = await service.getChildProfiles(userId).first;
      expect(profiles.length, 1);
      expect(profiles.first.name, 'Test Child');
    });

    test('updateChildProfile persists changes', () async {
      final profile = ChildProfile(
        id: '',
        name: 'Original Name',
        birthDate: DateTime(2020, 1, 1),
        ageRange: AppConstants.ageRange3to7,
      );
      final created = await service.createChildProfile(userId, profile);
      final updated = created.copyWith(name: 'Updated Name');

      await service.updateChildProfile(userId, updated);

      final profiles = await service.getChildProfiles(userId).first;
      expect(profiles.first.name, 'Updated Name');
    });

    test('deleteChildProfile removes document', () async {
      final profile = ChildProfile(
        id: '',
        name: 'To Delete',
        birthDate: DateTime(2021, 3, 10),
        ageRange: AppConstants.ageRange3to7,
      );
      final created = await service.createChildProfile(userId, profile);

      await service.deleteChildProfile(userId, created.id);

      final profiles = await service.getChildProfiles(userId).first;
      expect(profiles, isEmpty);
    });

    test('getChildProfiles returns empty list when no profiles exist', () async {
      final profiles = await service.getChildProfiles(userId).first;
      expect(profiles, isEmpty);
    });
  });

  group('FirestoreService - user', () {
    test('hasChildProfiles returns false when no children', () async {
      final result = await service.hasChildProfiles('new-user');
      expect(result, false);
    });

    test('hasChildProfiles returns true after creating a profile', () async {
      const userId = 'user-456';
      await service.createChildProfile(
        userId,
        ChildProfile(
          id: '',
          name: 'Child',
          birthDate: DateTime(2021, 1, 1),
          ageRange: AppConstants.ageRange3to7,
        ),
      );
      final result = await service.hasChildProfiles(userId);
      expect(result, true);
    });
  });
}

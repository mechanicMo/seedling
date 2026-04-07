import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';
import 'package:seedling/services/firestore_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockAuth = MockFirebaseAuth(signedIn: true);
  });

  test('childProfilesProvider returns empty list initially', () async {
    final container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockAuth),
        firestoreServiceProvider.overrideWithValue(
          FirestoreService(firestore: fakeFirestore),
        ),
      ],
    );
    addTearDown(container.dispose);

    final profiles = await container.read(childProfilesProvider.future);
    expect(profiles, isEmpty);
  });

  test('addChildProfile adds a profile', () async {
    final container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockAuth),
        firestoreServiceProvider.overrideWithValue(
          FirestoreService(firestore: fakeFirestore),
        ),
      ],
    );
    addTearDown(container.dispose);

    final profile = ChildProfile(
      id: '',
      name: 'Sherani',
      birthDate: DateTime(2023, 2, 15),
      ageRange: AppConstants.ageRange0to3,
    );

    await container.read(childProfilesNotifierProvider.notifier).add(profile);

    // Wait for stream to emit
    await Future.delayed(const Duration(milliseconds: 100));

    final profiles = await container.read(childProfilesProvider.future);
    expect(profiles.length, 1);
    expect(profiles.first.name, 'Sherani');
  });

  test('deleteChildProfile removes a profile', () async {
    final container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockAuth),
        firestoreServiceProvider.overrideWithValue(
          FirestoreService(firestore: fakeFirestore),
        ),
      ],
    );
    addTearDown(container.dispose);

    final profile = ChildProfile(
      id: '',
      name: 'Test',
      birthDate: DateTime(2020, 1, 1),
      ageRange: AppConstants.ageRange3to7,
    );
    await container.read(childProfilesNotifierProvider.notifier).add(profile);

    await Future.delayed(const Duration(milliseconds: 100));

    final profiles = await container.read(childProfilesProvider.future);
    await container
        .read(childProfilesNotifierProvider.notifier)
        .delete(profiles.first.id);

    await Future.delayed(const Duration(milliseconds: 100));

    final updated = await container.read(childProfilesProvider.future);
    expect(updated, isEmpty);
  });
}

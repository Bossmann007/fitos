import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitos/core/entities/profile.dart';
import 'package:fitos/features/perfil/domain/repositories/profile_repository.dart';
import 'package:fitos/features/perfil/domain/use_cases/save_profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late SaveProfile saveProfile;
  late MockProfileRepository mockRepo;

  setUp(() {
    mockRepo = MockProfileRepository();
    saveProfile = SaveProfile(mockRepo);
  });

  test('deve chamar repository.save com o perfil correto', () {
    const profile = Profile(name: 'Enzo', age: 18, weight: 75.0, height: 178.0);
    when(() => mockRepo.save(profile)).thenReturn(null);

    saveProfile(profile);

    verify(() => mockRepo.save(profile)).called(1);
  });
}

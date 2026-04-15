import '../../../../core/entities/profile.dart';

abstract class ProfileRepository {
  void save(Profile profile);
  Profile? get();
}

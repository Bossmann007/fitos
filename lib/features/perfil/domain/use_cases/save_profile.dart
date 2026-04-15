import '../../../../core/entities/profile.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/profile_repository.dart';

class SaveProfile extends UseCase<void, Profile> {
  final ProfileRepository repository;
  SaveProfile(this.repository);

  @override
  void call(Profile params) => repository.save(params);
}

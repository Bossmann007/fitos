import '../../../../core/entities/profile.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/profile_repository.dart';

class GetProfile extends UseCase<Profile?, NoParams> {
  final ProfileRepository repository;
  GetProfile(this.repository);

  @override
  Profile? call(NoParams params) => repository.get();
}

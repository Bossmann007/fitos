import 'package:hive/hive.dart';
import '../../../../core/entities/profile.dart';
import '../../../../data/hive/hive_boxes.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_hive_model.dart';

class ProfileRepoImpl implements ProfileRepository {
  Box<ProfileHiveModel> get _box =>
      Hive.box<ProfileHiveModel>(HiveBoxes.profile);

  @override
  void save(Profile profile) {
    _box.put('profile', ProfileHiveModel.fromEntity(profile));
  }

  @override
  Profile? get() => _box.get('profile')?.toEntity();
}

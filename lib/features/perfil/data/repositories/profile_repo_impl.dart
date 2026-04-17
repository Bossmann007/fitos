import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import '../../../../core/entities/profile.dart';
import '../../../../data/hive/hive_boxes.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_hive_model.dart';

class ProfileRepoImpl implements ProfileRepository {
  // Armazenamento em memória para web
  static Profile? _webProfile;

  Box<ProfileHiveModel> get _box =>
      Hive.box<ProfileHiveModel>(HiveBoxes.profile);

  @override
  void save(Profile profile) {
    if (kIsWeb) { _webProfile = profile; return; }
    _box.put('profile', ProfileHiveModel.fromEntity(profile));
  }

  @override
  Profile? get() {
    if (kIsWeb) return _webProfile;
    return _box.get('profile')?.toEntity();
  }
}

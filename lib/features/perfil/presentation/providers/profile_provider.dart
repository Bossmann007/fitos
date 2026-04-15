// lib/features/perfil/presentation/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/entities/profile.dart';
import '../../../../core/use_cases/use_case.dart';
import '../../data/repositories/profile_repo_impl.dart';
import '../../domain/use_cases/get_profile.dart';
import '../../domain/use_cases/save_profile.dart';

final profileRepoProvider = Provider((_) => ProfileRepoImpl());

final saveProfileProvider = Provider(
  (ref) => SaveProfile(ref.read(profileRepoProvider)),
);

final getProfileProvider = Provider(
  (ref) => GetProfile(ref.read(profileRepoProvider)),
);

/// Estado do perfil: null = não configurado ainda
final profileStateProvider = StateNotifierProvider<ProfileNotifier, Profile?>(
  (ref) => ProfileNotifier(
    ref.read(saveProfileProvider),
    ref.read(getProfileProvider),
  ),
);

class ProfileNotifier extends StateNotifier<Profile?> {
  final SaveProfile _save;
  final GetProfile _get;

  ProfileNotifier(this._save, this._get) : super(null) {
    _load();
  }

  void _load() {
    state = _get(const NoParams());
  }

  void save(Profile profile) {
    _save(profile);
    state = profile;
  }
}

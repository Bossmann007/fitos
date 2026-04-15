// test/widgets/perfil/perfil_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitos/core/entities/profile.dart';
import 'package:fitos/features/perfil/domain/repositories/profile_repository.dart';
import 'package:fitos/features/perfil/presentation/perfil_screen.dart';
import 'package:fitos/features/perfil/presentation/providers/profile_provider.dart';

/// Repositório falso que não acessa Hive
class _FakeProfileRepo implements ProfileRepository {
  @override
  Profile? get() => null;

  @override
  void save(Profile profile) {}
}

void main() {
  // Override profileRepoProvider para não acessar Hive nos testes
  final overrides = [
    profileRepoProvider.overrideWith((_) => _FakeProfileRepo()),
  ];

  testWidgets('PerfilScreen exibe formulário com 4 campos', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: PerfilScreen()),
      ),
    );

    expect(find.text('Meu Perfil'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Salvar Perfil'), findsOneWidget);
  });

  testWidgets('PerfilScreen valida campo nome vazio', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: PerfilScreen()),
      ),
    );

    await tester.tap(find.text('Salvar Perfil'));
    await tester.pump();

    expect(find.text('Informe seu nome'), findsOneWidget);
  });
}

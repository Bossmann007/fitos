// test/widgets/perfil/perfil_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitos/features/perfil/presentation/perfil_screen.dart';

void main() {
  testWidgets('PerfilScreen exibe formulário com 4 campos', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: PerfilScreen()),
      ),
    );

    expect(find.text('Meu Perfil'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Salvar Perfil'), findsOneWidget);
  });

  testWidgets('PerfilScreen valida campo nome vazio', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: PerfilScreen()),
      ),
    );

    await tester.tap(find.text('Salvar Perfil'));
    await tester.pump();

    expect(find.text('Informe seu nome'), findsOneWidget);
  });
}

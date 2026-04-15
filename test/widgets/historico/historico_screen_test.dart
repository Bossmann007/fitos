// test/widgets/historico/historico_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitos/features/historico/presentation/historico_screen.dart';

void main() {
  testWidgets('HistoricoScreen exibe mensagem quando vazio', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HistoricoScreen()),
      ),
    );
    expect(find.text('Nenhum treino registrado'), findsOneWidget);
  });

  testWidgets('HistoricoScreen exibe chips de filtro', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HistoricoScreen()),
      ),
    );
    expect(find.byType(FilterChip), findsWidgets);
    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('Full Body A'), findsOneWidget);
  });
}

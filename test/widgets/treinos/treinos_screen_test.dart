// test/widgets/treinos/treinos_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitos/features/treinos/presentation/treinos_screen.dart';

void main() {
  testWidgets('TreinosScreen exibe card "Como você está hoje?"',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: TreinosScreen()),
      ),
    );
    expect(find.text('Como você está hoje?'), findsOneWidget);
    expect(find.byType(Slider), findsNWidgets(2));
    expect(find.text('Ver Sugestão'), findsOneWidget);
  });

  testWidgets('TreinosScreen exibe botão de treino manual', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: TreinosScreen()),
      ),
    );
    expect(find.text('Escolher Manualmente'), findsOneWidget);
  });
}

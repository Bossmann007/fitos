// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/hive/hive_init.dart';
import 'features/perfil/presentation/perfil_screen.dart';
import 'features/perfil/presentation/providers/profile_provider.dart';
import 'features/treinos/presentation/treinos_screen.dart';
import 'features/historico/presentation/historico_screen.dart';
import 'features/progresso/presentation/progresso_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.initialize();
  runApp(const ProviderScope(child: FitOSApp()));
}

class FitOSApp extends StatelessWidget {
  const FitOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const _AppShell(),
    );
  }
}

class _AppShell extends ConsumerStatefulWidget {
  const _AppShell();

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell> {
  int _currentIndex = 0;

  static const _screens = [
    TreinosScreen(),
    HistoricoScreen(),
    ProgressoScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileStateProvider);

    // Redireciona para setup do perfil na primeira abertura
    if (profile == null) {
      return const PerfilScreen();
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Treinos',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Progresso',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

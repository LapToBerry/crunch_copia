import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/profile_screen.dart';
import 'services/supabase_service.dart';
import 'screens/navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade - Mangás e Animes',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
        home: NavigationScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prueba/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dvyshiduehjmhdgiremf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2eXNoaWR1ZWhqbWhkZ2lyZW1mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQ3NTg4OTAsImV4cCI6MjAzMDMzNDg5MH0.8uE70TwQ2l2Ey-rRtsyGyAqMvcVJNWUE1l6_PewZoVw',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

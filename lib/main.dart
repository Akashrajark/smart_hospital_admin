import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login/login_screen.dart';
import 'theme/apptheme.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ifcksfwmrvraauyqcwde.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmY2tzZndtcnZyYWF1eXFjd2RlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NTU5NDkyNCwiZXhwIjoyMDcxMTcwOTI0fQ.IMdygTBUDfLnbnMC7xpRqpGFdLzH8JaINv6mV-YrWcc',
  );

  runApp(ChangeNotifierProvider(create: (context) => ThemeProvider(), child: const HospitalAdminApp()));
}

class HospitalAdminApp extends StatelessWidget {
  const HospitalAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Admin Panel',
      // themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: lightMode,
      // darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

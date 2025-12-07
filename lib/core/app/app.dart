import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/theme/app_theme.dart';
import '../../features/navigation/presentation/pages/main_navigation_page.dart';

class MonsterHunterApp extends StatefulWidget {
  const MonsterHunterApp({super.key});

  @override
  State<MonsterHunterApp> createState() => _MonsterHunterAppState();
}

class _MonsterHunterAppState extends State<MonsterHunterApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Carica la preferenza del tema salvata
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDarkMode = prefs.getBool('isDarkMode') ?? false;
    
    setState(() {
      _isDarkMode = savedDarkMode;
    });
  }

  // Cambia tra tema chiaro e scuro
  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Cambia il tema
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    
    // Salva la preferenza
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Hunter Compendium',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: MainNavigationPage(
        onThemeToggle: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';
import '../../features/navigation/presentation/pages/main_navigation_page.dart';

class MonsterHunterApp extends StatelessWidget {
  const MonsterHunterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Hunter',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationPage(),
    );
  }
}


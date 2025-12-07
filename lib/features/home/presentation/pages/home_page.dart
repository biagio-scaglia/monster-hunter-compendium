import 'package:flutter/material.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monster Hunter Compendium'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Hunter',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Your complete guide to the world of Monster Hunter',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            GradientCard(
              onTap: () {
                // Navigate to monsters
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryButtonGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.pets,
                          color: AppTheme.primaryText,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Browse Monsters',
                              style: AppTheme.cardTitleStyle,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Explore all creatures',
                              style: AppTheme.cardBodyStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              onTap: () {
                // Navigate to weapons
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryButtonGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.sports_martial_arts,
                          color: AppTheme.primaryText,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weapons Arsenal',
                              style: AppTheme.cardTitleStyle,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Discover all weapon types',
                              style: AppTheme.cardBodyStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              onTap: () {
                // Navigate to armor
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryButtonGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: AppTheme.primaryText,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Armor Collection',
                              style: AppTheme.cardTitleStyle,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Build your perfect set',
                              style: AppTheme.cardBodyStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Start Your Hunt',
              icon: Icons.explore,
              isFullWidth: true,
              onPressed: () {
                // Navigate to hub
              },
            ),
          ],
        ),
      ),
    );
  }
}

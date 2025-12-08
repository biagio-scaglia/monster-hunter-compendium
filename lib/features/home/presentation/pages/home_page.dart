import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onThemeToggle;
  final bool? isDarkMode;

  const HomePage({
    super.key,
    this.onThemeToggle,
    this.isDarkMode,
  });

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Cannot open URL: $url');
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
    }
  }

  void _showInfoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkCardGradient
              : AppTheme.cardGradient,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.elderDragonAura,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: AppTheme.darkTextPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'About',
                    style: AppTheme.cardTitleStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Developer Section
            _buildDetailSection(
              context,
              icon: Icons.person,
              title: 'Developer',
              content: 'Biagio Scaglia',
              description: 'Full-stack developer passionate about mobile apps and game data.',
            ),
            const SizedBox(height: 24),
            // Repository Section
            _buildDetailSection(
              context,
              icon: Icons.code,
              title: 'Repository',
              content: 'GitHub',
              description: 'Open source project available on GitHub',
              onTap: () {
                _openUrl('https://github.com/biagio-scaglia/monster-hunter-compendium');
              },
              isLink: true,
            ),
            const SizedBox(height: 24),
            // API Section
            _buildDetailSection(
              context,
              icon: Icons.api,
              title: 'Data Source',
              content: 'mhw-db.com',
              description: 'All data provided by the public MHW API',
              onTap: () {
                _openUrl('https://mhw-db.com');
              },
              isLink: true,
            ),
            const SizedBox(height: 24),
            // Theme Section
            Builder(
              builder: (context) {
                final bool darkMode = isDarkMode ?? 
                    (Theme.of(context).brightness == Brightness.dark);
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkBorder.withValues(alpha: 0.3)
                        : AppTheme.lightBorder.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        darkMode ? Icons.dark_mode : Icons.light_mode,
                        size: 24,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Theme',
                              style: AppTheme.cardTitleStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              darkMode
                                  ? 'Dark mode for night hunters'
                                  : 'Light mode for daytime research',
                              style: AppTheme.cardBodyStyle.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: darkMode,
                        onChanged: onThemeToggle != null
                            ? (value) {
                                HapticFeedback.mediumImpact();
                                Navigator.pop(context);
                                onThemeToggle?.call();
                              }
                            : null,
                        activeThumbColor: AppTheme.wyvernGold,
                        activeTrackColor: AppTheme.wyvernGold.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: AppTheme.cardSubtitleStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required String description,
    VoidCallback? onTap,
    bool isLink = false,
  }) {
    Widget section = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTheme.cardSubtitleStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTheme.cardBodyStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isLink
                ? AppTheme.wyvernGold
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: AppTheme.cardBodyStyle.copyWith(
            fontSize: 13,
          ),
        ),
        if (isLink) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.open_in_new,
                size: 16,
                color: AppTheme.wyvernGold,
              ),
              const SizedBox(width: 4),
              Text(
                'Open in browser',
                style: AppTheme.cardBodyStyle.copyWith(
                  fontSize: 12,
                  color: AppTheme.wyvernGold,
                ),
              ),
            ],
          ),
        ],
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: section,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: section,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usa il tema del contesto come fallback se isDarkMode non è fornito
    final bool darkMode = isDarkMode ?? 
        (Theme.of(context).brightness == Brightness.dark);
    
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
            const SizedBox(height: 32),
            // Info Card
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cliccabile per aprire i dettagli
                  InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      _showInfoDialog(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppTheme.elderDragonAura,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: AppTheme.darkTextPrimary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'About',
                              style: AppTheme.cardTitleStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Developer
                  _buildInfoRow(
                    context,
                    icon: Icons.person,
                    label: 'Developed by',
                    value: 'Biagio Scaglia',
                  ),
                  const SizedBox(height: 16),
                  // Repository
                  _buildInfoRow(
                    context,
                    icon: Icons.code,
                    label: 'Repository',
                    value: 'GitHub',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.cardSubtitleStyle.copyWith(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTheme.cardBodyStyle.copyWith(
                  fontSize: 15,
                  fontWeight: isLink ? FontWeight.w600 : FontWeight.normal,
                  color: isLink
                      ? AppTheme.wyvernGold
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
        if (isLink)
          Icon(
            Icons.open_in_new,
            size: 18,
            color: AppTheme.wyvernGold,
          ),
      ],
    );
  }
}

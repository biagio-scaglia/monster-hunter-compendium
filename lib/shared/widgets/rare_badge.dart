import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RareBadge extends StatelessWidget {
  final String text;
  final bool withGlow;

  const RareBadge({
    super.key,
    required this.text,
    this.withGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppTheme.rareBadgeGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: withGlow
            ? [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        style: AppTheme.buttonStyle.copyWith(
          fontSize: 11,
          color: AppTheme.secondaryColor,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}


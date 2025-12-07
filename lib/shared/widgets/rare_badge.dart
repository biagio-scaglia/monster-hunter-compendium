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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppTheme.rareBadgeGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: withGlow
            ? [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        style: AppTheme.buttonStyle.copyWith(
          fontSize: 10,
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }
}


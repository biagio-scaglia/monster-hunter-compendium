import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final EdgeInsets? padding;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      decoration: BoxDecoration(
        gradient: onPressed != null 
            ? AppTheme.primaryButtonGradient 
            : LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade600],
              ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: onPressed != null ? AppTheme.buttonShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed != null
              ? () {
                  HapticFeedback.mediumImpact();
                  onPressed!();
                }
              : null,
          borderRadius: BorderRadius.circular(14),
          splashColor: AppTheme.primaryText.withOpacity(0.2),
          highlightColor: AppTheme.primaryText.withOpacity(0.1),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 16,
            ),
            child: Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppTheme.primaryText, size: 22),
                  const SizedBox(width: 10),
                ],
                Text(
                  text,
                  style: AppTheme.buttonStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}


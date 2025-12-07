import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../theme/app_theme.dart';

class SlidableListItem extends StatelessWidget {
  final Widget child;
  final List<SlidableAction>? actions;
  final List<SlidableAction>? secondaryActions;
  final VoidCallback? onTap;

  const SlidableListItem({
    super.key,
    required this.child,
    this.actions,
    this.secondaryActions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (actions == null && secondaryActions == null) {
      return InkWell(
        onTap: onTap,
        child: child,
      );
    }

    return Slidable(
      key: ValueKey(child.hashCode),
      startActionPane: actions != null
          ? ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.25,
              children: actions!,
            )
          : null,
      endActionPane: secondaryActions != null
          ? ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.25,
              children: secondaryActions!,
            )
          : null,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class SlidableActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const SlidableActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: (_) => onPressed(),
      backgroundColor: backgroundColor,
      foregroundColor: AppTheme.primaryText,
      icon: icon,
      label: label,
    );
  }
}


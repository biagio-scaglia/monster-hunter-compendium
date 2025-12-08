import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool isRare;
  final Gradient? customGradient;

  const GradientCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.isRare = false,
    this.customGradient,
  });

  @override
  State<GradientCard> createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Scegli il gradiente in base al tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = widget.customGradient ??
        (isDark ? AppTheme.darkCardGradient : AppTheme.cardGradient);

    // Crea la card con gradiente e ombra migliorata
    final shadows = widget.isRare 
        ? AppTheme.rareCardShadow 
        : (isDark ? AppTheme.cardShadowDark : AppTheme.cardShadow);
    
    Widget card = Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isRare 
              ? AppTheme.accentColor.withOpacity(0.3)
              : (isDark ? Colors.grey.shade800.withOpacity(0.5) : Colors.grey.shade200.withOpacity(0.5)),
          width: widget.isRare ? 1.5 : 1,
        ),
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppTheme.primaryColor.withOpacity(0.1),
          highlightColor: AppTheme.primaryColor.withOpacity(0.05),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(18),
            child: widget.child,
          ),
        ),
      ),
    );

    // Se la card è cliccabile, aggiungi l'animazione
    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: card,
        ),
      );
    }

    // Altrimenti restituisci la card normale
    return card;
  }
}


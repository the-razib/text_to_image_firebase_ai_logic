import 'package:firebase_ai_logic/core/constants/app_constants.dart';
import 'package:firebase_ai_logic/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = AppConstants.defaultRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          // soft dark shadow
          BoxShadow(
            color: AppColors.darkShadow.withValues(alpha: 0.12),
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
          // soft highlight
          const BoxShadow(
            color: AppColors.lightShadow,
            offset: Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

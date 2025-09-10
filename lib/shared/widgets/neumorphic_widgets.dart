import 'package:firebase_ai_logic/core/constants/app_constants.dart';
import 'package:firebase_ai_logic/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final bool isPressed;
  final VoidCallback? onTap;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppConstants.defaultRadius,
    this.backgroundColor,
    this.isPressed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: isPressed
                ? [
                    // Subtle inner shadow effect when pressed
                    BoxShadow(
                      color: AppColors.darkShadow.withValues(alpha: 0.1),
                      offset: const Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ]
                : [
                    // Normal neumorphic shadow
                    BoxShadow(
                      color: AppColors.darkShadow.withValues(alpha: 0.3),
                      offset: const Offset(
                        AppConstants.neumorphismSpreadRadius,
                        AppConstants.neumorphismSpreadRadius,
                      ),
                      blurRadius: AppConstants.neumorphismBlurRadius,
                    ),
                    BoxShadow(
                      color: AppColors.lightShadow,
                      offset: const Offset(
                        -AppConstants.neumorphismSpreadRadius,
                        -AppConstants.neumorphismSpreadRadius,
                      ),
                      blurRadius: AppConstants.neumorphismBlurRadius,
                    ),
                  ],
          ),
          child: child,
        ),
      ),
    );
  }
}

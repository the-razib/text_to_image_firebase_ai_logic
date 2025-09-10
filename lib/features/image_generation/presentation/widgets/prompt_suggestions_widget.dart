import 'package:firebase_ai_logic/core/constants/app_constants.dart';
import 'package:firebase_ai_logic/core/theme/app_colors.dart';
import 'package:firebase_ai_logic/shared/widgets/neumorphic_card_widget.dart';
import 'package:flutter/material.dart';

class PromptSuggestionsWidget extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const PromptSuggestionsWidget({super.key, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.accentColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Prompt Suggestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.promptExamples.map((example) {
              return _PromptChip(
                text: example,
                onTap: () => onSuggestionTap(example),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PromptChip extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _PromptChip({required this.text, required this.onTap});

  @override
  State<_PromptChip> createState() => _PromptChipState();
}

class _PromptChipState extends State<_PromptChip>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _isPressed
                ? AppColors.surfaceColor
                : AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isPressed
                  ? AppColors.primaryMuted.withValues(alpha: 0.08)
                  : AppColors.primaryMuted.withValues(alpha: 0.06),
              width: 1,
            ),
            boxShadow: _isPressed
                ? [
                    // inset-like pressed effect: simulate by flipping shadow directions
                    BoxShadow(
                      color: AppColors.darkShadow.withValues(alpha: 0.06),
                      offset: const Offset(-2, -2),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: AppColors.lightShadow.withValues(alpha: 0.95),
                      offset: const Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.darkShadow.withValues(alpha: 0.10),
                      offset: const Offset(3, 3),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: AppColors.lightShadow.withValues(alpha: 0.95),
                      offset: const Offset(-3, -3),
                      blurRadius: 8,
                    ),
                  ],
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: AppColors.textPrimary.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

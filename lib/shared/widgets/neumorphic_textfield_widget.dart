import 'package:firebase_ai_logic/core/constants/app_constants.dart';
import 'package:firebase_ai_logic/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NeumorphicTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final FocusNode? focusNode;

  const NeumorphicTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<NeumorphicTextField> createState() => _NeumorphicTextFieldState();
}

class _NeumorphicTextFieldState extends State<NeumorphicTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    // Only dispose the focus node if it was created internally
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: _isFocused
            ? [
                // Focused inner shadow
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: AppColors.lightShadow.withOpacity(0.8),
                  offset: const Offset(-1, -1),
                  blurRadius: 4,
                ),
              ]
            : [
                // Default inner shadow
                BoxShadow(
                  color: AppColors.darkShadow.withOpacity(0.1),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: AppColors.lightShadow.withOpacity(0.5),
                  offset: const Offset(-1, -1),
                  blurRadius: 3,
                ),
              ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        validator: widget.validator,
        enabled: widget.enabled,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          counterText: '' , // Hide the default counter
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
          hintStyle: const TextStyle(color: AppColors.textHint),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

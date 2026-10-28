import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rakshaa/core/constants/app_colors.dart';

class AuthInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const AuthInputField({
    super.key,
    this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.errorText,
    this.onChanged,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.errorText != null
                  ? Colors.red.shade300
                  : _isFocused
                      ? AppColors.rakshaaCoral
                      : const Color(0xFFE9EAF0),
              width: _isFocused ? 1.5 : 1.0,
            ),
            boxShadow: _isFocused && widget.errorText == null
                ? [
                    BoxShadow(
                      color: AppColors.rakshaaCoral.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.deepNavy,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Color(0xFFA0AABF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: _isFocused ? AppColors.rakshaaCoral : const Color(0xFF8A98B0),
                size: 20,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          key: ValueKey(_obscureText),
                          color: const Color(0xFF8A98B0),
                          size: 20,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 16),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

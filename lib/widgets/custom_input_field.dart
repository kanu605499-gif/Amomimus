import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  
  // Register screen specific
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Color focusedBorderColor;
  final bool isPassword;
  final TextCapitalization textCapitalization;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.focusedBorderColor = const Color(0xff6c52a3), // default from login
    this.isPassword = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _internalObscureText = true;

  @override
  Widget build(BuildContext context) {
    bool finalObscureText = widget.isPassword ? _internalObscureText : widget.obscureText;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            final words = widget.label.split(' ');
            if (words.length == 1) {
              return Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Color(0xff121212),
                ),
              );
            }
            return RichText(
              text: TextSpan(
                text: '${words.first} ',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Color(0xff6c52a3),
                ),
                children: [
                  TextSpan(
                    text: words.skip(1).join(' '),
                    style: const TextStyle(color: Color(0xff121212)),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          style: const TextStyle(color: Color(0xff121212)),
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          obscureText: finalObscureText,
          onChanged: widget.onChanged,
          autovalidateMode: widget.validator != null ? AutovalidateMode.onUserInteraction : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color(0xffdadada), fontSize: 14),
            errorText: widget.errorText,
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
            filled: true,
            fillColor: const Color(0xfff8f6fc),
            contentPadding: const EdgeInsets.all(16),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon ?? (widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _internalObscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: const Color(0xff9e9bc2),
                    ),
                    onPressed: () {
                      setState(() {
                        _internalObscureText = !_internalObscureText;
                      });
                    },
                  )
                : null),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffe1dbec)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: widget.focusedBorderColor,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

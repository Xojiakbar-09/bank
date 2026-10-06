import 'package:flutter/cupertino.dart';

class IosStyleTextField extends StatefulWidget {
  final String placeholder;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const IosStyleTextField({
    super.key,
    required this.placeholder,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  State<IosStyleTextField> createState() => _IosStyleTextFieldState();
}

class _IosStyleTextFieldState extends State<IosStyleTextField> {
  bool _isFocused = false;

  // Siz talab qilgan ranglar sistemasi
  static const Color surfaceColor = Color(0xFF15151C);
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color borderColor = Color(0xFF292933);
  static const Color placeholderColor = Color(0xFFA1A1AA);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: CupertinoTextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border.all(
              color: _isFocused ? primaryPurple : borderColor,
              width: _isFocused ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          placeholder: widget.placeholder,
          placeholderStyle: const TextStyle(
            color: placeholderColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          style: const TextStyle(
            color: CupertinoColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefix: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: widget.prefixIcon,
                )
              : null,
          suffix: widget.suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: widget.suffixIcon,
                )
              : null,
          cursorColor: primaryPurple,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final OutlineInputBorder inputBorder;
  final Color fillColor;
  final double s;

  const PasswordField({
    required this.controller,
    required this.hint,
    required this.inputBorder,
    required this.fillColor,
    required this.s,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: widget.fillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14 * widget.s,
          vertical: 12 * widget.s,
        ),
        border: widget.inputBorder,
        enabledBorder: widget.inputBorder,
        focusedBorder: widget.inputBorder.copyWith(
          borderSide: BorderSide(color: Colors.black12.withOpacity(0.25)),
        ),
        suffixIcon: IconButton(
          onPressed: () => setState(() => obscure = !obscure),
          icon: obscure == false
              ? const Icon(Icons.visibility, color: Color(0xFF6B6B6B))
              : const Icon(Icons.visibility_off, color: Color(0xFF6B6B6B)),
          selectedIcon: const Icon(Icons.visibility, color: Color(0xFF6B6B6B)),
          splashRadius: 18,
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Password required' : null,
    );
  }
}

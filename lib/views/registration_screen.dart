import 'package:bayer/costante/export.dart';
import 'package:flutter/services.dart';

class _PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const _PasswordInputField({
    required this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  State<_PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<_PasswordInputField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]')),
      ],
      decoration: InputDecoration(
        prefixIcon: const Icon(Iconsax.lock_outline),
        labelText: widget.labelText,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Iconsax.eye_slash_outline : Iconsax.eye_outline,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      validator: widget.validator,
    );
  }
}

// Usage in your build method:
// _PasswordInputField(
//   controller: passwordController,
//   labelText: 'Mot de passe',
// ),
// const SizedBox(height: 16),
// _PasswordInputField(
//   controller: confirmPasswordController,
//   labelText: 'Confirmer le mot de passe',
// ),

import 'package:flutter/material.dart';

class EmailPhoneInputField extends StatefulWidget {
  const EmailPhoneInputField({super.key});

  @override
  _EmailPhoneInputFieldState createState() => _EmailPhoneInputFieldState();
}

class _EmailPhoneInputFieldState extends State<EmailPhoneInputField> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or phone number';
    }

    // Regular expression to check if it's a valid email or phone number
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final phoneRegex = RegExp(r'^\+?[0-9]{10,}$');

    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return 'Enter a valid email or phone number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          validator: _validateInput,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
            hintText: 'Enter your email or phone number',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

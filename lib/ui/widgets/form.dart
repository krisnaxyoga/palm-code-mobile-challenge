import 'package:palmmobilechalenge/shared/theme.dart';
import 'package:flutter/material.dart';

class CustomsFormField extends StatelessWidget {
  final String title;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomsFormField({
    super.key,
    required this.title,
    this.obscureText = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search), // Add the search icon here
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}

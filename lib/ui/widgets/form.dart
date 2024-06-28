import 'package:palmmobilechalenge/shared/theme.dart';
import 'package:flutter/material.dart';

class CustomsFormField extends StatelessWidget {
  final String title;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isShowTitle;

  const CustomsFormField({
    super.key,
    required this.title,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    this.isShowTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowTitle)
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
        if (isShowTitle)
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
            hintText: !isShowTitle ? title : null,
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}

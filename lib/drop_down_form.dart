import 'package:digital_ktp/constants.dart';
import 'package:flutter/material.dart';

class DropDownForm extends StatelessWidget {
  const DropDownForm(
      {super.key,
      required this.listOf,
      required this.onChanged,
      required this.hintText});

  final List<String> listOf;
  final onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: listOf.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(
            val,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.black,
      ),
      isExpanded: true,
      isDense: true,
      decoration: kTextFieldDecoration.copyWith(hintText: hintText),
    );
  }
}

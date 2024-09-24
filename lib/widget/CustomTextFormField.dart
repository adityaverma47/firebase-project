import 'package:flutter/material.dart';

class Customtextformfield extends StatelessWidget {

  final String hintText;
  final Icon? prefixIcon, suffixIcon;
  final TextEditingController controller;

   Customtextformfield({super.key, required this.hintText, this.prefixIcon,this.suffixIcon, required this.controller,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      validator: (value) {
        if(value == null || value.isEmpty){
          return "Please enter required fields";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        )
      ),
    );
  }
}

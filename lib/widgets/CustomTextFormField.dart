import 'package:cssalonapp/theme/CustomStyle.dart';
import 'package:flutter/material.dart';

typedef SubmitCallback(String value);

class CustomTextFormField extends StatelessWidget {
  String hintText;
  FocusNode focusNode;
  TextEditingController controller;
  SubmitCallback onSubmitted;
  SubmitCallback validator;
  TextInputAction textInputAction;
  TextInputType textInputType;
  bool isPassword = false;
  String value;

  CustomTextFormField(
      {this.textInputType,
      this.textInputAction,
      this.controller,
      this.focusNode,
      this.onSubmitted,
      this.validator,
      this.hintText,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      initialValue: value,
      obscureText: isPassword,
      keyboardType: textInputType,
      validator: (value) {
        return validator(value);
      },
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      controller: controller,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15.0),
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: formOutlineBorder,
        border: formOutlineBorder,
        focusedBorder: formOutlineBorder,
      ),
    );
  }
}

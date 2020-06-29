import 'package:cssalonapp/theme/CustomStyle.dart';
import 'package:flutter/material.dart';

typedef SubmitCallback(String value);

class CustomTextFormField extends StatefulWidget {
  String hintText;
  FocusNode focusNode;
  TextEditingController controller;
  SubmitCallback onSubmitted;
  SubmitCallback validator;
  TextInputAction textInputAction;
  TextInputType textInputType;
  bool isPassword = false;
  bool enabled = true;

  CustomTextFormField(
      {this.textInputType,
      this.textInputAction,
      this.controller,
      this.focusNode,
      this.onSubmitted,
      this.validator,
      this.hintText,
      this.isPassword = false,
      this.enabled = true});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String value;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      initialValue: value,
      obscureText: widget.isPassword,
      keyboardType: widget.textInputType,
      validator: (value) {
        return widget.validator(value);
      },
      onFieldSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15.0),
        hintText: widget.hintText,
        fillColor: Colors.white,
        filled: true,
        enabled: widget.enabled,
        enabledBorder: formOutlineBorder,
        border: formOutlineBorder,
        focusedBorder: formOutlineBorder,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  double width;
  GestureTapCallback onTap;
  String name;
  Color color;
  TextStyle textStyle;

  CustomButton({
    this.color,
    this.name,
    this.width,
    this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: color,
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45.0,
        width: double.infinity,
        child: Text(
          name,
          style: textStyle,
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  double width;
  GestureTapCallback onTap;
  String name;
  Color color;
  TextStyle textStyle;
  Widget loader;

  Button({this.color, this.name, this.width, this.onTap, this.textStyle, this.loader});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: color,
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45.0,
        width: double.infinity,
        child: loader ??
            Text(
              name,
              style: textStyle,
            ),
      ),
    );
  }
}

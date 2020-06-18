import 'package:flutter/material.dart';

class BackGroundImage extends StatelessWidget{
  String image;
  BackGroundImage({this.image});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(image,fit: BoxFit.cover,colorBlendMode: BlendMode.color,color: Colors.black,),
    );
  }
}
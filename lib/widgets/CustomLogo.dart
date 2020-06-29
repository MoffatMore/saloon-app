import 'package:cssalonapp/theme/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ))),
          Positioned(
            bottom: 20,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Instyle Saloon",
                textAlign: TextAlign.center,
                style: TextStyle(color: primaryColor, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

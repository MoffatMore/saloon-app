import 'package:cssalonapp/pages/Booking.dart';
import 'package:cssalonapp/theme/Color.dart';
import 'package:flutter/material.dart';

class HomeListView extends StatelessWidget {
  String name;
  String image;

  HomeListView({this.name, this.image});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Booking(
                      title: name,
                    )));
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(image),
              ),
            ),
            height: 150.0,
          ),
          Container(
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: primaryColor.withOpacity(0.8),
                    ),
                    height: 5,
                    width: 80.0,
                  )
                ],
              ))
        ],
      ),
    );
  }
}

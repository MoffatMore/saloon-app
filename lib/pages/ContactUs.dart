import 'package:cssalonapp/theme/Color.dart';
import 'package:cssalonapp/widgets/BackGroundImage.dart';
import 'package:cssalonapp/widgets/CustomButton.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Text("Contact Us"),
          ),
        ),
        body: Stack(
          children: <Widget>[
            BackGroundImage(
              image: "assets/images/image1.jpg",
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(15.0),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Connect with Us",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.email,
                              color: primaryColor,
                            ),
                            title: Text("Mail Us"),
                            subtitle: Text(
                              "hairsaloon@gamil.com",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.call,
                              color: primaryColor,
                            ),
                            title: Text("Call Us"),
                            subtitle: Text(
                              "+91 8735942926",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(15.0),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Or Write Us",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: CustomButton(
                              color: primaryColor,
                              width: double.infinity,
                              onTap: () {},
                              name: "Submit",
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(15.0),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Our Location",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: primaryColor,
                            ),
                            title: Text("Lorem ipsum, or lipsum as it is sometimes known"),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

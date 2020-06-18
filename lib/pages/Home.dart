import 'package:cssalonapp/Model/HomeListData.dart';
import 'package:cssalonapp/pages/AboutUs.dart';
import 'package:cssalonapp/pages/Blogs.dart';
import 'package:cssalonapp/pages/ContactUs.dart';
import 'package:cssalonapp/pages/HomeListView.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/widgets/BackGroundImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  AuthProvider _provider;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _provider = Provider.of<AuthProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // here the desired height
        child: AppBar(
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                _provider.signOut();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.power_settings_new),
              ),
            )
          ],
          title: Text(
            "Bonno\'s Beauty & Parlor",
            style: TextStyle(fontSize: 25.0),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[BackGroundImage(image: "assets/images/image1.jpg"), HomeSection()],
      ),
    );
  }
}

class HomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: topSection(context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            "Make an Appointment",
            style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: bottomSection(),
        )
      ],
    );
  }

  Widget topSection(BuildContext context) {
    return Container(
      height: 60.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Blogs()));
              }
              if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
              }
              if (index == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUs()));
              }
            },
            child: Container(
              width: 200.0,
              child: Card(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(homeListHeaderSection[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                ),
              ),
            ),
          );
        },
        itemCount: homeListHeaderSection.length,
      ),
    );
  }

  Widget bottomSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ListView.separated(
        separatorBuilder: (contex, index) {
          return SizedBox(
            height: 30.0,
          );
        },
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: HomeListView(
              image: homeListViewSection[index]['image'],
              name: homeListViewSection[index]['name'],
            ),
          );
        },
        itemCount: homeListViewSection.length,
      ),
    );
  }
}

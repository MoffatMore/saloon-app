import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cssalonapp/pages/BlogDetails.dart';
import 'package:cssalonapp/pages/Booking.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchStyle extends SearchDelegate {
  Stream styles;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  void showResults(BuildContext context) {
    // TODO: implement showResults
    super.showResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return CustomContainer(suggestions: null, query: query);
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key key,
    @required this.suggestions,
    this.query,
  }) : super(key: key);

  final List suggestions;
  final String query;

  @override
  Widget build(BuildContext context) {
    return styleWidget(context, suggestions, query: query);
  }

  Widget styleWidget(BuildContext context, List styles, {String query}) {
    return StreamBuilder<QuerySnapshot>(
        stream: Bookings.getHairStylist(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          List<DocumentSnapshot> styles = snapshot.data.documents;
          styles = styles
              .where((element) => element.data['description']
                  ?.toLowerCase()
                  ?.contains(query.toLowerCase()))
              .toList();
          log('styles ${styles.toString()}');
          return Container(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          height: 240.0,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Hero(
                                tag: index,
                                child: Container(
                                  margin: EdgeInsets.all(0.0),
                                  width: 130.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Image.asset(
                                      "assets/images/user.jpg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "Name: " + "${styles[index]['username']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Contact: " + "${styles[index]['phone']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Job Description",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      styles[index]['description'] ??
                                          'No job description',
                                      maxLines: 5,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Location: " +
                                          "${styles[index]['location'] ?? 'No Lcation'}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      styles[index]['working_hours'] ??
                                          'No working hours',
                                      maxLines: 5,
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Booking(
                                                              title: "Book "
                                                                  "Stylist",
                                                              stylist: styles[
                                                                      index][
                                                                  'username'])));
                                            },
                                            child: Text(
                                              "Book",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          height: 30,
                                          width: 70,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 100,
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlogDetails(
                                                    index: index,
                                                    uid: styles[index]
                                                        .documentID,
                                                    image:
                                                        "assets/images/user.jpg",
                                                    blog: styles[index]
                                                        ['description'],
                                                    title: styles[index]
                                                        ['username'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Hair Styles",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          height: 30,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10.0,
                  );
                },
                itemCount: styles.length),
          );
        });
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cssalonapp/pages/BlogDetails.dart';
import 'package:cssalonapp/pages/Booking.dart';
import 'package:cssalonapp/pages/five_rating.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewStylist extends StatelessWidget {
  String title;
  ViewStylist({this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Text("Our Hair Stylist"),
          ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: Bookings.getHairCareStyList(title),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Container(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
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
                              height: 220.0,
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(
                                          "Name: " +
                                              "${snapshot.data.documents[index]['username']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          "Contact: " +
                                              "${snapshot.data.documents[index]['phone']}",
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
                                          snapshot.data.documents[index]
                                                  ['description'] ??
                                              'No job description',
                                          maxLines: 5,
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),

                                        //dispay ration of a particular user, th
                                        FutureBuilder<QuerySnapshot>(
                                          future: Bookings.getRatings(snapshot
                                              .data
                                              .documents[index]
                                              .documentID),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            double ratings = 0;
                                            if (snapshot.hasData) {
                                              var docs =
                                                  snapshot.data.documents;
                                              log(docs.toString());
                                              docs.forEach((doc) {
                                                log(doc['rating'].toString());
                                                ratings += doc['rating'];
                                              });
                                              if (docs.length > 0) {
                                                ratings = ratings / docs.length;
                                                log(ratings.toStringAsFixed(1));
                                              }
                                            }
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: snapshot.hasData
                                                  ? Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: CustomFiveStarRating(
                                                              allowHalfRating:
                                                                  true,
                                                              intialrating:
                                                                  ratings,
                                                              size: 20.0,
                                                              filledIconData:
                                                                  Icons.star,
                                                              halfFilledIconData:
                                                                  Icons
                                                                      .star_half,
                                                              color:
                                                                  Colors.amber,
                                                              borderColor:
                                                                  Colors.black,
                                                              textColor:
                                                                  Colors.black,
                                                              spacing: 0.0),
                                                        )
                                                      ],
                                                    )
                                                  : Row(
                                                      children: <Widget>[
                                                        Icon(Icons.grade,
                                                            color: Colors.grey),
                                                        Icon(Icons.grade,
                                                            color: Colors.grey),
                                                        Icon(Icons.grade,
                                                            color: Colors.grey),
                                                        Icon(Icons.grade,
                                                            color: Colors.grey),
                                                        Icon(Icons.grade,
                                                            color: Colors.grey),
                                                      ],
                                                    ),
                                            );
                                          },
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
                                                                  stylist: snapshot
                                                                          .data
                                                                          .documents[index]
                                                                      [
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
                                                      BorderRadius.circular(
                                                          30)),
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
                                                        uid: snapshot
                                                            .data
                                                            .documents[index]
                                                            .documentID,
                                                        image:
                                                            "assets/images/user.jpg",
                                                        blog: blogDetails,
                                                        title: snapshot
                                                                .data.documents[
                                                            index]['username'],
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
                                                      BorderRadius.circular(
                                                          30)),
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
                    itemCount: snapshot.data.documents.length),
              );
            }));
  }
}

var blogDetails =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled ";

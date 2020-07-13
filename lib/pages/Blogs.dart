import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cssalonapp/pages/BlogDetails.dart';
import 'package:cssalonapp/pages/Booking.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Blogs extends StatelessWidget {
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
      body: Stack(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: Bookings.getHairStylist(),
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
                                height: 170.0,
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
                                            height: 5.0,
                                          ),
                                          Text(
                                            snapshot.data.documents[index]
                                                    ['location'] ??
                                                'No Location provided',
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
                                                                    title:
                                                                        "Book "
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
                                                          blog: snapshot.data
                                                                      .documents[
                                                                  index]
                                                              ['description'],
                                                          title: snapshot.data
                                                                  .documents[
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
              })
        ],
      ),
    );
  }
}

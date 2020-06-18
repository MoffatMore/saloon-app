import 'package:cssalonapp/pages/BlogDetails.dart';
import 'package:cssalonapp/widgets/BackGroundImage.dart';
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
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          BackGroundImage(image: "assets/images/image1.jpg"),
          Container(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetails(
                            index: index,
                            image: "assets/images/image1.jpg",
                            blog: blogDetails,
                            title: "Job Description",
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          height: 150.0,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Hero(
                                tag: index,
                                child: Container(
                                  margin: EdgeInsets.all(0.0),
                                  width: 150.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Image.asset(
                                      "assets/images/image1.jpg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "Job Description",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      blogDetails,
                                      maxLines: 5,
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
                itemCount: 10),
          )
        ],
      ),
    );
  }
}

var blogDetails =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled ";

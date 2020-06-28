import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class UploadPictures extends StatefulWidget {
  @override
  _UploadPicturesState createState() => _UploadPicturesState();
}

class _UploadPicturesState extends State<UploadPictures> {
  CarouselController buttonCarouselController = CarouselController();
  Future<File> imageFile;
  List<Asset> images = List<Asset>();
  String _error;
  AuthProvider _authProvider;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> list = List<String>();
    int _current = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload your styles"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _authProvider.getPics(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.documents.length > 0) {
                      snapshot.data.documents.forEach((document) {
                        list.add(document['picture']);
                      });
                    }
                  }
                  return CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: list
                        .map((item) => Container(
                              child: Image.network(item),
                            ))
                        .toList(),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: list.map((url) {
                int index = list.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: buildGridView(),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Visibility(
                      visible: images != null && images.length > 0,
                      child: Container(
                        child: FlatButton(
                          child: Text("Clear pictures", style: TextStyle(color: Colors.white)),
                          onPressed: unLoadAssets,
                        ),
                        margin: EdgeInsets.only(bottom: 140),
                        decoration: BoxDecoration(
                            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                      )),
                  Visibility(
                      visible: images != null && images.length > 0,
                      child: Container(
                        child: FlatButton(
                          child: isLoading
                              ? Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : Text("Upload pictures", style: TextStyle(color: Colors.white)),
                          onPressed: upload,
                        ),
                        margin: EdgeInsets.only(bottom: 140),
                        decoration: BoxDecoration(
                            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      log(error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  void unLoadAssets() {
    setState(() {
      images = null;
    });
  }

  Future<void> upload() async {
    setState(() {
      isLoading = true;
    });
    await _authProvider.uploadStyles(images);
    setState(() {
      isLoading = false;
      images = null;
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  //Open gallery
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }
}

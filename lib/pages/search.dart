import 'dart:developer';

import 'package:cssalonapp/pages/HomeListView.dart';
import 'package:flutter/material.dart';

class SearchStyle extends SearchDelegate {
  final List styles;
  final List recentStyles;

  SearchStyle({@required this.styles, this.recentStyles});
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
    final suggestions = query.isEmpty
        ? styles
        : styles.where((q) => q['name'] == query).toList();
    log(suggestions.toString());
    return CustomContainer(suggestions: suggestions, query: query);
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
              image: styles[index]['image'],
              name: styles[index]['name'],
            ),
          );
        },
        itemCount: styles.length,
      ),
    );
  }
}

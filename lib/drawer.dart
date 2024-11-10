import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nyfw_24_2/pages/view_shows_page.dart';
import 'pages/reviews_page.dart';
import 'pages/search_page.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/drawerHeaderBg.png'),
                  fit: BoxFit.cover),
            ),
            child: null,
          ),
          ListTile(
            title: const Text("Search Show"),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const SearchPage()));
            },
          ),
          ListTile(
            title: const Text("View Shows"),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const ViewShowsPage()));
            },
          ),
          ListTile(
            title: const Text("Review App"),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const ReviewsPage()));
            },
          )
        ],
      ));
}

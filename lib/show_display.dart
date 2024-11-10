import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/show_page.dart';

InkWell showDisplay(
    {required Map<String, dynamic> show, required BuildContext context}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ShowPage(showData: show),
        ),
      );
    },
    child: Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image(image: AssetImage("assets/images/${show["name"]}.jpg")),
          Image.network(
            show["imageURL"],
            // loadingBuilder: (context, child, loadingProgress) =>
            //     const CircularProgressIndicator(),
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/${show["name"]}.jpg');
            },
          ),
          Text(
            show['name'],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    ),
  );
}

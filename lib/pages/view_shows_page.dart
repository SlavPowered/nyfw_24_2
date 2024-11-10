import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyfw_24_2/show_display.dart';

class ViewShowsPage extends StatefulWidget {
  const ViewShowsPage({super.key});

  @override
  State<ViewShowsPage> createState() => _ViewShowsPageState();
}

class _ViewShowsPageState extends State<ViewShowsPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // ignore: unused_field
  String _errMsg = '';
  // bool _isVisible = false;
  // final _nameController = TextEditingController();
  // final _descriptionController = TextEditingController();
  // final _urlController = TextEditingController();

  // final _seasons = ["Fall Winter", "Spring Summer"];

  Future<List<Map<String, dynamic>>> _fetchShows() async {
    try {
      final value = await db.collection("shows").get();
      return value.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      setState(() {
        _errMsg = "Couldn't Display Shows";
      });
      return [];
    }
  }

  FutureBuilder<List<Map<String, dynamic>>> _listShows() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchShows(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data!.map((show) {
              return showDisplay(show: show, context: context);
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shows")),
      body: Column(
        children: [
          // Visibility(
          //     visible: _isVisible,
          //     child: Padding(
          //       padding: const EdgeInsets.all(10.0),
          //       child: Card(
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Column(
          //             children: [
          //               TextField(
          //                 controller: _nameController,
          //                 decoration: const InputDecoration(hintText: "Name"),
          //               ),
          //               DropdownMenu(
          //                   initialSelection: "Fall Winter",
          //                   dropdownMenuEntries: _seasons
          //                       .map((elem) =>
          //                           DropdownMenuEntry(value: elem, label: elem))
          //                       .toList()),
          //               TextField(
          //                 controller: _descriptionController,
          //                 maxLines: 15,
          //                 decoration: const InputDecoration(
          //                     hintText: "Description",
          //                     border: OutlineInputBorder()),
          //               ),
          //               TextField(
          //                 controller: _urlController,
          //                 decoration: const InputDecoration(
          //                   hintText: "Image URL",
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     )),
          Expanded(child: _listShows()),
        ],
      ),
      backgroundColor: Colors.black,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => setState(() => _isVisible = true),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

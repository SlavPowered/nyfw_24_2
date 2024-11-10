import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyfw_24_2/pages/show_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchTextController = TextEditingController();
  String _searchTerm = "";
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchTextController,
              decoration: const InputDecoration(
                hintText: "Search Shows...",
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  _searchTerm = text;
                });
              },
              onSubmitted: (text) => _performSearch(),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(child: Text("No results found."))
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final showData = _searchResults[index].data();
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                          elevation: 4.0, // Adjust elevation as needed
                          shadowColor: Colors.grey
                              .withOpacity(0.5), // Customize shadow color
                          borderRadius: BorderRadius.circular(5.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  showData["name"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(" "),
                                Text(showData["type"]),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      ShowPage(showData: showData),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _capitalizeWord(String text) {
    return text
        .split(" ")
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(" ");
  }

  void _performSearch() async {
    if (_searchTerm.isEmpty) return;

    final capitalizedSearchTerm = _capitalizeWord(_searchTerm);

    final showsCollection = FirebaseFirestore.instance.collection('shows');
    final querySnapshot = await showsCollection
        .where('name', isGreaterThanOrEqualTo: capitalizedSearchTerm)
        .where('name', isLessThanOrEqualTo: capitalizedSearchTerm + 'z')
        .get();

    setState(() {
      _searchResults = querySnapshot.docs;
    });
  }
}

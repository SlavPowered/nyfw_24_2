import 'package:flutter/material.dart';

class ShowPage extends StatefulWidget {
  final Map<String, dynamic> showData;

  const ShowPage({super.key, required this.showData});

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  String _name = '';
  String _description = '';
  String _type = '';
  List<String> _seasons = [];
  String _url = '';

  @override
  void initState() {
    super.initState();
    _name = widget.showData["name"];
    _description = widget.showData["description"];
    _type = widget.showData["type"];
    _seasons = widget.showData["seasons"]?.cast<String>() ?? [];
    _url = widget.showData["imageURL"];
  }

  Column _showDescription() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            _url,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                  'assets/images/$_name.jpg'); // Replace with your asset path
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Type: $_type",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Seasons: ${_seasons.join(" ")}",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Description: $_description",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
      ),
      body: SingleChildScrollView(child: _showDescription()),
      backgroundColor: Colors.black,
    );
  }
}

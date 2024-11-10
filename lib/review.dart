import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Review extends StatefulWidget {
  final Map<String, dynamic> reviewData;
  final String? user;
  final String reviewID;

  const Review(
      {super.key,
      required this.reviewData,
      required this.user,
      required this.reviewID});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  bool _readOnly = true;
  TextEditingController? _reviewController;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    _reviewController =
        TextEditingController(text: widget.reviewData["review"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                widget.reviewData["user"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Text(" "),
            Container(
              alignment: Alignment.topRight,
              child: Text(_formatDate(widget.reviewData["date"])),
            )
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _reviewController!,
                  decoration: InputDecoration(
                      border: _readOnly
                          ? InputBorder.none
                          : const OutlineInputBorder(borderSide: BorderSide())),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  readOnly: _readOnly,
                  onSubmitted: (value) async {
                    setState(() => _readOnly = true);
                    await db
                        .collection("Reviews")
                        .doc(widget.reviewID)
                        .update({"review": value, "date": Timestamp.now()});
                  },
                ),
              ),
            ),
            (widget.reviewData["user"] == widget.user)
                ? IconButton(
                    onPressed: () => setState(() => _readOnly = false),
                    icon: const Icon(Icons.edit),
                    color: Colors.black,
                  )
                : Container()
          ],
        ),
      ],
    );
  }

  String _formatDate(Timestamp date) {
    return DateFormat("dd/MM/yyyy").format(date.toDate());
  }
}

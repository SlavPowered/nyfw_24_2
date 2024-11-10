import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyfw_24_2/auth.dart';
import 'package:nyfw_24_2/pages/login_page.dart';
import 'package:nyfw_24_2/review.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _reviews = [];
  final _addCommentController = TextEditingController();
  final TextEditingController editingController = TextEditingController();
  final auth = Auth();
  String? _user;
  String _newReview = '';

  @override
  void initState() {
    super.initState();
    _getReviews();
    if (auth.currentUser != null) _user = auth.currentUser!.email!;
  }

  Future<void> _addReview() async {
    if (_newReview.isEmpty) return;

    final review = <String, dynamic>{
      "user": _user,
      "review": _newReview,
      "date": Timestamp.now()
    };

    FirebaseFirestore.instance.collection("Reviews").add(review);
    _addCommentController.clear();
  }

  void _getReviews() async {
    final reviewsCollection = FirebaseFirestore.instance.collection('Reviews');
    final querySnapshot =
        await reviewsCollection.orderBy("date", descending: true).get();

    setState(() {
      _reviews = querySnapshot.docs.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reviews")),
      body: (auth.currentUser != null)
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _addCommentController,
                    decoration: const InputDecoration(
                      hintText: "Add Review...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _newReview = text;
                      });
                    },
                    onSubmitted: (text) async {
                      await _addReview();
                      _getReviews();
                    },
                  ),
                ),
                Expanded(
                  child: _reviews.isEmpty
                      ? const Center(child: Text("No reviews found."))
                      : ListView.builder(
                          itemCount: _reviews.length,
                          itemBuilder: (context, index) {
                            final reviewData = _reviews[index].data();
                            final reviewID = _reviews[index].id;
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10.0),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                title: Review(
                                    reviewData: reviewData,
                                    user: _user,
                                    reviewID: reviewID),
                              ),
                            );
                          },
                        ),
                ),
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Log In",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
    );
  }
}

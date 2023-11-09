import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class PostScreenDisplay extends StatefulWidget {
  const PostScreenDisplay({super.key});

  @override
  State<PostScreenDisplay> createState() => _PostScreenDisplayState();
}

class _PostScreenDisplayState extends State<PostScreenDisplay> {
  late List<PostCard> events = List.empty(growable: true);
  late Stream<QuerySnapshot<Map<String, dynamic>>> futurePosts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurePosts = FirebaseFirestore.instance
          .collection('posts')
          .get()
          .asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: StreamBuilder(
                      stream: futurePosts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                            children: snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            return PostCard(
                                post: Post.fromSnap(document));
                          },
                        ).toList());
                      },
                    ),
    );
  }
}

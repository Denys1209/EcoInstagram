import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/widgets/text_column.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.grey),
          color: Colors.black,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: widget.post.userId,
                        ),
                      ),
                    ),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          widget.post.profImage,
                        ),
                        radius: 20,
                      ),
                    ),
                    ),
                Text(widget.post.userName),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                      "${widget.post.postDate.toLocal().toString().split(":")[0]}:${widget.post.postDate.toLocal().toString().split(":")[1]}"),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextColumn(text: widget.post.message),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        snap: widget.post.toJson(),
                        stream: FirebaseFirestore.instance
                            .collection(FirestoreMethods().POSTS)
                            .doc(widget.post.id)
                            .collection(FirestoreMethods().COMMENTS)
                            .orderBy(
                              'datePublished',
                              descending: true,
                            )
                            .snapshots(),
                        onTap: (String text) async {
                          await FirestoreMethods().postCommentOnEvent(
                            widget.post.id,
                            text,
                            user.uid,
                            user.username,
                            user.photoUrl,
                          );
                        },
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.comment_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

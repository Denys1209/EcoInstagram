import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/event.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/screens/user_on_event_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/shape_button.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:instagram_clone/widgets/photos_display_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  Map<String, dynamic> snap;
  EventScreen({super.key, required this.snap});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  bool? _isSubscribed;
  late User _user;
  late Event _event;
  final List<Uint8List> _photos = List.empty(growable: true);

  Future<Uint8List> _downloadImageAsBytes(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image.');
    }
  }

  _photosFromUrls() async {
    for (var url in widget.snap['photos']) {
      Uint8List photo = await _downloadImageAsBytes(url);
      setState(() {
        _photos.add(photo);
      });
    }
  }

  void _getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection(FirestoreMethods().EVENTS)
          .doc(widget.snap['id'])
          .collection(FirestoreMethods().COMMENTS)
          .get();
      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _photosFromUrls();
    _getComments();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserProvider>(context).getUser;
    if (_isSubscribed == null) {
      setState(() {
        _isSubscribed = widget.snap['subscribers'].contains(_user.uid);
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          widget.snap['name'],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: mobileBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.snap["profImage"]),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap["organizationsName"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: ['Delete']
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      FirestoreMethods().deletePollutionPoint(
                                          widget.snap['id']);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  FirestoreMethods().likePost(widget.snap['id'].toString(),
                      _user.uid, widget.snap['likes']);
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PhotosListDisplay(
                    canAddPhotos: false,
                    photos: _photos,
                    selectFormGallery: true,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.green,
                        size: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(_user.uid),
                  smallLike: true,
                  child: IconButton(
                    icon: widget.snap['likes'].contains(_user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                    onPressed: () => FirestoreMethods().likePost(
                      widget.snap['id'].toString(),
                      _user.uid,
                      widget.snap['likes'],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        snap: widget.snap,
                        stream: FirebaseFirestore.instance
                            .collection(FirestoreMethods().EVENTS)
                            .doc(widget.snap['id'])
                            .collection(FirestoreMethods().COMMENTS)
                            .orderBy(
                              'datePublished',
                              descending: true,
                            )
                            .snapshots(),
                        onTap: (String text) async {
                          await FirestoreMethods().postCommentOnEvent(
                            widget.snap['id'],
                            text,
                            _user.uid,
                            _user.username,
                            _user.photoUrl,
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
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserOnEventScreen(
                          usersIds: widget.snap['subscribers'],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.man,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () {
                        setState(() {
                          isLikeAnimating = true;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['organizationsName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "  ${widget.snap['description']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all $commentLen comments',
                        style: const TextStyle(
                            fontSize: 16, color: secondaryColor),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "start date:${DateFormat('yyyy-MM-dd – kk:mm').format((widget.snap['startDate'] as Timestamp).toDate())}",
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "end date:${DateFormat('yyyy-MM-dd – kk:mm').format((widget.snap['endDate'] as Timestamp).toDate())}",
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ],
              ),
            ),
            ShapeButton(
              backgroundColor:
                  _isSubscribed! ? mobileBackgroundColor : Colors.blue,
              borderColor: primaryColor,
              function: () async {
                setState(() {
                  _isSubscribed = !_isSubscribed!;
                  print(_isSubscribed);
                });
                await FirestoreMethods().subscribeOnAnEvent(
                    widget.snap['id'], _user.uid, widget.snap['subscribers']);
              },
              text: _isSubscribed! ? "Unsubscribed" : "subscribed",
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

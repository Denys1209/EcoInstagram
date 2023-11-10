import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/events_display_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/alert_dialog_yes_no.dart';
import 'package:instagram_clone/widgets/shape_button.dart';
import 'package:instagram_clone/widgets/wall_with_medals.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, dynamic> userData;
  int howManyPollutionReports = 0;
  int followingCleanEvents = 0;
  int followingEvents = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('pollutionPoints')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        howManyPollutionReports =
            userSnap.data()!['howManyPollutionPointsWereCreted'];
        userData = userSnap.data()!;
        followingCleanEvents = userSnap.data()!['followingCleanEvents'].length;
        followingEvents = userSnap.data()!['followingEvents'].length;
        followers = userSnap.data()!['followers'].length;
        following = userSnap.data()!['following'].length;
        isFollowing = userSnap
            .data()!['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userData["username"],
                    ),
                    Row(
                      children: [
                        widget.uid == user.uid
                            ? IconButton(
                                iconSize: 24,
                                icon: const Icon(
                                  Icons.logout,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlrertDialogYesNo(
                                        onNoFunction: null,
                                        onYesFunction: () {
                                          AuthMethods().signOut();
                                        },
                                        question:
                                            "Are you sure, that you want to sign out",
                                        textOnNo: "No",
                                        textOnYes: "Yes",
                                        title: "sign out",
                                      );
                                    },
                                  );
                                },
                              )
                            : Container(),
                      ],
                    )
                  ]),
              centerTitle: false,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(howManyPollutionReports,
                                        "reports", null),
                                    buildStatColumn(
                                      followingCleanEvents,
                                      "events",
                                      () => {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EventsDisplayScreeen(
                                              userData: userData,
                                            ),
                                          ),
                                        ),
                                      },
                                    ),
                                    buildStatColumn(
                                        followingEvents,
                                        "clean events",
                                        () => {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EventsDisplayScreeen(
                                                          userData: userData,
                                                        )),
                                              )
                                            }),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      buildStatColumn(
                                        followers,
                                        "followers",
                                        () => {
                                         
                                        },
                                      ),
                                      buildStatColumn(
                                          following,
                                          "following",
                                          () => {
                                               
                                              }),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? ShapeButton(
                                            text: 'Edit Profile',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () {},
                                          )
                                        : isFollowing
                                            ? ShapeButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () {
                                                  FirestoreMethods()
                                                      .subscribeOnUser(user.uid,
                                                          userData['uid']);
                                                },
                                              )
                                            : ShapeButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () {
                                                  FirestoreMethods()
                                                      .subscribeOnUser(user.uid,
                                                          userData['uid']);
                                                },
                                              )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                WallWithMedals(
                  user: userData,
                ),
              ],
            ),
          );
  }

  InkWell buildStatColumn(int num, String label, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            num.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

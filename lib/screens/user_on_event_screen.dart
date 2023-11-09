import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class UserOnEventScreen extends StatefulWidget {
  final List usersIds;
  const UserOnEventScreen({
    super.key,
    required this.usersIds,
  });

  @override
  State<UserOnEventScreen> createState() => _UserOnEventScreenState();
}

class _UserOnEventScreenState extends State<UserOnEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('uid', whereIn: widget.usersIds)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: snapshot.data!.docs[index]['uid'],
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['photoUrl'],
                      ),
                    ),
                    title: Text(
                      snapshot.data!.docs[index]['username'],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}

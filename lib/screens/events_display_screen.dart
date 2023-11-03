import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/event_card.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;

class EventsDisplayScreeen extends StatefulWidget {
  const EventsDisplayScreeen({super.key});

  @override
  State<EventsDisplayScreeen> createState() => _EventsDisplayScreeenState();
}

class _EventsDisplayScreeenState extends State<EventsDisplayScreeen> {
  late model.User user;
  late List<EventCard> events = new List.empty(growable: true);
  late List<EventCard> cleanEvents = new List.empty(growable: true);
  List<String> _eventsTypes = List<String>.from(["Clean events", "Events"]);
  String _chooseType = "Clean events";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<UserProvider>(context).getUser;
    });
    var futureEvents = FirebaseFirestore.instance
        .collection('events')
        .where(FieldPath.documentId, whereIn: user.followingEvents)
        .get()
        .asStream();
    var futureCleanEvents = FirebaseFirestore.instance
        .collection('cleanEvents')
        .where(FieldPath.documentId, whereIn: user.followingCleanEvents)
        .get()
        .asStream();
    return Scaffold(
        appBar: AppBar(
          title: DropdownButton<String>(
            value: _chooseType,
            icon: const Icon(
              Icons.arrow_downward,
              color: blueColor,
            ),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: blueColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _chooseType = newValue!;
              });
            },
            items: _eventsTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: blueColor),
                ),
              );
            }).toList(),
          ),
          automaticallyImplyLeading: false,
        ),
        body: _chooseType == "Events"
            ? (!user.followingEvents.isEmpty
                ? StreamBuilder(
                    stream: futureEvents,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document)
                        {
                          return new EventCard(snap: document.data() as Map<String, dynamic>);
                        },
                        ).toList()
                      );
                    },
                  )
                : const Center(
                    child: Text("No events to display"),
                  ))
            : (!user.followingCleanEvents.isEmpty
                ? StreamBuilder(
                    stream: futureCleanEvents,
                     builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document)
                        {
                          return new EventCard(snap: document.data() as Map<String, dynamic>);
                        },
                        ).toList()
                      );
                    },
                  )
                : const Center(
                    child: Text("No events to display"),
                  )));
  }
}

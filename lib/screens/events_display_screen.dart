import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/event_card.dart';

class EventsDisplayScreeen extends StatefulWidget {
  Map<String, dynamic> userData;
  String choosenType;
  EventsDisplayScreeen(
      {super.key, required this.userData, required this.choosenType});

  @override
  State<EventsDisplayScreeen> createState() => _EventsDisplayScreeenState();
}

class _EventsDisplayScreeenState extends State<EventsDisplayScreeen> {
  late List<EventCard> events = List.empty(growable: true);
  late List<EventCard> cleanEvents = List.empty(growable: true);
  late Stream<QuerySnapshot<Map<String, dynamic>>> futureEvents;
  late Stream<QuerySnapshot<Map<String, dynamic>>> futureCleanEvents;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if ((widget.userData['followingEvents'] as List).isNotEmpty) {
      futureEvents = FirebaseFirestore.instance
          .collection('events')
          .where(FieldPath.documentId,
              whereIn: widget.userData['followingEvents'])
          .get()
          .asStream();
    }
    if ((widget.userData['followingCleanEvents'] as List).isNotEmpty) {
      futureCleanEvents = FirebaseFirestore.instance
          .collection('cleanEvents')
          .where(FieldPath.documentId,
              whereIn: widget.userData['followingCleanEvents'])
          .get()
          .asStream();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("${widget.choosenType}"), centerTitle: true),
        body: !isLoading
            ? SingleChildScrollView(
                child: widget.choosenType == "Events"
                    ? ((widget.userData['followingEvents'] as List).isNotEmpty
                        ? StreamBuilder(
                            stream: futureEvents,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView(
                                  shrinkWrap: true,
                                  children: snapshot.data!.docs.map(
                                    (DocumentSnapshot document) {
                                      return EventCard(
                                          snap: document.data()
                                              as Map<String, dynamic>);
                                    },
                                  ).toList());
                            },
                          )
                        : const Center(
                            child: Text("No events to display"),
                          ))
                    : ((widget.userData['followingCleanEvents'] as List)
                            .isNotEmpty
                        ? StreamBuilder(
                            stream: futureCleanEvents,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView(
                                  shrinkWrap: true,
                                  children: snapshot.data!.docs.map(
                                    (DocumentSnapshot document) {
                                      return EventCard(
                                          snap: document.data()
                                              as Map<String, dynamic>);
                                    },
                                  ).toList());
                            },
                          )
                        : const Center(
                            child: Text("No events to display"),
                          )),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/event_card.dart';

class EventsDisplayScreeen extends StatefulWidget {
  Map<String, dynamic> userData;
  EventsDisplayScreeen({super.key, required this.userData});

  @override
  State<EventsDisplayScreeen> createState() => _EventsDisplayScreeenState();
}

class _EventsDisplayScreeenState extends State<EventsDisplayScreeen> {
  late List<EventCard> events = List.empty(growable: true);
  late List<EventCard> cleanEvents = List.empty(growable: true);
  late Stream<QuerySnapshot<Map<String, dynamic>>> futureEvents;
  late Stream<QuerySnapshot<Map<String, dynamic>>> futureCleanEvents;
  final List<String> _eventsTypes = List<String>.from(["Clean events", "Events"]);
  String _chooseType = "Clean events";

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
  }

  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(color: blueColor),
                ),
              );
            }).toList(),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: _chooseType == "Events"
              ? ((widget.userData['followingEvents'] as List).isNotEmpty
                  ? StreamBuilder(
                      stream: futureEvents,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                            children: snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            return EventCard(
                                snap: document.data() as Map<String, dynamic>);
                          },
                        ).toList());
                      },
                    )
                  : const Center(
                      child: Text("No events to display"),
                    ))
              : ((widget.userData['followingCleanEvents'] as List).isNotEmpty
                  ? StreamBuilder(
                      stream: futureCleanEvents,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                            children: snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            return EventCard(
                                snap: document.data() as Map<String, dynamic>);
                          },
                        ).toList());
                      },
                    )
                  : const Center(
                      child: Text("No events to display"),
                    )),
        ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/clean_event_screen.dart';
import 'package:instagram_clone/screens/event_screeen.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const EventCard({super.key, required this.snap});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        if (widget.snap["endDate"] != null)
          {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventScreen(snap: widget.snap),
              ),
            )
          }
        else
          {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CleanEventScreen(snap: widget.snap),
              ),
            )
          }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70, width: 0.1),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'],
                    ),
                    radius: 20,
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.snap['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${(widget.snap['startDate'] as Timestamp).toDate().difference(DateTime.now()).toString().split(":")[0]}, start on ${DateFormat('yyyy-MM-dd – kk:mm').format((widget.snap['startDate'] as Timestamp).toDate()).toString()}",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/event_screeen.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  EventCard({super.key, required this.snap});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventScreen(snap: widget.snap),
              ),
            ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                widget.snap['profImage'],
              ),
              radius: 20,
            ),
            Column(
              children: [
                Text(
                  widget.snap['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${DateTime.now().difference((widget.snap['endDate'] as Timestamp).toDate())}, start on ${DateFormat('yyyy-MM-dd – kk:mm').format((widget.snap['endDate'] as Timestamp).toDate()).toString()}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

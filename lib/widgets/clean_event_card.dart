



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CleanEventCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const CleanEventCard({super.key, required this.snap});

  @override
  State<CleanEventCard> createState() => _CleanEventCardState();
}

class _CleanEventCardState extends State<CleanEventCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CleanEventCard(snap: widget.snap),
              ),
            ),
      child: SizedBox(
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
                  style: const TextStyle(
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
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/event_screeen.dart';

class EventMark extends StatefulWidget {
  final Map<String, dynamic> snap;
  const EventMark({super.key, required this.snap});

  @override
  State<EventMark> createState() => _EventMarkState();
}

class _EventMarkState extends State<EventMark> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventScreen(snap: widget.snap),
              ),
            ),
        child: Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 30,
        ));
  }
}

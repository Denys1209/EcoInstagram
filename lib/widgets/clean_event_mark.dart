import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/screens/clean_event_screen.dart';

class CleanEventMark extends StatefulWidget {
  final Map<String, dynamic> snap;
  const CleanEventMark({
    super.key,
    required this.snap,
  });

  @override
  State<CleanEventMark> createState() => _CleanEventMarkState();
}

class _CleanEventMarkState extends State<CleanEventMark> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CleanEventScreen(snap: widget.snap),
              ),
            ),
        child: Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 30,
        ));
  }
}

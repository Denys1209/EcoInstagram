import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/pollution_point_screen.dart';

class my_mark extends StatefulWidget {
  final Map<String, dynamic> snap;
  const my_mark({super.key, required this.snap});

  @override
  State<my_mark> createState() => _my_markState();
}

class _my_markState extends State<my_mark> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PollutionPointScreen(snap: widget.snap),
        ),
      ),
      child: Image.asset('assets/recycle-bin.png'),
    );
  }
}

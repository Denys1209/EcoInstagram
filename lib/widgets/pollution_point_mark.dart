import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/pollution_point_screen.dart';

class PollutionPointMark extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PollutionPointMark({super.key, required this.snap});

  @override
  State<PollutionPointMark> createState() => _PollutionPointMarkState();
}

class _PollutionPointMarkState extends State<PollutionPointMark> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PollutionPointScreen(snap: widget.snap),
              ),
            ),
        child: const Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 30,
        ));
  }
}

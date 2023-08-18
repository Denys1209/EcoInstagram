import 'package:flutter/material.dart';

class HighlightMark extends StatefulWidget {
  final Function()? onChanged;

  HighlightMark({super.key, required this.onChanged});

  @override
  State<HighlightMark> createState() => _HighlightMarkState();
}

class _HighlightMarkState extends State<HighlightMark> {
  Color _isHighlight = Colors.green;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 50,
      child: GestureDetector(
        onTap: () {
          if (widget.onChanged != null) {
            widget.onChanged!();
          }
          setState(
            () {
              if (_isHighlight == Colors.green) {
                _isHighlight = Colors.red;
              } else {
                _isHighlight = Colors.green;
              }
            },
          );
        },
        child: Icon(
          Icons.location_on,
          color: _isHighlight,
          size: 40,
        ),
      ),
    );
  }
}

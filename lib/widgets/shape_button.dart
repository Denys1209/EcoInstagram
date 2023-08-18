import 'package:flutter/material.dart';

class ShapeButton extends StatefulWidget {
  final String text;
  final Color color;
  final function;

  const ShapeButton(
      {super.key,
      required this.text,
      required this.function,
      required this.color});

  @override
  State<ShapeButton> createState() => _ShapeButtonState();
}

class _ShapeButtonState extends State<ShapeButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(widget.text),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(widget.color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: widget.color),
          ),
        ),
      ),
      onPressed: widget.function,
    );
  }
}

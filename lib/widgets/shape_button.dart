import 'package:flutter/material.dart';

class ShapeButton extends StatefulWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color backgroundColorOnDisable;
  final Color borderColor;
  final String text;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  bool isEnabled;

  ShapeButton({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.function,
    required this.text,
    required this.textColor,
    this.borderRadius = 5,
    this.width = 220,
    this.height = 27,
    this.isEnabled = true,
    this.backgroundColorOnDisable = Colors.grey,
  });

  @override
  State<ShapeButton> createState() => _ShapeButtonState();
}

class _ShapeButtonState extends State<ShapeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: widget.isEnabled ? widget.function : null,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isEnabled
                ? widget.backgroundColor
                : widget.backgroundColorOnDisable,
            border: Border.all(
                color: widget.isEnabled
                    ? widget.borderColor
                    : widget.backgroundColorOnDisable),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            shape: BoxShape.rectangle,
          ),
          alignment: Alignment.center,
          width: widget.width,
          height: widget.height,
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

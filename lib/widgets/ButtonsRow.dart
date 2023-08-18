import 'package:flutter/material.dart';

class ButtonRow extends StatefulWidget {
  @override
  final howManyButtons;
  final texts;
  final functions;
  final startColor;
  final endColor;
  const ButtonRow(
      {super.key,
      required this.howManyButtons,
      required this.endColor,
      required this.startColor,
      required this.texts,
      required this.functions});

  _ButtonRowState createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  int selectedButtonIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int index = 0; index < widget.howManyButtons; index++)
          TextButton(
            child: Text(widget.texts[index]),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  index == selectedButtonIndex
                      ? widget.endColor
                      : widget.startColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(
                      color: index == selectedButtonIndex
                          ? widget.endColor
                          : widget.startColor),
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedButtonIndex = index;
              });
              if (widget.functions[index] != null) {
                widget.functions[index]();
              }
            },
          ),
      ],
    );
  }
}

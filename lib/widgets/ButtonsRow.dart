import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class ButtonRow extends StatefulWidget {
  @override
  final texts;
  final functions;
  final startColor;
  final endColor;
  const ButtonRow(
      {super.key,
      required this.endColor,
      required this.startColor,
      required this.texts,
      required this.functions});

  _ButtonRowState createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  int selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int index = 0; index < 2; index++)
          Container(
            child: TextButton(
              onPressed: () {
                setState(() {
                  selectedButtonIndex = index;
                });
                if (widget.functions[index] != null) {
                  widget.functions[index]();
                }
              },
              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: mobileBackgroundColor,
                  border: Border.all(color: primaryColor),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.texts[index],
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ),
          ),
      ],
    );
  }
}

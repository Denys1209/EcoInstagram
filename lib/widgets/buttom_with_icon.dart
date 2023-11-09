import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class ButtonWithIcon extends StatefulWidget {
  final IconData icon;
  final String text;
  final Function()? onPressed;

  const ButtonWithIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  State<ButtonWithIcon> createState() => _ButtonWithIconState();
}

class _ButtonWithIconState extends State<ButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(secondaryColor)),
          onPressed: widget.onPressed,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(widget.icon),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.text,
              style: const TextStyle(color: primaryColor),
            ),
          ])),
    );
  }
}

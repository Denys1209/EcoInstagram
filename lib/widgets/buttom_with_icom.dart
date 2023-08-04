import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_pollution_point_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class ButtonWithIcon2 extends StatelessWidget {
  final IconData icon;
  final String text;

  const ButtonWithIcon2({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddScreenPollutionPoint()),
          );
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: primaryColor),
          ),
        ]),
      ),
    );
  }
}

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
          onPressed: widget.onPressed,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(widget.icon),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.text,
              style: TextStyle(color: primaryColor),
            ),
          ])),
    );
  }
}

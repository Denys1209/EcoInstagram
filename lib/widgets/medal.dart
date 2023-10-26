import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/classes/Medal.dart';

class MedalWidget extends StatelessWidget {
  final model.User user;
  final Medal theMedal;
  MedalWidget({super.key, required this.user, required this.theMedal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage(theMedal.image),
                  backgroundColor: Colors.transparent,
                ),
                Container(
                  width: 60.0, // Same as CircleAvatar radius * 2
                  height: 60.0, // Same as CircleAvatar radius * 2
                  child: CircularProgressIndicator(
                    value: theMedal.getProgress(user),
                    backgroundColor: Colors.black,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ],
            ),
            Text(theMedal.name),
          ],
        ),
      ),
    );
  }
}

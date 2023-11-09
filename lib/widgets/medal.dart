import 'package:flutter/material.dart';
import 'package:instagram_clone/classes/Medal.dart';

class MedalWidget extends StatelessWidget {
  final Map<String, dynamic> user;
  final Medal theMedal;
  const MedalWidget({super.key, required this.user, required this.theMedal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                SizedBox(
                  width: 60.0, // Same as CircleAvatar radius * 2
                  height: 60.0, // Same as CircleAvatar radius * 2
                  child: CircularProgressIndicator(
                    value: theMedal.getProgress(user),
                    backgroundColor: Colors.black,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
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

import 'package:flutter/material.dart';
import 'package:instagram_clone/classes/Medal.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/widgets/medal.dart';

class WallWithMedals extends StatefulWidget {
  final model.User user;
  const WallWithMedals({super.key, required this.user});

  @override
  State<WallWithMedals> createState() => _WallWithMedalsState();
}

class _WallWithMedalsState extends State<WallWithMedals> {
  late List<Medal> _achievements;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _achievements = new List.empty(growable: true);
    _achievements.addAll([
      new Medal(
          type: MedalTypes.PollutionPointType,
          name: "leaf",
          greaterThan: 10,
          image: "./assets/achievements/leaf.png"),
      new Medal(
          type: MedalTypes.PollutionPointType,
          name: "plant",
          greaterThan: 50,
          image: "./assets/achievements/plant.png"),
      new Medal(
          type: MedalTypes.PollutionPointType,
          name: "save nature",
          greaterThan: 100,
          image: "./assets/achievements/save-nature.png"),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Medal sample = new Medal(
        type: MedalTypes.PollutionPointType,
        name: "test",
        greaterThan: 10,
        image: "./assets/achievements/leaf.png");
    return SingleChildScrollView(
      child: GridView.count(
        shrinkWrap: true,
        physics:
            ScrollPhysics(), // Enable scrolling within the SingleChildScrollView
        crossAxisCount: 3,
        children: List.generate(
          _achievements.length,
          (index) {
            return MedalWidget(
                user: widget.user, theMedal: _achievements[index]);
          },
        ),
      ),
    );
  }
}

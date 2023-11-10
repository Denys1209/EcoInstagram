import 'package:flutter/material.dart';
import 'package:instagram_clone/classes/Medal.dart';
import 'package:instagram_clone/widgets/medal.dart';

class WallWithMedals extends StatefulWidget {
  final Map<String, dynamic> user;
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
    _achievements = List.empty(growable: true);
    _achievements.addAll([
      Medal(
          type: MedalTypes.PollutionPointType,
          name: "leaf",
          greaterThan: 10,
          image: "./assets/achievements/for_pollutionPoints/leaf.png"),
      Medal(
          type: MedalTypes.PollutionPointType,
          name: "plant",
          greaterThan: 50,
          image: "./assets/achievements/for_pollutionPoints/plant.png"),
      Medal(
          type: MedalTypes.PollutionPointType,
          name: "save nature",
          greaterThan: 100,
          image: "./assets/achievements/for_pollutionPoints/save-nature.png"),
    ]);

    List<Medal> medalsForUser = [];
    List<Medal> medalsForOrganization = [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.count(
        shrinkWrap: true,
        physics:
            const ScrollPhysics(), // Enable scrolling within the SingleChildScrollView
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

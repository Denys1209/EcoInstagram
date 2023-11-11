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
    bool isOrganization = widget.user['isOrganization'];
    // Medals for achievements
    _achievements.addAll([
      Medal(
          type: MedalTypes.PollutionPointType,
          name: "EcoNovice",
          greaterThan: 10,
          image:
              "./assets/achievements/for_pollutionPoints/pollutionPoints_level_1.png"),
      Medal(
          type: MedalTypes.PollutionPointType,
          name: "EcoAdv",
          greaterThan: 50,
          image:
              "./assets/achievements/for_pollutionPoints/pollutionPoints_level_2.png"),
      Medal(
          type: MedalTypes.PollutionPointType,
          name: "EcoMaster",
          greaterThan: 100,
          image:
              "./assets/achievements/for_pollutionPoints/pollutionPoints_level_3.png"),
      Medal(
          type: MedalTypes.FollowersType,
          name: "StarRise",
          greaterThan: 10,
          image: "./assets/achievements/for_followers/followers_level_1.png"),
      Medal(
          type: MedalTypes.FollowersType,
          name: "Influencer",
          greaterThan: 50,
          image: "./assets/achievements/for_followers/followers_level_2.png"),
      Medal(
          type: MedalTypes.FollowersType,
          name: "EcoCeleb",
          greaterThan: 100,
          image: "./assets/achievements/for_followers/followers_level_3.png"),
    ]);

// Medals for user
    List<Medal> medalsForUser = [
      Medal(
          type: MedalTypes.CleanEventType,
          name: "CleanNewb",
          greaterThan: 10,
          image:
              "./assets/achievements/for_visited_clean_events/visited_clean_events_level_1.png"),
      Medal(
          type: MedalTypes.CleanEventType,
          name: "CleanEnthu",
          greaterThan: 50,
          image:
              "./assets/achievements/for_visited_clean_events/visited_clean_events_level_2.png"),
      Medal(
          type: MedalTypes.CleanEventType,
          name: "CleanChamp",
          greaterThan: 100,
          image:
              "./assets/achievements/for_visited_clean_events/visited_clean_events_level_3.png"),
      Medal(
          type: MedalTypes.EventType,
          name: "EventNewb",
          greaterThan: 10,
          image:
              "./assets/achievements/for_visited_events/visited_events_level_1.png"),
      Medal(
          type: MedalTypes.EventType,
          name: "EventEnthu",
          greaterThan: 50,
          image:
              "./assets/achievements/for_visited_events/visited_events_level_2.png"),
      Medal(
          type: MedalTypes.EventType,
          name: "EventMaster",
          greaterThan: 100,
          image:
              "./assets/achievements/for_visited_events/visited_events_level_3.png"),
    ];

// Medals for organization
    List<Medal> medalsForOrganization = [
      Medal(
          type: MedalTypes.CleanEventType,
          name: "CleanInit",
          greaterThan: 10,
          image:
              "./assets/achievements/for_created_clean_events/created_clean_events_level_1.png"),
      Medal(
          type: MedalTypes.CleanEventType,
          name: "CleanLead",
          greaterThan: 50,
          image:
              "./assets/achievements/for_created_clean_events/created_clean_events_level_2.png"),
      Medal(
          type: MedalTypes.CleanEventType,
          name: "CleanPion",
          greaterThan: 100,
          image:
              "./assets/achievements/for_created_clean_events/created_clean_events_level_3.png"),
      Medal(
          type: MedalTypes.EventType,
          name: "EventInit",
          greaterThan: 10,
          image:
              "./assets/achievements/for_created_events/created_events_level_1.png"),
      Medal(
          type: MedalTypes.EventType,
          name: "EventLead",
          greaterThan: 50,
          image:
              "./assets/achievements/for_created_events/created_events_level_2.png"),
      Medal(
          type: MedalTypes.EventType,
          name: "EventPion",
          greaterThan: 100,
          image:
              "./assets/achievements/for_created_events/created_events_level_3.png"),
    ];

    if (isOrganization) {
      _achievements.addAll(medalsForOrganization);
    } else {
      _achievements.addAll(medalsForUser);
    }
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

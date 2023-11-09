
enum MedalTypes {
  EventType,
  CleanEventType,
  PollutionPointType,
}

class Medal {
  final MedalTypes type;
  final String name;
  final int greaterThan;
  final String image;

  Medal({
    required this.type,
    required this.name,
    required this.greaterThan,
    required this.image,
  });

  double getProgress(Map<String, dynamic> user) {
    double progress = 0.0;
    double onePiece = greaterThan / 100;

    switch (type) {
      case MedalTypes.EventType:
        if (user["howManyEventsWereVisited"] / onePiece >= 100) {
          progress = 1.0;
        } else {
          progress = user["howManyEventsWereVisited"] / onePiece / 100;
        }
        break;
      case MedalTypes.CleanEventType:
        if (user["howManyCleanEventsWereVisited"] / onePiece >= 100) {
          progress = 1.0;
        } else {
          progress =
              user["howManyCleanEventsWereVisited"] / onePiece / 100;
        }
        break;
      case MedalTypes.PollutionPointType:
        if (user["howManyPollutionPointsWereCreted"] / onePiece >=
            100) {
          progress = 1.0;
        } else {
          progress = user["howManyPollutionPointsWereCreted"] /
              onePiece /
              100;
        }
        break;
    }
    return progress;
  }
}

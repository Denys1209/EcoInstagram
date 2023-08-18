import 'package:cloud_firestore/cloud_firestore.dart';

class EventClean {
  final DateTime date;
  final String description;
  final List<String> subscribers;
  final List<String> photos;
  final List<String> points;
  final String organizationId;
  final String id;
  final double LAT;
  final double LNG;

  EventClean({
    required this.date,
    required this.LAT,
    required this.LNG,
    required this.description,
    required this.subscribers,
    required this.photos,
    required this.organizationId,
    required this.id,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
        "date": date,
        "LAT": LAT,
        "LNG": LNG,
        "description": description,
        "subscribers": subscribers,
        "photos": photos,
        "points": points,
        "organizationId": organizationId,
        "id": id,
      };

  static EventClean fromSnap(DocumentSnapshot documentSnapshot) 
  {
    var snap = documentSnapshot.data() as Map<String, dynamic>;
    return EventClean(
      date: snap['date'],
      LAT: snap['LAT'],
      LNG: snap['LNG'],
      description: snap['description'],
      subscribers: snap['subscribers'],
      photos: snap['photos'],
      organizationId: snap['organizationId'],
      id: snap['id'],
      points: snap['points'],
    );
  }
}

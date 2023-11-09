import 'package:cloud_firestore/cloud_firestore.dart';

class EventClean {
  final String name;
  final DateTime startDate;
  final String description;
  final List<String> subscribers;
  final List<String> photos;
  final List<String> points;
  final String organizationId;
  final String organizationsName;
  final String profImage;
  final String id;
  final double LAT;
  final double LNG;
  final List likes;

  EventClean({
    required this.name,
    required this.startDate,
    required this.LAT,
    required this.LNG,
    required this.description,
    required this.subscribers,
    required this.photos,
    required this.organizationId,
    required this.id,
    required this.points,
    required this.likes,
    required this.organizationsName,
    required this.profImage,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "startDate": startDate,
        "LAT": LAT,
        "LNG": LNG,
        "description": description,
        "subscribers": subscribers,
        "photos": photos,
        "points": points,
        "organizationId": organizationId,
        "organizationsName": organizationsName,
        "profImage": profImage,
        "id": id,
        'likes': likes,
      };

  static EventClean fromSnap(DocumentSnapshot documentSnapshot) {
    var snap = documentSnapshot.data() as Map<String, dynamic>;
    return EventClean(
      name: snap['name'],
      startDate: snap['startDate'],
      LAT: snap['LAT'],
      LNG: snap['LNG'],
      description: snap['description'],
      subscribers: snap['subscribers'],
      photos: snap['photos'],
      organizationId: snap['organizationId'],
      id: snap['id'],
      points: snap['points'],
      likes: snap['likes'],
      organizationsName: snap['organizationsName'],
      profImage: snap['profImage'],
    );
  }
}

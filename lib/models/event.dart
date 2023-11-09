
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final List<String> subscribers;
  final List<String> photos;
  final String organizationId;
  final String organizationsName;
  final String profImage;
  final String id;
  final double LAT;
  final double LNG;
  final likes;

  Event({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.LAT,
    required this.LNG,
    required this.description,
    required this.subscribers,
    required this.photos,
    required this.organizationId,
    required this.id,
    required this.likes,
    required this.profImage,
    required this.organizationsName,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "startDate": startDate,
        "endDate": endDate,
        "LAT": LAT,
        "LNG": LNG,
        "description": description,
        "subscribers": subscribers,
        "photos": photos,
        "organizationId": organizationId,
        "id": id,
        "likes": likes,
        "profImage": profImage,
        'organizationsName': organizationsName,
      };

  static Event fromSnap(DocumentSnapshot documentSnapshot) {
    var snap = documentSnapshot.data() as Map<String, dynamic>;
    return Event(
      name: snap['name'],
      startDate: snap['startDate'],
      endDate: snap['startDate'],
      LAT: snap['LAT'],
      LNG: snap['LNG'],
      description: snap['description'],
      subscribers: snap['subscribers'],
      photos: snap['photos'],
      organizationId: snap['organizationId'],
      id: snap['id'],
      likes: snap['likes'],
      profImage: snap['profImage'],
      organizationsName: snap["organizationsName"],
    );
  }
}

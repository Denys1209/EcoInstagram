import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final DateTime date;
  final String description;
  final List<String> subscribers;
  final List<String> photos;
  final String organizationId;
  final String id;
  final double LAT;
  final double LNG;

  Event({
    required this.date,
    required this.LAT,
    required this.LNG,
    required this.description,
    required this.subscribers,
    required this.photos,
    required this.organizationId,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        "date": date,
        "LAT": LAT,
        "LNG": LNG,
        "description": description,
        "subscribers": subscribers,
        "photos": photos,
        "organizationId": organizationId,
        "id": id,
      };

  static Event fromSnap(DocumentSnapshot documentSnapshot) 
  {
    var snap = documentSnapshot.data() as Map<String, dynamic>;
    return Event(
      date: snap['date'],
      LAT: snap['LAT'],
      LNG: snap['LNG'],
      description: snap['description'],
      subscribers: snap['subscribers'],
      photos: snap['photos'],
      organizationId: snap['organizationId'],
      id: snap['id'],
    );
  }
}


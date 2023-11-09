import 'package:cloud_firestore/cloud_firestore.dart';

class PollutionPoint {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String eventId;
  final String profImage;
  final double LAT;
  final double LNG;
  final List likes;

  PollutionPoint({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.LAT,
    required this.LNG,
    required this.eventId,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
        "LAT": LAT,
        "LNG": LNG,
        "eventId": eventId,
      };

  static PollutionPoint fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PollutionPoint(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postUrl'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      LAT: snapshot['LAT'],
      LNG: snapshot['LNG'],
      eventId: snapshot['eventId'],
    );
  }
}

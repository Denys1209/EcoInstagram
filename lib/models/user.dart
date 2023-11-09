import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;
  final List followingEvents;
  final List followingCleanEvents;
  final int howManyPollutionPointsWereCreted;
  final int howManyCleanEventsWereVisited;
  final int howManyEventsWereVisited;
  final bool isOrganization;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.followingEvents,
    required this.followingCleanEvents,
    required this.howManyPollutionPointsWereCreted,
    required this.howManyCleanEventsWereVisited,
    required this.howManyEventsWereVisited,
    required this.isOrganization,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "followingEvents": followingEvents,
        "followingCleanEvents": followingCleanEvents,
        "howManyPollutionPointsWereCreted": howManyPollutionPointsWereCreted,
        "howManyCleanEventsWereVisited": howManyCleanEventsWereVisited,
        "howManyEventsWereVisited": howManyEventsWereVisited,
        "isOrganization": isOrganization,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      followingEvents: snapshot['followingEvents'],
      followingCleanEvents: snapshot['followingCleanEvents'],
      howManyPollutionPointsWereCreted:
          snapshot['howManyPollutionPointsWereCreted'],
      howManyCleanEventsWereVisited: snapshot["howManyCleanEventsWereVisited"],
      howManyEventsWereVisited: snapshot["howManyEventsWereVisited"],
      isOrganization: snapshot["isOrganization"],
    );
  }
}

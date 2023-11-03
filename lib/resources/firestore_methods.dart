import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instagram_clone/models/pollution_point.dart';
import 'package:instagram_clone/models/event.dart';
import 'package:instagram_clone/models/event_clean.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String POLLUTION_POINTS = 'pollutionPoints';
  final String POINTS = 'points';
  final String COMMENTS = 'comments';
  final String CLEAN_EVENTS = 'cleanEvents';
  final String EVENTS = 'events';
  final String USERS = 'users';

  Future<String> uploadPoint(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    Position position,
  ) async {
    String res = "some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage(POINTS, file, true);

      String postId = const Uuid().v1();
      PollutionPoint point = PollutionPoint(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        LAT: position.latitude,
        LNG: position.longitude,
        likes: [],
        eventId: "",
      );

      _firestore.collection(POLLUTION_POINTS).doc(postId).set(point.toJson());
      _firestore.collection(USERS).doc(uid).update({
        'howManyPollutionPointsWereCreted': FieldValue.increment(1),
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection(POLLUTION_POINTS).doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        likes.remove(uid);
      } else {
        // else we need to add uid to the likes array
        _firestore.collection(POLLUTION_POINTS).doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        likes.add(uid);
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> postCommentOnPost(String postId, String text, String uid,
      String name, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection(POLLUTION_POINTS)
            .doc(postId)
            .collection(COMMENTS)
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': [],
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> deletePollutionPoint(String pointId) async {
    try {
      final collection = FirebaseFirestore.instance.collection(CLEAN_EVENTS);
      final snapshot = await collection.get();
      final docs = snapshot.docs;
      for (var doc in docs) {
        final data = doc.data();
        final array = data[POINTS];

        if (array.contains(pointId)) {
          await doc.reference.update({
            POINTS: FieldValue.arrayRemove([pointId])
          });
        }
      }
      await _firestore.collection(POLLUTION_POINTS).doc(pointId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<List<String>> getAllUrlsFromListOfPolltuionsID(
      List<String> listOfIds) async {
    List<String> res = List.empty(growable: true);
    for (String id in listOfIds) {
      final DocumentReference document =
          await _firestore.collection(POLLUTION_POINTS).doc(id);
      final DocumentSnapshot snapshot = await document.get();
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      res.add(data['postUrl']);
    }
    return res;
  }

  Future<void> uploadEventClean(
    String name,
    DateTime date,
    double LAT,
    double LNG,
    String description,
    String organizationId,
    List<String> photos,
    List<String> points,
    String organizationsName,
    String profImage,
  ) async {
    try {
      String id = const Uuid().v1();
      EventClean eventClean = new EventClean(
        name: name,
        startDate: date,
        LAT: LAT,
        LNG: LNG,
        description: description,
        subscribers: [],
        photos: photos,
        organizationId: organizationId,
        id: id,
        points: points,
        likes: [],
        organizationsName: organizationsName,
        profImage: profImage,
      );
      await _firestore
          .collection(CLEAN_EVENTS)
          .doc(id)
          .set(eventClean.toJson());
      await this.subscribeOnACleanEvent(id, organizationId, []);
      for (var i in points) {
        await _firestore.collection(POLLUTION_POINTS).doc(i).update(
          {
            'eventId': id,
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadEvent(
    String name,
    DateTime startDate,
    DateTime endDate,
    double LAT,
    double LNG,
    String description,
    String organizationId,
    List<Uint8List> photos,
    String organizationsName,
    String profImage,
  ) async {
    try {
      String id = const Uuid().v1();
      List<String> urls =
          await StorageMethods().uploadImagesToStorage(EVENTS, photos);
      Event event = Event(
        name: name,
        startDate: startDate,
        endDate: endDate,
        LAT: LAT,
        LNG: LNG,
        description: description,
        subscribers: [],
        photos: urls,
        organizationId: organizationId,
        id: id,
        likes: [],
        organizationsName: organizationsName,
        profImage: profImage,
      );
      await _firestore.collection(EVENTS).doc(id).set(event.toJson());
      await this.subscribeOnAnEvent(id, organizationId, []);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postCommentOnCleanEvent(String eventId, String text, String uid,
      String name, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection(CLEAN_EVENTS)
            .doc(eventId)
            .collection(COMMENTS)
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': [],
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postCommentOnEvent(String eventId, String text, String uid,
      String name, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection(EVENTS)
            .doc(eventId)
            .collection(COMMENTS)
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': [],
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> subscribeOnAnEvent(
      String eventId, String userId, List subs) async {
    if (subs.contains(userId)) {
      _firestore.collection(EVENTS).doc(eventId).update({
        'subscribers': FieldValue.arrayRemove([userId]),
      });
      _firestore.collection(USERS).doc(userId).update({
        'followingEvents': FieldValue.arrayRemove([eventId]),
      });
      subs.remove(userId);
    } else {
      _firestore.collection(EVENTS).doc(eventId).update({
        'subscribers': FieldValue.arrayUnion([userId]),
      });
      _firestore.collection(USERS).doc(userId).update({
        'followingEvents': FieldValue.arrayUnion([eventId]),
      });

      subs.add(userId);
    }
  }

  Future<void> subscribeOnACleanEvent(
      String enventId, String userId, List subs) async {
    if (subs.contains(userId)) {
      _firestore.collection(CLEAN_EVENTS).doc(enventId).update({
        'subscribers': FieldValue.arrayRemove([userId]),
      });
      _firestore.collection(USERS).doc(userId).update({
        'followingCleanEvents': FieldValue.arrayRemove([enventId]),
      });
      subs.remove(userId);
    } else {
      _firestore.collection(CLEAN_EVENTS).doc(enventId).update({
        'subscribers': FieldValue.arrayUnion([userId]),
      });
      _firestore.collection(USERS).doc(userId).update({
        'followingCleanEvents': FieldValue.arrayUnion([enventId]),
      });

      subs.add(userId);
    }
  }

  Future<void> subscribeOnUser(String id, String subOn) async {
    User userFrom =
        User.fromSnap(await _firestore.collection(USERS).doc(id).get());
    User userOn =
        User.fromSnap(await _firestore.collection(USERS).doc(subOn).get());

    if (userFrom.followers.contains(userOn.uid)) {
      _firestore.collection(USERS).doc(userOn.uid).update({
        'followers': FieldValue.arrayRemove([userFrom.uid]),
      });
      _firestore.collection(USERS).doc(userFrom.uid).update({
        'following': FieldValue.arrayRemove([userOn.uid]),
      });
    } else {
      _firestore.collection(USERS).doc(userOn.uid).update({
        'followers': FieldValue.arrayUnion([userFrom.uid]),
      });
      _firestore.collection(USERS).doc(userFrom.uid).update({
        'following': FieldValue.arrayUnion([userOn.uid]),
      });
    }
  }
}

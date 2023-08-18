import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instagram_clone/models/PollutionPoint.dart';
import 'package:instagram_clone/models/event.dart';
import 'package:instagram_clone/models/event_clean.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String POLLUTION_POINTS = 'pollutionPoints';
  final String POINTS = 'points';
  final String COMMENTS = 'comments';
  final String CLEAN_EVENTS = 'cleanEvents';
  final String EVENTS = 'events';

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

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
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

  Future<void> deletePollutionPoint(String postId) async {
    try {
      await _firestore.collection(POLLUTION_POINTS).doc(postId).delete();
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
    DateTime date,
    double LAT,
    double LNG,
    String description,
    String organizationId,
    List<String> photos,
    List<String> points,
  ) async {
    try {
      String id = const Uuid().v1();
      EventClean eventClean = new EventClean(
          date: date,
          LAT: LAT,
          LNG: LNG,
          description: description,
          subscribers: [],
          photos: photos,
          organizationId: organizationId,
          id: id,
          points: points);
      await _firestore
          .collection(CLEAN_EVENTS)
          .doc(id)
          .set(eventClean.toJson());
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
    DateTime date,
    double LAT,
    double LNG,
    String description,
    String organizationId,
    List<Uint8List> photos,
  ) async {
    try {
      String id = const Uuid().v1();
      List<String> urls =
          await StorageMethods().uploadImagesToStorage(EVENTS, photos);
      Event event = Event(
          date: date,
          LAT: LAT,
          LNG: LNG,
          description: description,
          subscribers: [],
          photos: urls,
          organizationId: organizationId,
          id: id);
      await _firestore.collection(EVENTS).doc(id).set(event.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}

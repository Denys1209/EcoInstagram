import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instagram_clone/models/PollutionPoint.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          await StorageMethods().uploadImageToStorage('points', file, true);

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
          likes: []);

      _firestore.collection('pollutionPoints').doc(postId).set(point.toJson());
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
        _firestore.collection('pollutionPoints').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        likes.remove(uid);
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('pollutionPoints').doc(postId).update({
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

  Future<Map<String, dynamic>?> refresh(String postId) async {
    String res = "Some error occurred";
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('pollutionPoints');
    try {
      var dataBase = await _collectionRef.doc(postId).get();
      if (dataBase.exists) {
        Map<String, dynamic>? data = dataBase.data() as Map<String, dynamic>?;
        return data;
      }
      res = 'success';
    } catch (err) {
      print(err.toString());
    }
    return null;
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('pollutionPoints')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': []
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

  Future<void> deletePost(String postId) async
  {

  }
}

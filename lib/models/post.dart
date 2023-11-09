
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userName;
  final DateTime postDate;
  final String message;
  final String userId;
  final String profImage;
  final String id;
  final List likes;

  Post(
      {required this.message,
      required this.likes,
      required this.postDate,
      required this.profImage,
      required this.userId,
      required this.userName,
      required this.id});
  Map<String, dynamic> toJson() => {
        "userName": userName,
        "postDate": postDate,
        "description": message,
        "userId": userId,
        "id": id,
        "likes": likes,
        "profImage": profImage,
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      userId: snapshot['userId'],
      postDate: (snapshot['postDate'] as Timestamp).toDate(),
      message: snapshot['description'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      profImage: snapshot['profImage'],
      userName: snapshot['userName'],
    );
  }
}

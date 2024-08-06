import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late String comment, postId, senderId, commentTime;

  CommentModel({
    required this.comment,
    required this.postId,
    required this.senderId,
    required this.commentTime,
  });

  CommentModel.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> model) {
    comment = model['comment'];
    postId = model['postId'];
    senderId = model['senderId'];
    commentTime = model['commentTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'postId': postId,
      'senderId': senderId,
      'commentTime': commentTime,
    };
  }
}

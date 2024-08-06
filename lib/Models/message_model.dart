import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late String message, receiverId, senderId, messageTime;

  MessageModel({
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.messageTime,
  });

  MessageModel.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> model) {
    message = model['message'];
    receiverId = model['receiverId'];
    senderId = model['senderId'];
    messageTime = model['messageTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'receiverId': receiverId,
      'senderId': senderId,
      'messageTime': messageTime,
    };
  }
}

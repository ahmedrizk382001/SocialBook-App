import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String name, email, phone, uid;
  late String coverImage,
      profileImage,
      birthday,
      gender,
      relationshipStatus,
      bio;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.uid,
      this.coverImage =
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBHnPo0bFH3LqcO4SPcddMob7hhXgX6d3nhw&s',
      this.profileImage =
          "https://as2.ftcdn.net/v2/jpg/04/10/43/77/1000_F_410437733_hdq4Q3QOH9uwh0mcqAhRFzOKfrCR24Ta.jpg",
      this.birthday = 'not Specified',
      this.gender = 'not Specified',
      this.relationshipStatus = 'not Specified',
      this.bio = 'not Specified'});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'birthday': birthday,
      'gender': gender,
      'relationshipStatus': relationshipStatus,
      'bio': bio,
    };
  }

  UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> model) {
    name = model['name'];
    email = model['email'];
    phone = model['phone'];
    uid = model['uid'];
    profileImage = model['profileImage'];
    coverImage = model['coverImage'];
    birthday = model['birthday'];
    gender = model['gender'];
    relationshipStatus = model['relationshipStatus'];
    bio = model['bio'];
  }
}

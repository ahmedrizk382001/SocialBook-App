class PostModel {
  late String postContent, postImage, postTime, name, profileImage, uid;
  late bool bookmark, isLikedByCurrentUser;

  PostModel({
    this.postContent = 'not Specified',
    this.postImage = 'not Specified',
    this.postTime = 'not Specified',
    required this.name,
    required this.profileImage,
    required this.uid,
    this.bookmark = false,
    this.isLikedByCurrentUser = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'postContent': postContent,
      'postImage': postImage,
      'postTime': postTime,
      'bookmark': bookmark,
      'uid': uid,
      'isLikedByCurrentUser': isLikedByCurrentUser,
    };
  }

  PostModel.fromJson(Map<String, dynamic> model) {
    name = model['name'];
    profileImage = model['profileImage'];
    postContent = model['postContent'];
    postImage = model['postImage'];
    postTime = model['postTime'];
    bookmark = model['bookmark'];
    uid = model['uid'];
    isLikedByCurrentUser = model['isLikedByCurrentUser'] ?? false;
  }
}

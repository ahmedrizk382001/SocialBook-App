import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Layouts/SocialCubit/social_states.dart';
import 'package:social_app/Models/comment_model.dart';
import 'package:social_app/Models/message_model.dart';
import 'package:social_app/Models/post_model.dart';
import 'package:social_app/Models/user_model.dart';
import 'package:social_app/Modules/BookmarkScreen/bookmark_screen.dart';
import 'package:social_app/Modules/ChatsScreen/chats_screen.dart';
import 'package:social_app/Modules/HomeScreen/home_screen.dart';
import 'package:social_app/Modules/ProfileScreen/profile_screen.dart';
import 'package:social_app/Shared/Components/constants.dart';

class SocialCubit extends Cubit<SocialCubitStates> {
  SocialCubit() : super(SocialCubitInitialState());

  static SocialCubit get(BuildContext context) =>
      BlocProvider.of<SocialCubit>(context);

  List<Widget> bottomNavIcons = [
    Icon(
      IconBroken.Home,
      color: secondaryColor,
    ),
    Icon(
      IconBroken.Chat,
      color: secondaryColor,
    ),
    Icon(
      IconBroken.Profile,
      color: secondaryColor,
    ),
    Icon(
      IconBroken.Bookmark,
      color: secondaryColor,
    )
  ];

  List<String> bottomNavName = ["Home", "Chats", "Profile", "Bookmark"];

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    ProfileScreen(),
    BookmarkScreen()
  ];

  int bottomNavCurrentIndex = 0;

  void changeBottomNav({required int index}) {
    bottomNavCurrentIndex = index;
    emit(SocialCubitChangeBottomNavState());
    if (bottomNavCurrentIndex == 1) {}
  }

  bool isNewPost = false;

  void showPostButton({required bool isNewPostValue}) {
    isNewPost = isNewPostValue;
    emit(SocialCubitShowPostButtonState());
  }

  DateTime? selectedDate;
  String? selectedGender;
  String? selectedRelationshipStatus;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> relationshipStatuses = [
    'Single',
    'In a relationship',
    'Married',
    'Divorced'
  ];

  void changeSelectedDate({required DateTime? date}) {
    selectedDate = date;
    emit(SetupProfileChangeSelectedDate());
  }

  void changeSelectedGender({required String? gender}) {
    selectedGender = gender;
    emit(SetupProfileChangeSelectedGender());
  }

  void changeSelectedRelationshipStatus({required String? relationshipStatus}) {
    selectedRelationshipStatus = relationshipStatus;
    emit(SetupProfileChangeSelectedRelationshipStatus());
  }

  late UserModel userModel;

  void getUserData() {
    if (FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
      emit(SocialCubitGetUserDataLoadingState());
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen(
        (event) {
          userModel = UserModel.fromJson(event);
          selectedDate = userModel.birthday == 'not Specified'
              ? null
              : DateTime.parse(userModel.birthday);
          selectedGender =
              userModel.gender == 'not Specified' ? null : userModel.gender;
          selectedRelationshipStatus =
              userModel.relationshipStatus == 'not Specified'
                  ? null
                  : userModel.relationshipStatus;
          emit(SocialCubitGetUserDataSuccessState());
        },
      );
    }
  }

  void createUserProfileInfo(
      {required String birthday,
      required String gender,
      required String relationshipStatus}) {
    emit(SocialCreateUserProfileInfoLoadingState());
    userModel.birthday = birthday;
    userModel.gender = gender;
    userModel.relationshipStatus = relationshipStatus;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .set(userModel.toMap())
        .then(
      (value) {
        emit(SocialCreateUserProfileInfoSuccessState());
        getUserData();
      },
    ).catchError((error) {
      emit(SocialCreateUserProfileInfoErrorState(error: error));
    });
  }

  File? getImage;
  ImagePicker picker = ImagePicker();

  void getImageFromMobile({required String imageType}) async {
    picker.pickImage(source: ImageSource.gallery).then(
      (value) {
        if (value != null) {
          getImage = File(value.path);
          emit(SocialImagePickSuccessState());
          if (imageType == "coverImage" || imageType == "profileImage") {
            uploadImagetoStorage(imageType: imageType);
          } else {
            uploadPostImagetoStorage();
          }
        } else {
          print("No image selected");
          emit(SocialImagePickErrorState());
        }
      },
    ).catchError((error) {
      emit(SocialImagePickErrorState());
    });
  }

  String imageUrl = '';

  void uploadImagetoStorage({required String imageType}) {
    emit(SocialImageUploadLoadingState());

    FirebaseStorage.instance
        .ref()
        .child(
            "users/${userModel.uid}/$imageType/${Uri.file(getImage!.path).pathSegments.last}")
        .putFile(getImage!)
        .then(
      (value) {
        value.ref.getDownloadURL().then(
          (value) {
            imageUrl = value;
            if (imageType == "profileImage") {
              userModel.profileImage = imageUrl;
            } else if (imageType == "coverImage") {
              userModel.coverImage = imageUrl;
            }
            emit(SocialImageUploadSuccessState());
            updateUserData();
          },
        ).catchError((error) {
          print(error);
          emit(SocialImageUploadErrorState(error: error));
        });
      },
    ).catchError((error) {
      print(error);
      emit(SocialImageUploadErrorState(error: error));
    });
  }

  void updateUserData() {
    emit(SocialUpdateUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .update(userModel.toMap())
        .then(
      (value) {
        emit(SocialUpdateUserDataSuccessState());
      },
    ).catchError((error) {
      emit(SocialUpdateUserDataErrorState(error: error));
    });
  }

  bool isBioEnabled = false;

  void editBio({required isEnabled}) {
    isBioEnabled = isEnabled;
    emit(SocialEditBio());
  }

  void updateBio({required String newBio}) {
    emit(SocialUpdateBioLoadingState());
    if (newBio != '') {
      userModel.bio = newBio;
      emit(SocialUpdateBioSuccessState());
      updateUserData();
    }
  }

  late PostModel postModel = PostModel(
      name: userModel.name,
      profileImage: userModel.profileImage,
      uid: userModel.uid);
  int postIndex = 0;

  void uploadPostImagetoStorage() {
    emit(SocialPostImageUploadLoadingState());
    FirebaseStorage.instance
        .ref()
        .child(
            "users/${userModel.uid}/postImage/${Uri.file(getImage!.path).pathSegments.last}")
        .putFile(getImage!)
        .then(
      (value) {
        value.ref.getDownloadURL().then(
          (value) {
            postModel.postImage = value;

            emit(SocialPostImageUploadSuccessState());
          },
        ).catchError((error) {
          print(error);
          emit(SocialPostImageUploadErrorState(error: error));
        });
      },
    ).catchError((error) {
      print(error);
      emit(SocialPostImageUploadErrorState(error: error));
    });
  }

  void uploadPost({
    required String postTime,
    required String postContent,
    String postImage = 'not Specified',
  }) {
    emit(SocialUploadPostLoadingState());

    postModel.postContent = postContent;
    postModel.postTime = postTime;
    FirebaseFirestore.instance.collection('posts').add(postModel.toMap()).then(
      (value) {
        emit(SocialUploadPostSuccessState());
      },
    ).catchError((error) {
      print("error: $error");
      emit(SocialUploadPostErrorState(error: error));
    });
  }

  bool isPostImageSelected = false;
  void postImage({required bool isSelected}) {
    isPostImageSelected = isSelected;
    emit(SocialSelectPostImageState());
  }

  List<PostModel> postsList = [];
  List<String> postIdList = [];
  List<int> postCommentsNumber = [];
  Map<String, int> postLikesMap = {};

  void getPosts() {
    if (FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
      emit(SocialGetPostsLoadingState());

      FirebaseFirestore.instance
          .collection('posts')
          .orderBy("postTime", descending: true)
          .snapshots()
          .listen((querySnapshot) {
        // Initialize lists and map
        postsList.clear();
        postIdList.clear();
        postCommentsNumber.clear();

        for (var element in querySnapshot.docs) {
          var postModel = PostModel.fromJson(element.data());
          String postId = element.id;
          postsList.add(postModel);
          postIdList.add(postId);

          // Initialize comments count with 0 for each post
          postCommentsNumber.add(0);

          int index = postIdList.indexOf(postId);

          // Listen to comments count in real-time for each post
          element.reference
              .collection('comments')
              .snapshots()
              .listen((commentsSnapshot) {
            if (index >= 0 && index < postCommentsNumber.length) {
              postCommentsNumber[index] = commentsSnapshot.docs.length;
              emit(SocialGetPostsSuccessState());
            }
          });

          // Initialize likes count for the post if not already initialized
          if (!postLikesMap.containsKey(postId)) {
            postLikesMap[postId] = 0; // Initialize likes count to 0
          }

          // Listen to likes count in real-time for each post
          element.reference
              .collection('likes')
              .snapshots()
              .listen((likesSnapshot) {
            int likeCount = likesSnapshot.docs.length;

            // Update likes count for the specific post
            postLikesMap[postId] = likeCount;

            if (index != -1) {
              postsList[index].isLikedByCurrentUser =
                  likesSnapshot.docs.any((doc) => doc.id == userModel.uid);
              emit(SocialGetPostsSuccessState());
            }
          });
        }

        // Initial emit after setting up the listeners
        emit(SocialGetPostsSuccessState());
      }, onError: (error) {
        print("Error getting posts: $error");
        emit(SocialGetPostsErrorState(error: error));
      });
    }
  }

  void likeToPost({required int index, required bool react}) {
    emit(SocialReactToPostLoadingState());

    String postId = postIdList[index];
    String userId = userModel.uid;

    // Create a reference to the post's likes subcollection
    var likesRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId);

    // Create a reference to the post document
    var postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    // Determine the action based on the react value
    var action = react
        ? likesRef.set({'state': 'user reacted to this post'})
        : likesRef.delete();

    action.then((value) {
      // Update the isLikedByCurrentUser field on the post document
      postRef.update({'isLikedByCurrentUser': react}).then((value) {
        // Update local state
        postsList[index].isLikedByCurrentUser = react;

        // Emit success state after updating Firestore and local state
        emit(SocialReactToPostSuccessState());
      }).catchError((error) {
        emit(SocialReactToPostErrorState(error: error));
      });
    }).catchError((error) {
      emit(SocialReactToPostErrorState(error: error));
    });
  }

  void bookmark({required int index, required bool react}) {
    emit(SocialBookmarkLoadingState());
    String postId = postIdList[index];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({'bookmark': react}).then(
      (value) {
        emit(SocialBookmarkSuccessState());
      },
    ).catchError((error) {
      emit(SocialBookmarkErrorState(error: error));
    });
  }

  List<Map<String, dynamic>> users = [];
  List<String> usersUID = [];
  void getAllUsers() {
    if (FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
      emit(SocialGetAllUsersLoadingState());
      FirebaseFirestore.instance.collection('users').snapshots().listen(
        (event) {
          for (var element in event.docs) {
            if (element.id != userModel.uid) {
              if (!usersUID.contains(element.id)) {
                usersUID.add(element.id);
                users.add({element.id: UserModel.fromJson(element)});
              }
            }
          }
          emit(SocialGetAllUsersSuccessState());
        },
      );
    }
  }

  void sendMessage(
      {required String message,
      required String receiverId,
      required String messageTime}) {
    emit(SocialSendMessageLoadingState());

    MessageModel messageModel = MessageModel(
        message: message,
        receiverId: receiverId,
        senderId: userModel.uid,
        messageTime: messageTime);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc()
        .set(messageModel.toMap())
        .then(
      (value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(receiverId)
            .collection('chats')
            .doc(userModel.uid)
            .collection('messages')
            .doc()
            .set(messageModel.toMap())
            .then(
          (value) {
            emit(SocialSendMessageSuccessState());
          },
        ).catchError((error) {
          emit(SocialSendMessageErrorState(error: error));
        });
      },
    ).catchError((error) {
      emit(SocialSendMessageErrorState(error: error));
    });
  }

  List<MessageModel> messages = [];
  void getMessages({required String receiverId}) {
    messages = [];
    emit(SocialGetMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('messageTime', descending: false)
        .snapshots()
        .listen(
      (event) {
        for (var element in event.docs) {
          messages.add(MessageModel.fromJson(element));
        }
        emit(SocialGetMessagesSuccessState());
      },
    );
  }

  List<PopupMenuEntry<dynamic>> popupMenuItems = [
    PopupMenuItem(
        value: "Delete",
        child: Text(
          "Delete",
          style: TextStyle(color: secondaryColor),
        ))
  ];

  void deletePost({required String postId}) {
    emit(SocialDeletePostLoadingState());
    FirebaseFirestore.instance.collection('posts').doc(postId).delete().then(
      (value) {
        emit(SocialDeletePostSuccessState());
      },
    ).catchError((error) {
      emit(SocialDeletePostErrorState(error: error));
    });
  }

  void postComment(
      {required String comment,
      required String postId,
      required String commentTime}) {
    emit(SocialPostCommentLoadingState());

    CommentModel commentModel = CommentModel(
        comment: comment,
        postId: postId,
        senderId: userModel.uid,
        commentTime: commentTime);

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc()
        .set(commentModel.toMap())
        .then(
      (value) {
        emit(SocialPostCommentSuccessState());
      },
    ).catchError((error) {
      emit(SocialPostCommentErrorState(error: error));
    });
  }

  List<CommentModel> postComments = [];
  List<String> postCommentsId = [];
  void getComments({required String postId}) {
    emit(SocialGetPostCommentsLoadingState());
    postComments = [];
    postCommentsId = [];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen(
      (event) {
        for (var element in event.docs) {
          postCommentsId.add(element.id);
          postComments.add(CommentModel.fromJson(element));
          emit(SocialGetPostCommentsSuccessState());
        }
        emit(SocialGetPostCommentsSuccessState());
      },
    );
  }

  void deleteComment({required String postId, required String commentId}) {
    emit(SocialDeleteCommentLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete()
        .then(
      (value) {
        emit(SocialDeleteCommentSuccessState());
        getPosts();
      },
    ).catchError((error) {
      emit(SocialDeleteCommentErrorState(error: error));
    });
  }
}

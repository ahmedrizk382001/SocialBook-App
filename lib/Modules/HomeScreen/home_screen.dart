import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Layouts/SocialCubit/social_cubit.dart';
import 'package:social_app/Layouts/SocialCubit/social_states.dart';
import 'package:social_app/Models/comment_model.dart';
import 'package:social_app/Models/post_model.dart';
import 'package:social_app/Models/user_model.dart';
import 'package:social_app/Modules/LoginScreen/LoginCubit/login_cubit.dart';
import 'package:social_app/Modules/LoginScreen/login_screen.dart';
import 'package:social_app/Shared/Components/components.dart';
import 'package:social_app/Shared/Components/constants.dart';
import 'package:social_app/main.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController newPostController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {
        if (state is SocialUploadPostSuccessState) {
          SocialCubit.get(context).showPostButton(isNewPostValue: false);
          showToast("Post Uploaded Successfully", Colors.green, Colors.black87);
        } else if (state is SocialUploadPostErrorState) {
          SocialCubit.get(context).showPostButton(isNewPostValue: false);
          showToast("An error occurred, please try again later ", Colors.red,
              Colors.black12);
        }
      },
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              HomeHeader(
                userModel: socialCubit.userModel,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(
                    bottom: 0, left: 20, right: 20, top: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xffe4e8ec),
                ),
                child: Column(
                  children: [
                    buildAppTextFormField(
                      context,
                      controller: newPostController,
                      hintText: "Post your Activity",
                      onChange: (value) {
                        if (value.isEmpty) {
                          socialCubit.showPostButton(isNewPostValue: false);
                        } else {
                          socialCubit.showPostButton(isNewPostValue: true);
                        }
                      },
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(10),
                        child: IconButton(
                            onPressed: () {
                              socialCubit.getImageFromMobile(
                                  imageType: "postImage");
                              socialCubit.postImage(isSelected: true);
                            },
                            icon: Icon(
                              IconBroken.Camera,
                              color: secondaryColor,
                            )),
                      ),
                      borderRaduis: BorderRadius.circular(50),
                    ),
                    if (socialCubit.isPostImageSelected)
                      const SizedBox(
                        height: 10,
                      ),
                    if (socialCubit.isPostImageSelected) const AddPostImage(),
                  ],
                ),
              ),
              if (socialCubit.isNewPost)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        socialCubit.uploadPost(
                            postTime: DateFormat('MMM dd, yyyy hh:mm:ss a')
                                .format(DateTime.now()),
                            postContent: newPostController.text,
                            postImage: socialCubit.postModel.postImage);
                        socialCubit.postImage(isSelected: false);
                        newPostController.text = '';
                      },
                      child: Text(
                        "POST",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: secondaryColor, fontWeight: FontWeight.w700),
                      )),
                ),
              const SizedBox(
                height: 20,
              ),
              ConditionalBuilder(
                condition: socialCubit.postsList.isNotEmpty &&
                    socialCubit.postIdList.isNotEmpty &&
                    socialCubit.postLikesMap.isNotEmpty,
                builder: (context) {
                  return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return SocialPost(
                          postModel: socialCubit.postsList[index],
                          index: index,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: socialCubit.postsList.length);
                },
                fallback: (context) => Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "No Posts to Show...",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: secondaryColor.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(userModel.profileImage),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: secondaryColor,
                        )),
                const SizedBox(
                  width: 5,
                ),
                Text(userModel.name,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          color: secondaryColor,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        )),
              ],
            ),
          ),
          Expanded(
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.Notification,
                  color: secondaryColor,
                )),
          ),
          Expanded(
            child: IconButton(
                onPressed: () {
                  SocialLoginCubit.get(context).logout();
                  pushRemove(context, LoginScreen());
                },
                icon: Icon(
                  IconBroken.Logout,
                  color: secondaryColor,
                )),
          ),
        ],
      ),
    );
  }
}

class AddPostImage extends StatelessWidget {
  const AddPostImage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(20),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ConditionalBuilder(
              condition: state is! SocialPostImageUploadLoadingState &&
                  socialCubit.postModel.postImage != 'not Specified',
              builder: (context) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image(
                        image: NetworkImage(socialCubit.postModel.postImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    InkWell(
                      child: CircleAvatar(
                        backgroundColor: mainColor.withOpacity(0.5),
                        child: const Icon(
                          IconBroken.Paper_Fail,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {},
                    )
                  ],
                );
              },
              fallback: (context) => centerIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class SocialPost extends StatelessWidget {
  SocialPost({super.key, required this.postModel, required this.index});

  final PostModel postModel;
  final int index;

  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {
        if (state is SocialPostCommentSuccessState) {
          showToast("Comment Added Successfully", Colors.green, Colors.black87);
        } else if (state is SocialPostCommentErrorState) {
          showToast(
              "Network Error, Please try again", Colors.red, Colors.black87);
        }
      },
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(postModel.profileImage),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(postModel.name,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w700,
                                  )),
                      Text(postModel.postTime,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: secondaryColor.withOpacity(0.5),
                                  )),
                    ],
                  ),
                  const Spacer(),
                  if (postModel.uid == socialCubit.userModel.uid)
                    PopupMenuButton(
                        color: Colors.white,
                        icon: Icon(
                          IconBroken.More_Circle,
                          color: secondaryColor,
                        ),
                        onSelected: (value) {
                          if (value.toString() == "Delete") {
                            socialCubit.deletePost(
                                postId: socialCubit.postIdList[index]);
                          }
                        },
                        itemBuilder: (context) => socialCubit.popupMenuItems),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  postModel.postContent,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (postModel.postImage != 'not Specified')
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image(
                    width: double.infinity,
                    image: NetworkImage(postModel.postImage),
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        if (socialCubit.postsList[index].isLikedByCurrentUser ==
                            false) {
                          socialCubit.likeToPost(index: index, react: true);
                        } else if (socialCubit
                                .postsList[index].isLikedByCurrentUser ==
                            true) {
                          socialCubit.likeToPost(index: index, react: false);
                        }
                      },
                      child: Icon(
                        IconBroken.Heart,
                        color: socialCubit.postsList[index].isLikedByCurrentUser
                            ? mainColor
                            : secondaryColor,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    socialCubit.postLikesMap[socialCubit.postIdList[index]]
                        .toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: secondaryColor),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      onTap: () async {
                        socialCubit.getComments(
                            postId: socialCubit.postIdList[index]);

                        await Future.delayed(const Duration(milliseconds: 100));
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      topLeft: Radius.circular(50)),
                                  color: backGroundColor,
                                ),
                                padding: const EdgeInsets.all(20),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Text(
                                      "Comments",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontSize: 18,
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ConditionalBuilder(
                                        condition: state
                                            is! SocialGetPostCommentsLoadingState,
                                        builder: (context) {
                                          String postId =
                                              socialCubit.postIdList[index];
                                          return socialCubit
                                                  .postComments.isEmpty
                                              ? Text(
                                                  "No comments to show",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        color: secondaryColor
                                                            .withOpacity(0.5),
                                                      ),
                                                )
                                              : ListView.separated(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      CommentItem(
                                                        postModel: postModel,
                                                        commentModel: socialCubit
                                                                .postComments[
                                                            index],
                                                        userModel: socialCubit
                                                            .userModel,
                                                        commentId: socialCubit
                                                                .postCommentsId[
                                                            index],
                                                        postId: postId,
                                                      ),
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                  itemCount: socialCubit
                                                      .postComments.length);
                                        },
                                        fallback: (context) {
                                          return centerIndicator();
                                        }),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(
                        IconBroken.Chat,
                        color: secondaryColor,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${socialCubit.postCommentsNumber[index]}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: secondaryColor),
                  ),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        if (postModel.bookmark == false) {
                          socialCubit.bookmark(index: index, react: true);
                        } else {
                          socialCubit.bookmark(index: index, react: false);
                        }
                      },
                      child: Icon(
                        postModel.bookmark
                            ? Icons.bookmark
                            : IconBroken.Bookmark,
                        color: secondaryColor,
                      )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xffe4e8ec),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(socialCubit.userModel.profileImage),
                      ),
                    ),
                    Expanded(
                      child: buildAppTextFormField(context,
                          controller: commentController,
                          hintText: "Write a comment to ${postModel.name}",
                          onChange: (value) {},
                          validator: (p0) {},
                          borderRaduis: BorderRadius.circular(30)),
                    ),
                    IconButton(
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {
                            socialCubit.postComment(
                              comment: commentController.text,
                              postId: socialCubit.postIdList[index],
                              commentTime: DateFormat('MMM dd, yyyy hh:mm:ss a')
                                  .format(DateTime.now()),
                            );
                          }
                          commentController.text = '';
                        },
                        icon: Icon(
                          IconBroken.Send,
                          color: secondaryColor,
                        )),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.postModel,
    required this.commentModel,
    required this.userModel,
    required this.commentId,
    required this.postId,
  });

  final PostModel postModel;
  final UserModel userModel;
  final CommentModel commentModel;
  final String commentId;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {
        if (state is SocialDeleteCommentErrorState) {
          showToast(
              "Network error, please try again", Colors.red, Colors.black87);
        } else if (state is SocialDeleteCommentSuccessState) {
          showToast(
              "Comment Deleted Successfully", Colors.green, Colors.black87);
        }
      },
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50), topLeft: Radius.circular(50)),
            color: backGroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(userModel.profileImage),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userModel.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w700,
                                            )),
                                    Text(
                                      commentModel.comment,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (socialCubit.userModel.uid ==
                                  commentModel.senderId)
                                InkWell(
                                  onTap: () {
                                    socialCubit.deleteComment(
                                        postId: postId, commentId: commentId);
                                  },
                                  child: Icon(
                                    IconBroken.Delete,
                                    color: secondaryColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(commentModel.commentTime,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: secondaryColor.withOpacity(0.5),
                                    )),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_app/Layouts/SocialCubit/social_cubit.dart';
import 'package:social_app/Layouts/SocialCubit/social_states.dart';
import 'package:social_app/Models/user_model.dart';
import 'package:social_app/Shared/Components/components.dart';
import 'package:social_app/Shared/Components/constants.dart';

class ChatsScreen extends StatelessWidget {
  ChatsScreen({super.key});

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return ConditionalBuilder(
          condition: socialCubit.users.isNotEmpty,
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chats",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: secondaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return BuildChatItem(
                            userModel: socialCubit.users[index]
                                [socialCubit.usersUID[index]]);
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: socialCubit.users.length),
                ],
              ),
            );
          },
          fallback: (context) => centerIndicator(),
        );
      },
    );
  }
}

class BuildChatItem extends StatelessWidget {
  const BuildChatItem({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          borderRadius: BorderRadius.circular(30), // Smooth corners
          highlightColor: Colors.transparent, // Removes highlight effect
          onTap: () {
            SocialCubit.get(context).getMessages(receiverId: userModel.uid);
            pushOnly(
                context,
                ChattingScreen(
                  userModel: userModel,
                ));
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(userModel.profileImage),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 25),
                        child: Text(userModel.name,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 18,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChattingScreen extends StatelessWidget {
  ChattingScreen({super.key, required this.userModel});

  final UserModel userModel;

  var chattingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: chattingHeader(context, userModel: userModel),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConditionalBuilder(
                    condition: socialCubit.messages.isNotEmpty,
                    builder: (context) {
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return socialCubit.messages[index].senderId ==
                                    userModel.uid
                                ? MessageItem(
                                    message:
                                        socialCubit.messages[index].message,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        )),
                                    alignment: Alignment.centerLeft)
                                : MessageItem(
                                    message:
                                        socialCubit.messages[index].message,
                                    decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.2),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        )),
                                    alignment: Alignment.centerRight);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: socialCubit.messages.length);
                    },
                    fallback: (context) => Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Start a conversation with ${userModel.name} now",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: buildAppTextFormField(context,
                            controller: chattingController,
                            hintText: "Aa",
                            onChange: (p0) {},
                            onFieldSubmitted: (p0) {},
                            validator: (p0) {},
                            borderRaduis: BorderRadius.circular(30)),
                      ),
                      IconButton(
                          onPressed: () {
                            if (chattingController.text.isNotEmpty) {
                              socialCubit.sendMessage(
                                  message: chattingController.text,
                                  receiverId: userModel.uid,
                                  messageTime: DateTime.now().toString());
                              chattingController.text = '';
                            }
                          },
                          icon: Icon(
                            IconBroken.Send,
                            color: secondaryColor,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

PreferredSizeWidget? chattingHeader(BuildContext context,
        {required UserModel userModel}) =>
    AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            IconBroken.Arrow___Left,
            color: secondaryColor,
          )),
      title: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(userModel.profileImage),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: Text(userModel.name,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: secondaryColor,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                    )),
          ),
        ],
      ),
      toolbarHeight: 80,
      titleSpacing: 0,
    );

class MessageItem extends StatelessWidget {
  const MessageItem(
      {super.key,
      required this.message,
      required this.decoration,
      required this.alignment});

  final String message;
  final Decoration? decoration;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        padding: const EdgeInsets.all(15),
        decoration: decoration,
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_app/Layouts/SocialCubit/social_cubit.dart';
import 'package:social_app/Layouts/SocialCubit/social_states.dart';
import 'package:social_app/Models/post_model.dart';
import 'package:social_app/Modules/HomeScreen/home_screen.dart';
import 'package:social_app/Shared/Components/constants.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmark,
                      color: secondaryColor,
                      size: Theme.of(context).textTheme.headlineLarge!.fontSize,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Bookmarks",
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: secondaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                    )
                  ],
                ),
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
                        return socialCubit.postsList[index].bookmark == true
                            ? SocialPost(
                                postModel: socialCubit.postsList[index],
                                index: index,
                              )
                            : const SizedBox(
                                height: 0,
                              );
                      },
                      separatorBuilder: (context, index) {
                        return socialCubit.postsList[index].bookmark == true
                            ? const SizedBox(
                                height: 10,
                              )
                            : const SizedBox(
                                height: 0,
                              );
                      },
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

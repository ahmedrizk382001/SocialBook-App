import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Layouts/SocialCubit/social_cubit.dart';
import 'package:social_app/Layouts/SocialCubit/social_states.dart';
import 'package:social_app/Shared/Components/components.dart';
import 'package:social_app/Shared/Components/constants.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit socialCubit = SocialCubit.get(context);
        return Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            toolbarHeight: 30,
            backgroundColor: backGroundColor,
          ),
          body: ConditionalBuilder(
            condition: state is! SocialCubitInitialState &&
                state is! SocialCubitGetUserDataLoadingState &&
                state is! SocialGetPostsLoadingState &&
                state is! SocialGetAllUsersLoadingState,
            builder: (context) {
              return Stack(
                children: [
                  socialCubit.screens[socialCubit.bottomNavCurrentIndex],
                  const CustomizedBottomNavBar(),
                ],
              );
            },
            fallback: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: centerIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class CustomizedBottomNavBar extends StatelessWidget {
  const CustomizedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.05; // 5% of screen width

    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 0))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    List.generate(socialCubit.bottomNavIcons.length, (index) {
                  final iconPadding = socialCubit.bottomNavCurrentIndex == index
                      ? EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02, // 2% of screen width
                          vertical:
                              screenHeight * 0.015, // 1.5% of screen height
                        )
                      : EdgeInsets.zero;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04, // 4% of screen width
                      vertical: screenHeight * 0.01, // 1% of screen height
                    ),
                    child: InkWell(
                      onTap: () {
                        socialCubit.changeBottomNav(index: index);
                      },
                      child: Container(
                        padding: iconPadding,
                        decoration: socialCubit.bottomNavCurrentIndex == index
                            ? BoxDecoration(
                                color: mainColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              )
                            : const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            socialCubit.bottomNavIcons[index],
                            const SizedBox(
                              width: 5,
                            ),
                            if (socialCubit.bottomNavCurrentIndex == index)
                              Text(
                                socialCubit.bottomNavName[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

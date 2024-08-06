import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Layouts/SocialCubit/social_cubit.dart';
import 'package:social_app/Layouts/SocialCubit/social_states.dart';
import 'package:social_app/Models/user_model.dart';
import 'package:social_app/Modules/HomeScreen/home_screen.dart';
import 'package:social_app/Modules/SetupProfile/setup_profile_screen.dart';
import 'package:social_app/Shared/Components/components.dart';
import 'package:social_app/Shared/Components/constants.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {
        if (state is SocialImageUploadSuccessState) {
          SocialCubit.get(context).getImage = null;
        }
      },
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (state is SocialUpdateUserDataLoadingState ||
                  state is SocialImageUploadErrorState ||
                  state is SocialImageUploadLoadingState)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: centerIndicator(),
                ),
              Container(
                height: 215,
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(socialCubit.userModel.coverImage),
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        backgroundColor: mainColor.withOpacity(0.5),
                        child: IconButton(
                            onPressed: () {
                              socialCubit.getImageFromMobile(
                                  imageType: "coverImage");
                            },
                            icon: Icon(
                              IconBroken.Edit,
                              color: secondaryColor,
                            )),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: backGroundColor,
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(
                                  socialCubit.userModel.profileImage),
                            ),
                            CircleAvatar(
                              backgroundColor: mainColor.withOpacity(0.5),
                              child: IconButton(
                                  onPressed: () async {
                                    socialCubit.getImageFromMobile(
                                        imageType: "profileImage");
                                  },
                                  icon: Icon(
                                    IconBroken.Edit,
                                    color: secondaryColor,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              Text(
                socialCubit.userModel.name,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: secondaryColor, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      headingText(context, titleText: "Bio"),
                      IconButton(
                          onPressed: () {
                            bioController.text =
                                socialCubit.userModel.bio == 'not Specified'
                                    ? ''
                                    : socialCubit.userModel.bio;
                            socialCubit.editBio(isEnabled: true);
                          },
                          icon: Icon(
                            IconBroken.Edit,
                            color: secondaryColor,
                          )),
                    ],
                  ),
                  if (socialCubit.isBioEnabled)
                    buildAppTextFormField(
                      context,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return;
                        }
                      },
                      controller: bioController,
                      hintText: "Add a bio for you friends to see",
                      onChange: (value) {
                        bioController.text = value;
                      },
                      onFieldSubmitted: (value) {
                        if (value != '') {
                          socialCubit.editBio(isEnabled: false);
                          socialCubit.updateBio(newBio: value!);
                        }
                        return;
                      },
                      borderRaduis: BorderRadius.circular(30),
                    ),
                  if (!socialCubit.isBioEnabled)
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffe4e8ec),
                      ),
                      child: Text(
                          socialCubit.userModel.bio == 'not Specified'
                              ? "Add a bio for you friends to see"
                              : socialCubit.userModel.bio,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  )),
                    ),
                  if (socialCubit.isBioEnabled)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            socialCubit.editBio(isEnabled: false);
                            socialCubit.updateBio(newBio: bioController.text);
                          },
                          child: Text(
                            "UPDATE",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w700),
                          )),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      headingText(context, titleText: "About"),
                      IconButton(
                          onPressed: () {
                            pushOnly(context, SetupProfileScreen());
                          },
                          icon: Icon(
                            IconBroken.Edit,
                            color: secondaryColor,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffe4e8ec),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        aboutDataItem(context,
                            icon: Icon(
                              IconBroken.Calendar,
                              color: secondaryColor,
                            ),
                            label: "Birthday: ",
                            data: socialCubit.userModel.birthday ==
                                    'not Specified'
                                ? socialCubit.userModel.birthday
                                : socialCubit.userModel.birthday
                                    .substring(0, 10)),
                        aboutDataItem(context,
                            icon: Icon(
                              IconBroken.Profile,
                              color: secondaryColor,
                            ),
                            label: "Gender: ",
                            data: socialCubit.userModel.gender),
                        aboutDataItem(context,
                            icon: Icon(
                              IconBroken.Heart,
                              color: secondaryColor,
                            ),
                            label: "Relationship: ",
                            data: socialCubit.userModel.relationshipStatus),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                              return socialCubit.postsList[index].uid ==
                                      socialCubit.userModel.uid
                                  ? SocialPost(
                                      postModel: socialCubit.postsList[index],
                                      index: index,
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    );
                            },
                            separatorBuilder: (context, index) {
                              return socialCubit.postsList[index].uid ==
                                      socialCubit.userModel.uid
                                  ? const SizedBox(
                                      height: 10,
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    );
                            },
                            itemCount: socialCubit.postsList.length);
                      },
                      fallback: (context) => const SizedBox(
                            height: 0,
                          ))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

Widget headingText(BuildContext context, {required String titleText}) =>
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text(
        titleText,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 18,
              color: secondaryColor,
              fontWeight: FontWeight.w700,
            ),
      ),
    );

Widget aboutDataItem(BuildContext context,
    {required Icon icon, required String label, required String data}) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        icon,
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: label,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: secondaryColor,
                    )),
            TextSpan(
                text: data,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: secondaryColor,
                      fontWeight: FontWeight.w500,
                    )),
          ])),
        )
      ],
    ),
  );
}

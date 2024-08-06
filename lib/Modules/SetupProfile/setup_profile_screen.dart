import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:social_app/Layouts/SocialCubit/social_cubit.dart';
import 'package:social_app/Layouts/SocialCubit/social_states.dart';
import 'package:social_app/Layouts/social_layout.dart';
import 'package:social_app/Shared/Components/components.dart';
import 'package:social_app/Shared/Components/constants.dart';

class SetupProfileScreen extends StatelessWidget {
  SetupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialCubitStates>(
      listener: (context, state) {
        if (state is SocialCreateUserProfileInfoSuccessState) {
          pushRemove(context, SocialLayout());
        }
      },
      builder: (context, state) {
        var socialCubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'PROFILE INFO',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: mainColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Birthday',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: secondaryColor, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: ScrollDatePicker(
                            selectedDate:
                                socialCubit.selectedDate ?? DateTime.now(),
                            minimumDate: DateTime(1900, 1, 1),
                            maximumDate: DateTime.now(),
                            locale: Locale('en'),
                            onDateTimeChanged: (DateTime date) {
                              socialCubit.changeSelectedDate(date: date);
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintStyle: socialCubit.selectedDate == null
                            ? socialCubit.userModel.birthday == 'not Specified'
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: secondaryColor.withOpacity(0.5),
                                    )
                                : Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    )
                            : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                        hintText: socialCubit.selectedDate == null
                            ? socialCubit.userModel.birthday == 'not Specified'
                                ? 'Set your birthday'
                                : DateFormat.yMd().format(DateTime.parse(
                                    socialCubit.userModel.birthday))
                            : DateFormat.yMd()
                                .format(socialCubit.selectedDate!),
                        suffixIcon: Icon(
                          IconBroken.Calendar,
                          color: secondaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  'Gender',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: secondaryColor, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: secondaryColor.withOpacity(0.5),
                        ),
                    hintText: 'Select your gender',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: mainColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  value: socialCubit.userModel.gender == 'not Specified'
                      ? null
                      : socialCubit.userModel.gender,
                  items: socialCubit.genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? gender) {
                    socialCubit.selectedGender = gender;
                  },
                ),
                const SizedBox(height: 30.0),
                Text(
                  'Relationship Status',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: secondaryColor, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: secondaryColor.withOpacity(0.5),
                        ),
                    hintText: 'Select your relationship status',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: mainColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  value: socialCubit.userModel.relationshipStatus ==
                          'not Specified'
                      ? null
                      : socialCubit.userModel.relationshipStatus,
                  items: socialCubit.relationshipStatuses.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? relationshipStatus) {
                    socialCubit.selectedRelationshipStatus = relationshipStatus;
                  },
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (socialCubit.selectedDate != null &&
                            socialCubit.selectedGender != null &&
                            socialCubit.selectedGender != null) {
                          socialCubit.createUserProfileInfo(
                              birthday: socialCubit.selectedDate.toString(),
                              gender: socialCubit.selectedGender.toString(),
                              relationshipStatus: socialCubit
                                  .selectedRelationshipStatus
                                  .toString());
                        } else {
                          showToast("Please fill the empty fields",
                              Colors.black12, Colors.black87);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(mainColor),
                      ),
                      child: Text(
                        "Continue",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

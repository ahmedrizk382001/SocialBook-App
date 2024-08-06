import 'package:flutter/material.dart';
import 'package:social_app/Modules/LoginScreen/login_screen.dart';
import 'package:social_app/Modules/RegisterScreen/register_screen.dart';
import 'package:social_app/Shared/Components/components.dart';

import '../../Shared/Components/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("Assets/Images/Login/1.jpg"),
            alignment: Alignment.topCenter,
            opacity: 1),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 450,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome to...",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Social",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: mainColor,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    TextSpan(
                      text: "Book!",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: mainColor,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ])),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Connect with friends and the world around you. Share your moments, discover new content.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.all(10)),
                                backgroundColor:
                                    MaterialStatePropertyAll(secondaryColor),
                              ),
                              onPressed: () {
                                pushOnly(context, RegisterScreen());
                              },
                              child: Text(
                                "Sign Up",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                              ))),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.all(10)),
                                backgroundColor:
                                    MaterialStatePropertyAll(mainColor),
                              ),
                              onPressed: () {
                                pushRemove(context, LoginScreen());
                              },
                              child: Text(
                                "Sign In",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                              ))),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

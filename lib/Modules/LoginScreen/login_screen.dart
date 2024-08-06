import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Layouts/social_layout.dart';
import 'package:social_app/Modules/LoginScreen/LoginCubit/login_cubit.dart';
import 'package:social_app/Modules/LoginScreen/LoginCubit/login_states.dart';
import 'package:social_app/Modules/RegisterScreen/register_screen.dart';
import 'package:social_app/Shared/Components/components.dart';
import 'package:social_app/Shared/Components/constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formKey2 = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialLoginCubit, SocialLoginStates>(
      listener: (context, state) {
        if (state is SocialLoginSuccessState) {
          pushRemove(context, SocialLayout());
        } else if (state is SocialLoginErrorState) {
          showToast(state.error.toString(), Colors.black12, Colors.black87);
        }
      },
      builder: (context, state) {
        SocialLoginCubit loginCubit = SocialLoginCubit.get(context);
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("LOGIN",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color: mainColor,
                                  fontWeight: FontWeight.w600,
                                )),
                        Text(
                          "Welcome back! Please log in to continue.",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: secondaryColor.withOpacity(0.6),
                                  ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        builtTextFormField(
                          context,
                          validatorFunc: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter you email address";
                            }
                            return null;
                          },
                          labelText: "Enter Email Address",
                          prefixIcon: Icon(Icons.email),
                          controller: emailController,
                          keyboardtype: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        builtTextFormField(
                          context,
                          validatorFunc: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter you password";
                            }
                            return null;
                          },
                          labelText: "Enter Password",
                          onFieldSubmitted: (value) {
                            if (formKey2.currentState!.validate()) {
                              loginCubit.login(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          prefixIcon: Icon(Icons.key_sharp),
                          controller: passwordController,
                          keyboardtype: TextInputType.visiblePassword,
                          isPassword: loginCubit.isPassword,
                          suffixIcon: IconButton(
                              onPressed: () {
                                loginCubit.changeShowPassowrd();
                              },
                              icon: loginCubit.passwordIcon),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context) => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formKey2.currentState!.validate()) {
                                    loginCubit.login(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(mainColor),
                                ),
                                child: Text(
                                  "Login",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white),
                                )),
                          ),
                          fallback: (context) => centerIndicator(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: secondaryColor),
                            ),
                            TextButton(
                                onPressed: () {
                                  pushRemove(context, RegisterScreen());
                                },
                                child: Text(
                                  "REGISTER.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: mainColor,
                                          fontWeight: FontWeight.w600),
                                ))
                          ],
                        )
                      ],
                    ),
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

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Layouts/SocialCubit/social_cubit.dart';
import 'package:social_app/Layouts/social_layout.dart';
import 'package:social_app/Modules/HomeScreen/home_screen.dart';
import 'package:social_app/Modules/LoginScreen/login_screen.dart';
import 'package:social_app/Modules/RegisterScreen/RegisterCubit/register_cubit.dart';
import 'package:social_app/Modules/RegisterScreen/RegisterCubit/register_states.dart';
import 'package:social_app/Modules/SetupProfile/setup_profile_screen.dart';
import 'package:social_app/Shared/Components/components.dart';
import 'package:social_app/Shared/Components/constants.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  var formKey1 = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
      listener: (context, state) {
        if (state is SocialCreateUserSuccessState) {
          SocialCubit.get(context).bottomNavCurrentIndex = 2;
          pushRemove(context, SocialLayout());
          showToast("Registeration is done", Colors.black12, Colors.black87);
        } else if (state is SocialRegisterErrorState) {
          showToast(state.error, Colors.black12, Colors.black87);
        }
      },
      builder: (context, state) {
        SocialRegisterCubit registerCubit = SocialRegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("REGISTER",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: mainColor,
                                  fontWeight: FontWeight.w600,
                                )),
                    Text(
                      "Please fill the following fields.",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                          return "Please enter your name";
                        }
                        return null;
                      },
                      labelText: "Enter your Name",
                      prefixIcon: Icon(Icons.person),
                      controller: nameController,
                      keyboardtype: TextInputType.name,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    builtTextFormField(
                      context,
                      validatorFunc: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your Phone";
                        }
                        return null;
                      },
                      labelText: "Enter your Phone",
                      prefixIcon: Icon(Icons.phone_android),
                      controller: phoneController,
                      keyboardtype: TextInputType.phone,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    builtTextFormField(
                      context,
                      validatorFunc: (value) {
                        if (value!.isEmpty) {
                          return "Please enter you email address";
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
                          return "Please enter you password";
                        }
                        return null;
                      },
                      labelText: "Enter Password",
                      onFieldSubmitted: (value) {
                        if (formKey1.currentState!.validate()) {
                          registerCubit.userRegister(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text);
                        }
                      },
                      prefixIcon: Icon(Icons.key_sharp),
                      controller: passwordController,
                      keyboardtype: TextInputType.visiblePassword,
                      isPassword: registerCubit.isPassword,
                      suffixIcon: IconButton(
                          onPressed: () {
                            registerCubit.changeShowPassowrd();
                          },
                          icon: registerCubit.passwordIcon),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ConditionalBuilder(
                      condition: state is! SocialRegisterLoadingState,
                      builder: (context) => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (formKey1.currentState!.validate()) {
                                registerCubit.userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text);
                                //pushRemove(context, SetupProfile());
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(mainColor),
                            ),
                            child: Text(
                              "Register",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            )),
                      ),
                      fallback: (context) => centerIndicator(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor),
                        ),
                        TextButton(
                            onPressed: () {
                              pushRemove(context, LoginScreen());
                            },
                            child: Text(
                              "Sign in.",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: mainColor,
                                      fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

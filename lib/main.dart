import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Layouts/SocialCubit/social_cubit.dart';
import 'package:social_app/Layouts/social_layout.dart';
import 'package:social_app/Modules/LoginScreen/LoginCubit/login_cubit.dart';
import 'package:social_app/Modules/LoginScreen/LoginCubit/login_states.dart';
import 'package:social_app/Modules/LoginScreen/login_screen.dart';
import 'package:social_app/Modules/RegisterScreen/RegisterCubit/register_cubit.dart';
import 'package:social_app/Modules/SetupProfile/setup_profile_screen.dart';
import 'package:social_app/Modules/WelcomScreen/welcome_screen.dart';
import 'package:social_app/Shared/BlocObserver/bloc_observer.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool isLoggedIn = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          isLoggedIn = false;
        });
        print('User is currently signed out!');
      } else {
        setState(() {
          isLoggedIn = true;
        });

        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialLoginCubit(),
        ),
        BlocProvider(
          create: (context) => SocialRegisterCubit(),
        ),
        BlocProvider(
            create: (context) => SocialCubit()
              ..getUserData()
              ..getPosts()
              ..getAllUsers())
      ],
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: isLoggedIn ? const SocialLayout() : const WelcomeScreen(),
          );
        },
      ),
    );
  }
}

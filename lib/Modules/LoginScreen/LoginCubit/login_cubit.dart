import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Modules/LoginScreen/LoginCubit/login_states.dart';
import 'package:social_app/Shared/Components/constants.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(BuildContext context) =>
      BlocProvider.of<SocialLoginCubit>(context);

  bool isPassword = true;
  Widget passwordIcon = const Icon(Icons.visibility);

  void changeShowPassowrd() {
    isPassword = !isPassword;
    if (isPassword == false) {
      passwordIcon = const Icon(Icons.visibility_off);
    } else {
      passwordIcon = const Icon(Icons.visibility);
    }
    emit(SocialLoginShowPasswordState());
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(SocialLoginLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(SocialLoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      emit(SocialLoginErrorState(error: e.code));
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut().then(
      (value) {
        emit(SocialLogoutSuccessState());
      },
    ).catchError((error) {
      emit(SocialLogoutErrorState(error: error));
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Models/user_model.dart';
import 'package:social_app/Modules/RegisterScreen/RegisterCubit/register_states.dart';
import 'package:social_app/Shared/Components/constants.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(BuildContext context) =>
      BlocProvider.of<SocialRegisterCubit>(context);

  bool isPassword = true;
  Widget passwordIcon = const Icon(Icons.visibility);

  void changeShowPassowrd() {
    isPassword = !isPassword;
    if (isPassword == false) {
      passwordIcon = const Icon(Icons.visibility_off);
    } else {
      passwordIcon = const Icon(Icons.visibility);
    }
    emit(SocialRegisterShowPasswordState());
  }

  Future<void> userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(SocialRegisterLoadingState());
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(SocialRegisterSuccessState());
      createUser(
          name: name, email: email, uid: credential.user!.uid, phone: phone);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Email already in use.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email address');
      } else if (e.code == 'weak-password') {
        print('Password is too weak');
      } else {
        print('${e.message}');
      }
      emit(SocialRegisterErrorState(error: e.message!));
    }
  }

  late UserModel userModel;

  void createUser({
    required String name,
    required String email,
    required String uid,
    required String phone,
  }) {
    // Emit loading state
    emit(SocialCreateUserLoadingState());

    userModel = UserModel(
      name: name,
      email: email,
      phone: phone,
      uid: uid,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toMap())
        .then((_) {
      if (!isClosed) {
        emit(SocialCreateUserSuccessState());
      }
    }).catchError((error) {
      print(
          'Error creating user: ${error.toString()}'); // Add logging for debugging
      if (!isClosed) {
        emit(SocialCreateUserErrorState(error: error.toString()));
      }
    });
  }
}

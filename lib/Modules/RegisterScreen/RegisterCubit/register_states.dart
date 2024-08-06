abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterShowPasswordState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterSuccessState extends SocialRegisterStates {}

class SocialRegisterErrorState extends SocialRegisterStates {
  final String error;

  SocialRegisterErrorState({required this.error});
}

class SocialCreateUserLoadingState extends SocialRegisterStates {}

class SocialCreateUserSuccessState extends SocialRegisterStates {}

class SocialCreateUserErrorState extends SocialRegisterStates {
  final String error;

  SocialCreateUserErrorState({required this.error});
}

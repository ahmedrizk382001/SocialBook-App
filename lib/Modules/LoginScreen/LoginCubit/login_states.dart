abstract class SocialLoginStates {}

class SocialLoginInitialState extends SocialLoginStates {}

class SocialLoginShowPasswordState extends SocialLoginStates {}

class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginSuccessState extends SocialLoginStates {}

class SocialLoginErrorState extends SocialLoginStates {
  final String error;

  SocialLoginErrorState({required this.error});
}

class SocialLogoutLoadingState extends SocialLoginStates {}

class SocialLogoutSuccessState extends SocialLoginStates {}

class SocialLogoutErrorState extends SocialLoginStates {
  final String error;

  SocialLogoutErrorState({required this.error});
}

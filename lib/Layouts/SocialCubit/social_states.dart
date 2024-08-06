abstract class SocialCubitStates {}

class SocialCubitInitialState extends SocialCubitStates {}

class SocialCubitChangeBottomNavState extends SocialCubitStates {}

class SocialCubitShowPostButtonState extends SocialCubitStates {}

class SocialCubitGetUserDataLoadingState extends SocialCubitStates {}

class SocialCubitGetUserDataSuccessState extends SocialCubitStates {}

class SocialCubitGetUserDataErrorState extends SocialCubitStates {
  final String error;

  SocialCubitGetUserDataErrorState({required this.error});
}

class SetupProfileChangeSelectedDate extends SocialCubitStates {}

class SetupProfileChangeSelectedGender extends SocialCubitStates {}

class SetupProfileChangeSelectedRelationshipStatus extends SocialCubitStates {}

class SocialCreateUserProfileInfoLoadingState extends SocialCubitStates {}

class SocialCreateUserProfileInfoSuccessState extends SocialCubitStates {}

class SocialCreateUserProfileInfoErrorState extends SocialCubitStates {
  final String error;

  SocialCreateUserProfileInfoErrorState({required this.error});
}

class SocialImagePickSuccessState extends SocialCubitStates {}

class SocialImagePickErrorState extends SocialCubitStates {}

class SocialImageUploadLoadingState extends SocialCubitStates {}

class SocialImageUploadSuccessState extends SocialCubitStates {}

class SocialImageUploadErrorState extends SocialCubitStates {
  final String error;

  SocialImageUploadErrorState({required this.error});
}

class SocialUpdateUserDataLoadingState extends SocialCubitStates {}

class SocialUpdateUserDataSuccessState extends SocialCubitStates {}

class SocialUpdateUserDataErrorState extends SocialCubitStates {
  final String error;

  SocialUpdateUserDataErrorState({required this.error});
}

class SocialEditBio extends SocialCubitStates {}

class SocialUpdateBioLoadingState extends SocialCubitStates {}

class SocialUpdateBioSuccessState extends SocialCubitStates {}

class SocialUploadPostLoadingState extends SocialCubitStates {}

class SocialUploadPostSuccessState extends SocialCubitStates {}

class SocialUploadPostErrorState extends SocialCubitStates {
  final String error;

  SocialUploadPostErrorState({required this.error});
}

class SocialSelectPostImageState extends SocialCubitStates {}

class SocialPostImageUploadLoadingState extends SocialCubitStates {}

class SocialPostImageUploadSuccessState extends SocialCubitStates {}

class SocialPostImageUploadErrorState extends SocialCubitStates {
  final String error;

  SocialPostImageUploadErrorState({required this.error});
}

class SocialGetPostsLoadingState extends SocialCubitStates {}

class SocialGetPostsSuccessState extends SocialCubitStates {}

class SocialGetPostsErrorState extends SocialCubitStates {
  final String error;

  SocialGetPostsErrorState({required this.error});
}

class SocialUpdateLikesLoadingState extends SocialCubitStates {}

class SocialUpdateLikesSuccessState extends SocialCubitStates {}

class SocialUpdateLikesErrorState extends SocialCubitStates {
  final String error;

  SocialUpdateLikesErrorState({required this.error});
}

class SocialReactToPostLoadingState extends SocialCubitStates {}

class SocialReactToPostSuccessState extends SocialCubitStates {}

class SocialReactToPostErrorState extends SocialCubitStates {
  final String error;

  SocialReactToPostErrorState({required this.error});
}

class SocialBookmarkLoadingState extends SocialCubitStates {}

class SocialBookmarkSuccessState extends SocialCubitStates {}

class SocialBookmarkErrorState extends SocialCubitStates {
  final String error;

  SocialBookmarkErrorState({required this.error});
}

class SocialGetAllUsersLoadingState extends SocialCubitStates {}

class SocialGetAllUsersSuccessState extends SocialCubitStates {}

class SocialSendMessageLoadingState extends SocialCubitStates {}

class SocialSendMessageSuccessState extends SocialCubitStates {}

class SocialSendMessageErrorState extends SocialCubitStates {
  final String error;

  SocialSendMessageErrorState({required this.error});
}

class SocialGetMessagesLoadingState extends SocialCubitStates {}

class SocialGetMessagesSuccessState extends SocialCubitStates {}

class SocialDeletePostLoadingState extends SocialCubitStates {}

class SocialDeletePostSuccessState extends SocialCubitStates {}

class SocialDeletePostErrorState extends SocialCubitStates {
  final String error;

  SocialDeletePostErrorState({required this.error});
}

class SocialPostCommentLoadingState extends SocialCubitStates {}

class SocialPostCommentSuccessState extends SocialCubitStates {}

class SocialPostCommentErrorState extends SocialCubitStates {
  final String error;

  SocialPostCommentErrorState({required this.error});
}

class SocialGetPostCommentsLoadingState extends SocialCubitStates {}

class SocialGetPostCommentsSuccessState extends SocialCubitStates {}

class SocialDeleteCommentLoadingState extends SocialCubitStates {}

class SocialDeleteCommentSuccessState extends SocialCubitStates {}

class SocialDeleteCommentErrorState extends SocialCubitStates {
  final String error;

  SocialDeleteCommentErrorState({required this.error});
}

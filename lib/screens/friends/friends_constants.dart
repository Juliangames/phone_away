class FriendsConstants {
  // Widget dimensions
  static const double spacingBetweenAvatarAndText = 8.0;

  // UI Text
  static const String pageTitle = 'Friends';
  static const String rankHeader = 'Rank';
  static const String userHeader = 'User';
  static const String applesHeader = 'Score';
  static const String currentUserDisplayName = 'You';
  static const String noFriendsMessage = 'No friends found';
  static const String noFriendsSubMessage =
      'Invite friends to compare your focus progress!';
  static const String offlineMessage =
      'Unable to load friends - check your internet connection';
  static const String retryButtonLabel = 'Retry';
  static const String friendAddedMessage = 'You are now friends!';
  static const String inviteText =
      'Hey! Join me in the app and add me as a friend: ';
  static const String linkCreationError = 'Fehler beim Erstellen des Links';
  static const String networkErrorMessage =
      'Network error - please check your connection';
  static const String inviteButtonLabel = 'Invite';

  // Deep link paths and parameters
  static const String friendsPath = '/friends';
  static const String fromParameter = 'from';

  // Logging constants
  static const String loggerName = 'FriendsPage';
  static const String initStateLog = 'FriendsPage initState called';
  static const String deepLinkInitLog = 'Initializing deep link listener';
  static const String initialUriLog = 'Initial URI: ';
  static const String deepLinkReceivedLog = 'Received deep link: ';
  static const String deepLinkErrorLog = 'Error in _initDeepLinkListener: ';
  static const String deepLinkHandleLog = 'Handling deep link: ';
  static const String inviterIdLog = 'Inviter ID: ';
  static const String currentUserIdLog = ', Current User ID: ';
  static const String invalidInviterLog =
      'Invalid inviter ID or same as current user';
  static const String addingFriendLog = 'Adding friend: ';
  static const String toUserLog = ' to user: ';
  static const String widgetNotMountedLog =
      'Widget not mounted, skipping UI update';
  static const String deepLinkHandleErrorLog = 'Error in _handleDeepLink: ';
  static const String loadingFriendsLog = 'Loading friends for user: ';
  static const String fetchingFriendsLog = 'Fetching friends from DBService';
  static const String dbSnapshotLog = 'DB snapshot exists: ';
  static const String processingFriendsLog = 'Processing friends data';
  static const String rawFriendsDataLog = 'Raw friends data: ';
  static const String fetchedUserDataLog = 'Fetched user data for ';
  static const String loadedFriendsLog = 'Loaded ';
  static const String friendsCountLog = ' friends';
  static const String loadFriendsErrorLog = 'Error in _loadFriends: ';
  static const String avatarErrorLog = 'Error getting avatar for ';
  static const String buildingLog = 'Building FriendsPage with ';
  static const String isLoadingLog = ' friends, isLoading: ';
  static const String inviteButtonLog = 'Invite button pressed';
  static const String createdInviteLinkLog = 'Created invite link: ';
  static const String failedInviteLinkLog = 'Failed to create invite link';
  static const String inviteButtonErrorLog = 'Error in invite button: ';
}

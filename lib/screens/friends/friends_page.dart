import 'package:flutter/material.dart';
import 'package:phone_away/core/providers/user_repository_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_links/app_links.dart';
import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart'; // Add this import

import '../../core/services/firebase_user_repository.dart';
import '../../core/services/storage_service.dart'; // Add this import
import '../../core/services/network_service.dart';
import '../../theme/app_constants.dart';
import '../../core/helpers/invite_helper.dart';
import '../../widgets/empty_state/empty_state_widget.dart';
import 'friends_constants.dart';

class FriendsPage extends StatefulWidget {
  final String userId;

  const FriendsPage({super.key, required this.userId});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String, dynamic>> friends = [];
  Map<String, dynamic>? currentUserData;
  bool isLoading = true;
  bool hasError = false;
  Object? error;
  late final StorageService _storageService; // Add storage service
  late final NetworkService _networkService;
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _storageService = StorageService(); // Initialize storage service
    _networkService = NetworkService();
    developer.log(
      FriendsConstants.initStateLog,
      name: FriendsConstants.loggerName,
    );
    _loadFriends();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    developer.log(
      FriendsConstants.deepLinkInitLog,
      name: FriendsConstants.loggerName,
    );
    try {
      _appLinks = AppLinks();

      final initialUri = await _appLinks.getInitialLink();
      developer.log(
        '${FriendsConstants.initialUriLog}${initialUri?.toString() ?? AppStrings.nullValue}',
        name: FriendsConstants.loggerName,
      );
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }

      _appLinks.uriLinkStream.listen((uri) {
        developer.log(
          '${FriendsConstants.deepLinkReceivedLog}$uri',
          name: FriendsConstants.loggerName,
        );
        _handleDeepLink(uri);
      });
    } catch (e) {
      developer.log(
        '${FriendsConstants.deepLinkErrorLog}$e',
        name: FriendsConstants.loggerName,
        error: e,
      );
    }
  }

  void _handleDeepLink(Uri uri) async {
    developer.log(
      '${FriendsConstants.deepLinkHandleLog}$uri',
      name: FriendsConstants.loggerName,
    );
    try {
      if (uri.path == FriendsConstants.friendsPath &&
          uri.queryParameters.containsKey(FriendsConstants.fromParameter)) {
        final inviterId = uri.queryParameters[FriendsConstants.fromParameter];
        final currentUserId = widget.userId;

        developer.log(
          '${FriendsConstants.inviterIdLog}$inviterId${FriendsConstants.currentUserIdLog}$currentUserId',
          name: FriendsConstants.loggerName,
        );

        if (inviterId == null || inviterId == currentUserId) {
          developer.log(
            FriendsConstants.invalidInviterLog,
            name: FriendsConstants.loggerName,
          );
          return;
        }

        final dbService = UserRepositoryProvider.instance;
        developer.log(
          '${FriendsConstants.addingFriendLog}$inviterId${FriendsConstants.toUserLog}$currentUserId',
          name: FriendsConstants.loggerName,
        );
        await dbService.addFriend(currentUserId, inviterId);

        if (!mounted) {
          developer.log(
            FriendsConstants.widgetNotMountedLog,
            name: FriendsConstants.loggerName,
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(FriendsConstants.friendAddedMessage)),
        );

        _loadFriends();
      }
    } catch (e) {
      developer.log(
        '${FriendsConstants.deepLinkHandleErrorLog}$e',
        name: FriendsConstants.loggerName,
        error: e,
      );
    }
  }

  Future<void> _loadFriends() async {
    developer.log(
      '${FriendsConstants.loadingFriendsLog}${widget.userId}',
      name: FriendsConstants.loggerName,
    );
    setState(() {
      isLoading = true;
      hasError = false;
      error = null;
    });

    try {
      // Use NetworkService to wrap the database calls with timeout
      await _networkService.executeWithTimeout(() async {
        final dbService = FirebaseUserRepository();
        developer.log(
          FriendsConstants.fetchingFriendsLog,
          name: FriendsConstants.loggerName,
        );
        final snapshot = await dbService.getFriends(widget.userId);

        // Get current user data
        final userData = await dbService.getUserData(widget.userId);

        currentUserData = userData ?? {};

        developer.log(
          '${FriendsConstants.dbSnapshotLog}${snapshot.isNotEmpty}',
          name: FriendsConstants.loggerName,
        );

        List<Map<String, dynamic>> loadedFriends = [];

        // Add current user to the list
        final currentApples =
            (currentUserData?[AppStrings.applesKey] ?? AppValues.defaultApples)
                as int;
        final currentRottenApples =
            (currentUserData?[AppStrings.rottenApplesKey] ??
                    AppValues.defaultRottenApples)
                as int;
        final currentUserAvatarUrl = await _getAvatarUrl(widget.userId);

        loadedFriends.add({
          AppStrings.idKey: widget.userId,
          AppStrings.nameKey:
              currentUserData?[AppStrings.usernameKey] ??
              FriendsConstants.currentUserDisplayName,
          AppStrings.applesKey: currentApples - currentRottenApples,
          AppStrings.isCurrentUserKey: true,
          AppStrings.avatarUrlKey: currentUserAvatarUrl,
        });

        if (snapshot.isNotEmpty) {
          developer.log(
            FriendsConstants.processingFriendsLog,
            name: FriendsConstants.loggerName,
          );
          final data = snapshot as List<String>?;
          developer.log(
            '${FriendsConstants.rawFriendsDataLog}$data',
            name: FriendsConstants.loggerName,
          );

          if (data == null || data.isEmpty) {
            setState(() {
              isLoading = false;
              hasError = false;
              error = null;
            });
            return;
          }
          // Get all friend IDs
          final friendIds = data.cast<String>().toList();

          // Fetch user data for each friend in parallel
          final friendsData = await Future.wait(
            friendIds.map((friendId) async {
              final userSnapshot = await dbService.getUserData(friendId);
              final userData = userSnapshot as Map<dynamic, dynamic>? ?? {};
              developer.log(
                '${FriendsConstants.fetchedUserDataLog}$friendId: $userData',
                name: FriendsConstants.loggerName,
              );
              final apples =
                  (userData[AppStrings.applesKey] ?? AppValues.defaultApples)
                      as int;
              final rottenApples =
                  (userData[AppStrings.rottenApplesKey] ??
                          AppValues.defaultRottenApples)
                      as int;
              final avatarUrl = await _getAvatarUrl(friendId);

              return {
                AppStrings.idKey: friendId,
                AppStrings.nameKey:
                    userData[AppStrings.usernameKey] ??
                    AppValues.defaultUsername,
                AppStrings.applesKey: apples - rottenApples,
                AppStrings.isCurrentUserKey: false,
                AppStrings.avatarUrlKey: avatarUrl,
              };
            }),
          );

          loadedFriends.addAll(friendsData);
        }

        // Sort by apples (descending)
        loadedFriends.sort(
          (a, b) => (b[AppStrings.applesKey] as int).compareTo(
            a[AppStrings.applesKey] as int,
          ),
        );

        // Add ranks
        for (int i = 0; i < loadedFriends.length; i++) {
          loadedFriends[i][AppStrings.rankKey] = i + AppValues.rankOffset;
        }

        developer.log(
          '${FriendsConstants.loadedFriendsLog}${loadedFriends.length}${FriendsConstants.friendsCountLog}',
          name: FriendsConstants.loggerName,
        );

        setState(() {
          friends = loadedFriends;
          isLoading = false;
          hasError = false;
          error = null;
        });
      });
    } catch (e) {
      developer.log(
        '${FriendsConstants.loadFriendsErrorLog}$e',
        name: FriendsConstants.loggerName,
        error: e,
      );
      setState(() {
        isLoading = false;
        hasError = true;
        error = e;
      });
    }
  }

  Future<String> _getAvatarUrl(String userId) async {
    try {
      return await _storageService.getAvatarUrl(userId);
    } catch (e) {
      developer.log(
        '${FriendsConstants.avatarErrorLog}$userId: $e',
        name: FriendsConstants.loggerName,
      );
      return '';
    }
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget.noFriends();
  }

  Widget _buildErrorState() {
    return EmptyStateWidget.fromError(
      error: error ?? Exception('Unknown error'),
      onRetry: _loadFriends,
    );
  }

  @override
  Widget build(BuildContext context) {
    developer.log(
      '${FriendsConstants.buildingLog}${friends.length}${FriendsConstants.isLoadingLog}$isLoading',
      name: FriendsConstants.loggerName,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: AppDimensions.appBarHeight,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: AppDimensions.appBarTopPadding),
          child: Text(FriendsConstants.pageTitle),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding,
                      vertical: AppDimensions.verticalPadding,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            FriendsConstants.rankHeader,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            FriendsConstants.userHeader,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            FriendsConstants.applesHeader,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        hasError
                            ? _buildErrorState()
                            : friends.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                              itemCount: friends.length,
                              itemBuilder: (context, index) {
                                final friend = friends[index];
                                final isCurrentUser =
                                    friend[AppStrings.isCurrentUserKey] == true;

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.horizontalPadding,
                                    vertical:
                                        AppDimensions.containerMarginVertical,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isCurrentUser
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer
                                            : Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadius,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical:
                                          AppDimensions
                                              .containerPaddingVertical,
                                      horizontal:
                                          AppDimensions
                                              .containerPaddingHorizontal,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${friend[AppStrings.rankKey]}.',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius:
                                                    AppDimensions
                                                        .circleAvatarRadius,
                                                backgroundColor:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                backgroundImage:
                                                    friend[AppStrings
                                                                    .avatarUrlKey]
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? CachedNetworkImageProvider(
                                                          friend[AppStrings
                                                              .avatarUrlKey],
                                                        )
                                                        : null,
                                                child:
                                                    friend[AppStrings
                                                                    .avatarUrlKey]
                                                                ?.isEmpty ==
                                                            true
                                                        ? const Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size:
                                                              AppDimensions
                                                                  .iconSize,
                                                        )
                                                        : null,
                                              ),
                                              const SizedBox(
                                                width:
                                                    FriendsConstants
                                                        .spacingBetweenAvatarAndText,
                                              ),
                                              Text(friend[AppStrings.nameKey]),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            friend[AppStrings.applesKey]
                                                .toString(),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton: SizedBox(
        width: AppDimensions.fabWidth,
        height: AppDimensions.fabHeight,
        child: FloatingActionButton.extended(
          onPressed: () async {
            developer.log(
              FriendsConstants.inviteButtonLog,
              name: FriendsConstants.loggerName,
            );
            try {
              final shortLink = await InviteHelper.createDynamicInviteLink(
                widget.userId,
              );
              if (shortLink != null) {
                developer.log(
                  '${FriendsConstants.createdInviteLinkLog}$shortLink',
                  name: FriendsConstants.loggerName,
                );
                final shareText = '${FriendsConstants.inviteText}$shortLink';
                final params = ShareParams(text: shareText);
                await SharePlus.instance.share(params);
              } else {
                developer.log(
                  FriendsConstants.failedInviteLinkLog,
                  name: FriendsConstants.loggerName,
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(FriendsConstants.linkCreationError),
                  ),
                );
              }
            } catch (e) {
              developer.log(
                '${FriendsConstants.inviteButtonErrorLog}$e',
                name: FriendsConstants.loggerName,
                error: e,
              );
            }
          },
          icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
          label: Text(
            FriendsConstants.inviteButtonLabel,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.fabBorderRadius),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

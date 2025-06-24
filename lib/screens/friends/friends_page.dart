import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_links/app_links.dart';
import 'dart:developer' as developer; // Added for logging

import '../../core/services/db_service.dart';
import '../../theme/theme.dart';
import '../../core/helpers/invite_helper.dart';

class FriendsPage extends StatefulWidget {
  final String userId;

  const FriendsPage({super.key, required this.userId});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String, dynamic>> friends = [];
  bool isLoading = true;

  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    developer.log('FriendsPage initState called', name: 'FriendsPage');
    _loadFriends();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    developer.log('Initializing deep link listener', name: 'FriendsPage');
    try {
      _appLinks = AppLinks();

      final initialUri = await _appLinks.getInitialLink();
      developer.log(
        'Initial URI: ${initialUri?.toString() ?? 'null'}',
        name: 'FriendsPage',
      );
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }

      _appLinks.uriLinkStream.listen((uri) {
        developer.log('Received deep link: $uri', name: 'FriendsPage');
        _handleDeepLink(uri);
      });
    } catch (e) {
      developer.log(
        'Error in _initDeepLinkListener: $e',
        name: 'FriendsPage',
        error: e,
      );
    }
  }

  void _handleDeepLink(Uri uri) async {
    developer.log('Handling deep link: $uri', name: 'FriendsPage');
    try {
      if (uri.path == '/friends' && uri.queryParameters.containsKey('from')) {
        final inviterId = uri.queryParameters['from'];
        final currentUserId = widget.userId;

        developer.log(
          'Inviter ID: $inviterId, Current User ID: $currentUserId',
          name: 'FriendsPage',
        );

        if (inviterId == null || inviterId == currentUserId) {
          developer.log(
            'Invalid inviter ID or same as current user',
            name: 'FriendsPage',
          );
          return;
        }

        final dbService = DBService();
        developer.log(
          'Adding friend: $inviterId to user: $currentUserId',
          name: 'FriendsPage',
        );
        await dbService.addFriend(currentUserId, inviterId);

        if (!mounted) {
          developer.log(
            'Widget not mounted, skipping UI update',
            name: 'FriendsPage',
          );
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('You are now friends!')));

        _loadFriends();
      }
    } catch (e) {
      developer.log(
        'Error in _handleDeepLink: $e',
        name: 'FriendsPage',
        error: e,
      );
    }
  }

  Future<void> _loadFriends() async {
    developer.log(
      'Loading friends for user: ${widget.userId}',
      name: 'FriendsPage',
    );
    setState(() {
      isLoading = true;
    });

    try {
      final dbService = DBService();
      developer.log('Fetching friends from DBService', name: 'FriendsPage');
      final snapshot = await dbService.getFriends(widget.userId);

      developer.log(
        'DB snapshot exists: ${snapshot.exists}',
        name: 'FriendsPage',
      );
      if (snapshot.exists) {
        developer.log('Processing friends data', name: 'FriendsPage');
        final data = snapshot.value as Map<dynamic, dynamic>;
        developer.log('Raw friends data: $data', name: 'FriendsPage');

        final loadedFriends =
            data.entries.map((entry) {
              final friendId = entry.key;
              final friendData =
                  entry.value is Map
                      ? entry.value as Map<dynamic, dynamic>
                      : {};

              developer.log(
                'Processing friend: $friendId, data: $friendData',
                name: 'FriendsPage',
              );

              return {
                'id': friendId,
                'name': friendData['name'] ?? 'Unknown',
                'level': friendData['level'] ?? 0,
              };
            }).toList();

        // Sort by level (descending)
        loadedFriends.sort(
          (a, b) => (b['level'] as int).compareTo(a['level'] as int),
        );

        // Add ranks
        for (int i = 0; i < loadedFriends.length; i++) {
          loadedFriends[i]['rank'] = i + 1;
        }

        developer.log(
          'Loaded ${loadedFriends.length} friends',
          name: 'FriendsPage',
        );
        setState(() {
          friends = loadedFriends;
          isLoading = false;
        });
      } else {
        developer.log('No friends data found in snapshot', name: 'FriendsPage');
        setState(() {
          friends = [];
          isLoading = false;
        });
      }
    } catch (e) {
      developer.log('Error in _loadFriends: $e', name: 'FriendsPage', error: e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log(
      'Building FriendsPage with ${friends.length} friends, isLoading: $isLoading',
      name: 'FriendsPage',
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F3),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFFF2F7F3),
        centerTitle: true,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text("Friends"),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Rank',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'User',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Level',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        friends.isEmpty
                            ? const Center(child: Text('No friends found'))
                            : ListView.builder(
                              itemCount: friends.length,
                              itemBuilder: (context, index) {
                                final friend = friends[index];
                                final isCurrentUser =
                                    friend['id'] == widget.userId;

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isCurrentUser
                                            ? const Color(0xFFD0F2E7)
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${friend['rank']}.',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              const CircleAvatar(
                                                radius: 16,
                                                backgroundColor: Color(
                                                  0xFF60C7A6,
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(friend['name']),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            friend['level'].toString(),
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
        width: 154,
        height: 54,
        child: FloatingActionButton.extended(
          onPressed: () async {
            developer.log('Invite button pressed', name: 'FriendsPage');
            try {
              final shortLink = await InviteHelper.createDynamicInviteLink(
                widget.userId,
              );
              if (shortLink != null) {
                developer.log(
                  'Created invite link: $shortLink',
                  name: 'FriendsPage',
                );
                final shareText =
                    'Hey! Join me in the app and add me as a friend: $shortLink';
                final params = ShareParams(text: shareText);
                await SharePlus.instance.share(params);
              } else {
                developer.log(
                  'Failed to create invite link',
                  name: 'FriendsPage',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fehler beim Erstellen des Links'),
                  ),
                );
              }
            } catch (e) {
              developer.log(
                'Error in invite button: $e',
                name: 'FriendsPage',
                error: e,
              );
            }
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Invite', style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_links/app_links.dart';

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
    _loadFriends();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    _appLinks = AppLinks();

    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) async {
    if (uri.path == '/friends' && uri.queryParameters.containsKey('from')) {
      final inviterId = uri.queryParameters['from'];
      final currentUserId = widget.userId;

      if (inviterId == null || inviterId == currentUserId) return;

      final dbService = DBService();
      await dbService.addFriend(currentUserId, inviterId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You are now friends!')));

      _loadFriends();
    }
  }

  Future<void> _loadFriends() async {
    final dbService = DBService();
    final snapshot = await dbService.getFriends(widget.userId);

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      final loadedFriends =
          data.entries.map((entry) {
            final friendId = entry.key;
            final friendData =
                entry.value is Map ? entry.value as Map<dynamic, dynamic> : {};

            return {
              'id': friendId,
              'name': friendData['name'] ?? 'Unknown',
              'level': friendData['level'] ?? 0,
            };
          }).toList();

      // Sortiere nach Level (absteigend)
      loadedFriends.sort(
        (a, b) => (b['level'] as int).compareTo(a['level'] as int),
      );

      // Ränge hinzufügen
      for (int i = 0; i < loadedFriends.length; i++) {
        loadedFriends[i]['rank'] = i + 1;
      }

      setState(() {
        friends = loadedFriends;
        isLoading = false;
      });
    } else {
      setState(() {
        friends = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    child: ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        final isCurrentUser = friend['id'] == widget.userId;

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
                                        backgroundColor: Color(0xFF60C7A6),
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
            final shortLink = await InviteHelper.createDynamicInviteLink(
              widget.userId,
            );
            if (shortLink != null) {
              final shareText =
                  'Hey! Join me in the app and add me as a friend: $shortLink';
              final params = ShareParams(text: shareText);
              await SharePlus.instance.share(params);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fehler beim Erstellen des Links'),
                ),
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

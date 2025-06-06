import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  final List<Map<String, dynamic>> friends = const [
    {'rank': 1, 'name': 'Julian', 'level': 58},
    {'rank': 2, 'name': 'Henrik', 'level': 45},
    {'rank': 3, 'name': 'Urs', 'level': 42},
    {'rank': 4, 'name': 'Luuk', 'level': 41},
    {'rank': 5, 'name': 'Dominik', 'level': 39},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F3),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFFF2F7F3),
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Top margin inside AppBar
          child: Text("Friends"),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                final isCurrentUser = friend['name'] == 'Urs';

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isCurrentUser ? const Color(0xFFD0F2E7) : Colors.white,
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF004D40),
        onPressed: () {
          SharePlus.instance.share(ShareParams(text: 'todo'));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Invite', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

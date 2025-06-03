import 'package:flutter/material.dart';

import '../../widgets/apple_tree.dart';

class TreePage extends StatelessWidget {
  const TreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppleTreeWidget(
        apples: [
          ...List.generate(7, (_) => Apple()),
          ...List.generate(3, (_) => Apple(isRotten: true)),
        ],
        scale: 1.25,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TreePage extends StatelessWidget {
  const TreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/Baum5.png',
        width: 450,
        height: 450,
        fit: BoxFit.contain,
      ),
    );
  }
}

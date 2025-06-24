import 'package:flutter/material.dart';
import 'package:phone_away/screens/tree/tree_model.dart';

import '../../widgets/apple_tree.dart';

class TreePage extends StatefulWidget {
  final TreeModel model;

  const TreePage({super.key, required this.model});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  void _onModelUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_onModelUpdate);
    widget.model.loadApples();
  }

  @override
  void dispose() {
    widget.model.removeListener(_onModelUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baum von User: ${widget.model.userId}')),
      body: Center(
        child: AppleTreeWidget(
          apples: widget.model.apples,
          rottenApples: widget.model.rottenApples,
          baseSize: 450,
        ),
      ),
    );
  }
}

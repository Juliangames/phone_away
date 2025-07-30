import 'package:flutter/material.dart';
import 'package:phone_away/screens/tree/tree_model.dart';

import '../../theme/app_constants.dart';
import '../../widgets/tree/apple_tree.dart';
import '../../widgets/empty_state/empty_state_widget.dart';
import '../../core/services/network_service.dart';
import 'tree_constants.dart';

class TreePage extends StatefulWidget {
  final TreeModel model;

  const TreePage({super.key, required this.model});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  bool isLoading = false;
  bool hasError = false;
  Object? error;
  late final NetworkService _networkService;

  void _onModelUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _networkService = NetworkService();
    widget.model.addListener(_onModelUpdate);
    _loadApples();
  }

  @override
  void dispose() {
    widget.model.removeListener(_onModelUpdate);
    super.dispose();
  }

  Future<void> _loadApples() async {
    setState(() {
      isLoading = true;
      hasError = false;
      error = null;
    });

    try {
      await _networkService.executeWithTimeout(() async {
        await widget.model.loadApples();
      });

      setState(() {
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppDimensions.appBarHeight,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: AppDimensions.appBarTopPadding),
          child: Text(TreeConstants.pageTitle), // Oder TreeConstants.pageTitle
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hasError
                ? EmptyStateWidget.fromError(
                    error:
                        error ?? Exception(TreeConstants.unknownErrorMessage),
                    onRetry: _loadApples,
                  )
                : widget.model.apples == 0 && widget.model.rottenApples == 0
                    ? EmptyStateWidget.emptyTree()
                    : AppleTreeWidget(
                        apples: widget.model.apples,
                        rottenApples: widget.model.rottenApples,
                        baseSize: TreeConstants.baseTreeSize,
                      ),
      ),
    );
  }
}

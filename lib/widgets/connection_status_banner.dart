import 'package:flutter/material.dart';
import '../core/services/network_service.dart';
import 'empty_state_constants.dart';

class ConnectionStatusBanner extends StatefulWidget {
  const ConnectionStatusBanner({super.key});

  @override
  State<ConnectionStatusBanner> createState() => _ConnectionStatusBannerState();
}

class _ConnectionStatusBannerState extends State<ConnectionStatusBanner> {
  final NetworkService _networkService = NetworkService();
  bool _isConnected = true;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _networkService.startMonitoring();
    _networkService.connectionStatusStream.listen((isConnected) {
      setState(() {
        _isConnected = isConnected;
        if (!isConnected) {
          _showBanner = true;
        } else {
          // Hide banner after 2 seconds when connection is restored
          if (_showBanner) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _showBanner = false;
                });
              }
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _networkService.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showBanner ? 40 : 0,
      child: Container(
        width: double.infinity,
        color: _isConnected ? Colors.green : Colors.red.shade600,
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected
                      ? EmptyStateConstants.connectionRestored
                      : EmptyStateConstants.noConnection,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

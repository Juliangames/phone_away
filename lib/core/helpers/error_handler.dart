import 'package:flutter/material.dart';
import '../../widgets/empty_state/empty_state_widget.dart';
import '../services/network_service.dart';
import 'error_constants.dart';

class ErrorHandler {
  static void showErrorSnackBar(BuildContext context, Object error) {
    String message = _getErrorMessage(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_getErrorIcon(error), color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: ErrorConstants.okAction,
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static Widget getErrorWidget(Object error, VoidCallback onRetry) {
    return EmptyStateWidget.fromError(error: error, onRetry: onRetry);
  }

  static String _getErrorMessage(Object error) {
    if (error is NetworkTimeoutException) {
      return ErrorConstants.timeoutConnectionMessage;
    } else if (error is NetworkConnectionException) {
      return ErrorConstants.noInternetMessage;
    } else if (error is NetworkException) {
      return '${ErrorConstants.networkErrorMessage} - ${error.message}';
    } else if (error.toString().contains('timeout') ||
        error.toString().contains('TimeoutException')) {
      return ErrorConstants.timeoutRetryMessage;
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('network') ||
        error.toString().contains('connection')) {
      return ErrorConstants.connectionProblemMessage;
    } else {
      return ErrorConstants.unexpectedErrorMessage;
    }
  }

  static IconData _getErrorIcon(Object error) {
    if (error is NetworkTimeoutException) {
      return Icons.access_time_outlined;
    } else if (error is NetworkConnectionException) {
      return Icons.signal_wifi_connected_no_internet_4_outlined;
    } else if (error is NetworkException) {
      return Icons.wifi_off_outlined;
    } else if (error.toString().contains('timeout')) {
      return Icons.access_time_outlined;
    } else if (error.toString().contains('network') ||
        error.toString().contains('connection')) {
      return Icons.wifi_off_outlined;
    } else {
      return Icons.error_outline;
    }
  }

  /// Wrapper function to execute network operations with consistent error handling
  static Future<T> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    Duration? timeout,
  }) async {
    final networkService = NetworkService();
    return await networkService.executeWithTimeout(operation, timeout: timeout);
  }
}

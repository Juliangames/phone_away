import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';
import '../../core/services/network_service.dart';
import 'empty_state_constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final bool isError;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.isError = false,
  });

  factory EmptyStateWidget.noFriends({VoidCallback? onInvite}) {
    return EmptyStateWidget(
      icon: Icons.group_outlined,
      title: EmptyStateConstants.noFriendsTitle,
      subtitle: EmptyStateConstants.noFriendsSubtitle,
      actionLabel: EmptyStateConstants.inviteFriendsAction,
      onAction: onInvite,
      // iconColor wird im build method dynamisch gesetzt
    );
  }

  factory EmptyStateWidget.networkError({
    required VoidCallback onRetry,
    String? errorMessage,
  }) {
    return EmptyStateWidget(
      icon: Icons.wifi_off_outlined,
      title: EmptyStateConstants.noInternetTitle,
      subtitle: errorMessage ?? EmptyStateConstants.noInternetSubtitle,
      actionLabel: EmptyStateConstants.retryAction,
      onAction: onRetry,
      // iconColor wird für Fehler im build method gesetzt
      isError: true,
    );
  }

  factory EmptyStateWidget.timeoutError({required VoidCallback onRetry}) {
    return EmptyStateWidget(
      icon: Icons.access_time_outlined,
      title: EmptyStateConstants.timeoutTitle,
      subtitle: EmptyStateConstants.timeoutSubtitle,
      actionLabel: EmptyStateConstants.retryAction,
      onAction: onRetry,
      iconColor: null, // Will use theme-aware color in build method
      isError: true,
    );
  }

  factory EmptyStateWidget.connectionError({required VoidCallback onRetry}) {
    return EmptyStateWidget(
      icon: Icons.signal_wifi_connected_no_internet_4_outlined,
      title: EmptyStateConstants.connectionTitle,
      subtitle: EmptyStateConstants.connectionSubtitle,
      actionLabel: EmptyStateConstants.retryAction,
      onAction: onRetry,
      iconColor: null, // Will use theme-aware color in build method
      isError: true,
    );
  }

  factory EmptyStateWidget.emptyTree() {
    return const EmptyStateWidget(
      icon: Icons.park_outlined,
      title: EmptyStateConstants.emptyTreeTitle,
      subtitle: EmptyStateConstants.emptyTreeSubtitle,
      iconColor: null, // Will use theme-aware color in build method
    );
  }

  factory EmptyStateWidget.fromError({
    required Object error,
    required VoidCallback onRetry,
  }) {
    if (error is NetworkTimeoutException) {
      return EmptyStateWidget.timeoutError(onRetry: onRetry);
    } else if (error is NetworkConnectionException) {
      return EmptyStateWidget.connectionError(onRetry: onRetry);
    } else if (error is NetworkException) {
      return EmptyStateWidget.networkError(
        onRetry: onRetry,
        errorMessage: error.message,
      );
    } else if (error.toString().contains('timeout') ||
        error.toString().contains('TimeoutException')) {
      return EmptyStateWidget.timeoutError(onRetry: onRetry);
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('network') ||
        error.toString().contains('connection')) {
      return EmptyStateWidget.connectionError(onRetry: onRetry);
    } else {
      return EmptyStateWidget.loadingError(
        onRetry: onRetry,
        errorMessage:
            'Ein unerwarteter Fehler ist aufgetreten. Überprüfen Sie Ihre Internetverbindung.',
      );
    }
  }

  factory EmptyStateWidget.loadingError({
    required VoidCallback onRetry,
    String? errorMessage,
  }) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: 'Something went wrong',
      subtitle:
          errorMessage ?? 'An unexpected error occurred. Please try again.',
      actionLabel: 'Try Again',
      onAction: onRetry,
      iconColor: null, // Will use theme-aware color in build method
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.largeSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color:
                  iconColor?.withOpacity(0.7) ??
                  (isError
                      ? Theme.of(context).colorScheme.error.withOpacity(0.7)
                      : Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.5)),
            ),
            const SizedBox(height: AppDimensions.mediumSpacing),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color:
                    isError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.smallSpacing),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withOpacity(0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.largeSpacing),
              _buildActionButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (isError) {
      return OutlinedButton(
        onPressed: onAction,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.largeSpacing,
            vertical: AppDimensions.smallSpacing,
          ),
        ),
        child: Text(
          actionLabel!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.largeSpacing,
          vertical: AppDimensions.smallSpacing,
        ),
      ),
      child: Text(
        actionLabel!,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Standard "couldn't load" state with a retry button, shown when a provider's
/// load enters its error status. Keeps the failure visible (instead of a
/// misleading empty state) and offers a way to recover.
class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    super.key,
    this.message,
    required this.onRetry,
  });

  /// Backend/user-facing message when available; falls back to a generic line.
  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 48, color: cs.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              message ?? 'Something went wrong. Please try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

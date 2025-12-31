import 'package:flutter/material.dart';

class MovieOverview extends StatelessWidget {
  final String overview;

  const MovieOverview({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          overview.isNotEmpty ? overview : 'No overview available.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

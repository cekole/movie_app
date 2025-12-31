import 'package:flutter/material.dart';

class MovieTagline extends StatelessWidget {
  final String tagline;

  const MovieTagline({super.key, required this.tagline});

  @override
  Widget build(BuildContext context) {
    if (tagline.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        '"$tagline"',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontStyle: FontStyle.italic,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}

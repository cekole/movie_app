import 'package:flutter/material.dart';

import '../../../../domain/models/models.dart';

class MovieGenres extends StatelessWidget {
  final MovieDetail movie;

  const MovieGenres({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie.genres.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            movie.genres.map((genre) {
              return Chip(
                label: Text(genre.name, style: const TextStyle(fontSize: 12)),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
      ),
    );
  }
}

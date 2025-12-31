import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/models.dart';
import '../../../core/themes/app_colors.dart';

class MovieHeader extends StatelessWidget {
  final MovieDetail movie;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const MovieHeader({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background:
            movie.fullBackdropPath != null
                ? CachedNetworkImage(
                  imageUrl: movie.fullBackdropPath!,
                  fit: BoxFit.cover,
                )
                : Container(color: Colors.grey[900]),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.primary : null,
          ),
          onPressed: onFavoritePressed,
        ),
      ],
    );
  }
}

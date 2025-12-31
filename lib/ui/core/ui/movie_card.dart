import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/models.dart';
import '../themes/app_colors.dart';

/// Movie card widget for displaying movie in a grid/list
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final bool showTitle;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.showTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    movie.fullPosterPath != null
                        ? CachedNetworkImage(
                          imageUrl: movie.fullPosterPath!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => _buildPlaceholder(),
                          errorWidget:
                              (context, url, error) => _buildPlaceholder(),
                        )
                        : _buildPlaceholder(),
              ),
            ),
          ),
          if (showTitle) ...[
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Text(
          'Image',
          style: TextStyle(color: AppColors.grayDark, fontSize: 12),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../domain/models/models.dart';
import '../../../core/themes/app_colors.dart';

class MovieMetaInfo extends StatelessWidget {
  final MovieDetail movie;

  const MovieMetaInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (movie.releaseYear != null)
          _InfoChip(icon: Icons.calendar_today, label: movie.releaseYear!),
        if (movie.formattedRuntime != null)
          _InfoChip(icon: Icons.access_time, label: movie.formattedRuntime!),
        _InfoChip(
          icon: Icons.star,
          label: movie.formattedRating,
          iconColor: AppColors.rating,
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _InfoChip({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor ?? Colors.grey[400]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: Colors.grey[400])),
      ],
    );
  }
}

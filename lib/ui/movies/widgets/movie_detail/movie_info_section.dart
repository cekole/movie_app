import 'package:flutter/material.dart';

import '../../../../domain/models/models.dart';

class MovieInfoSection extends StatelessWidget {
  final MovieDetail movie;

  const MovieInfoSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Information',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'Status', value: movie.status),
        if (movie.budget != null && movie.budget! > 0)
          _InfoRow(label: 'Budget', value: '\$${_formatNumber(movie.budget!)}'),
        if (movie.revenue != null && movie.revenue! > 0)
          _InfoRow(
            label: 'Revenue',
            value: '\$${_formatNumber(movie.revenue!)}',
          ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
    return number.toString();
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(color: Colors.grey[400])),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

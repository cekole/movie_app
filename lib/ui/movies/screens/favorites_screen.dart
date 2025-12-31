import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../view_model/view_model.dart';
import '../widgets/favorites/favorites.dart';

class FavoritesScreen extends StatefulWidget {
  final FavoritesViewModel viewModel;

  const FavoritesScreen({super.key, required this.viewModel});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          Observer(
            builder: (_) {
              if (widget.viewModel.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showClearDialog(context),
              );
            },
          ),
        ],
      ),
      body: FavoritesGrid(viewModel: widget.viewModel),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Favorites'),
            content: const Text(
              'Are you sure you want to remove all favorites?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  widget.viewModel.clearAllFavorites();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Clear All'),
              ),
            ],
          ),
    );
  }
}

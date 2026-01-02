import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../movies/view_model/home_view_model.dart';
import '../view_model/splash_view_model.dart';
import '../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final VoidCallback onComplete;

  const SplashScreen({
    super.key,
    required this.homeViewModel,
    required this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SplashViewModel _viewModel = SplashViewModel();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _initializeData() async {
    await _viewModel.initializeApp();

    if (_viewModel.error == null && _viewModel.isDataLoaded) {
      // Populate HomeViewModel with fetched data
      _populateHomeViewModel();

      // Pre-cache images for offline use
      await _viewModel.preCacheImages();

      widget.onComplete();
    }
  }

  void _populateHomeViewModel() {
    widget.homeViewModel.setMoviesForCategory(
      MovieCategory.nowPlaying,
      _viewModel.nowPlayingMovies.toList(),
    );
    widget.homeViewModel.setMoviesForCategory(
      MovieCategory.popular,
      _viewModel.popularMovies.toList(),
    );
    widget.homeViewModel.setMoviesForCategory(
      MovieCategory.topRated,
      _viewModel.topRatedMovies.toList(),
    );
    widget.homeViewModel.setMoviesForCategory(
      MovieCategory.upcoming,
      _viewModel.upcomingMovies.toList(),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(scale: _scaleAnimation, child: child),
            );
          },
          child: const Center(child: SplashAppLogo()),
        ),
      ),
    );
  }
}

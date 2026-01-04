import 'package:go_router/go_router.dart';

import '../ui/movies/screens/screens.dart';
import '../ui/movies/view_model/view_model.dart';
import '../ui/onboarding/onboarding.dart';

/// App router configuration
class AppRouter {
  // ViewModels
  static final HomeViewModel homeViewModel = HomeViewModel();
  static final MovieDetailViewModel _movieDetailViewModel =
      MovieDetailViewModel();
  static final FavoritesViewModel _favoritesViewModel = FavoritesViewModel();
  static final SearchViewModel _searchViewModel = SearchViewModel();
  static final GenreSelectionViewModel _genreSelectionViewModel =
      GenreSelectionViewModel();
  static final WelcomeViewModel _welcomeViewModel = WelcomeViewModel();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder:
            (context, state) => SplashScreen(
              homeViewModel: homeViewModel,
              onComplete: () => router.go('/welcome'),
            ),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder:
            (context, state) => WelcomeScreen(
              viewModel: _welcomeViewModel,
              onContinue: () => router.go('/genre-selection'),
            ),
      ),
      GoRoute(
        path: '/genre-selection',
        name: 'genreSelection',
        builder:
            (context, state) => GenreSelectionScreen(
              viewModel: _genreSelectionViewModel,
              onContinue: () => router.go('/paywall'),
            ),
      ),
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        builder:
            (context, state) => PaywallScreen(onContinue: () => router.go('/')),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(viewModel: homeViewModel),
      ),
      GoRoute(
        path: '/movie/:id',
        name: 'movieDetail',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          return MovieDetailScreen(
            movieId: movieId,
            viewModel: _movieDetailViewModel,
          );
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder:
            (context, state) => FavoritesScreen(viewModel: _favoritesViewModel),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => SearchScreen(viewModel: _searchViewModel),
      ),
    ],
  );
}

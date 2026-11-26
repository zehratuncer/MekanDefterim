import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/places/domain/entities/place.dart';
import '../../features/places/presentation/pages/places_map_page.dart';
import '../../features/places/presentation/pages/places_list_page.dart';
import '../../features/places/presentation/pages/place_form_page.dart';
import '../../features/places/presentation/pages/place_detail_page.dart';
import '../../features/places/presentation/pages/location_picker_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return _ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/places',
          builder: (context, state) {
            final lat = double.tryParse(state.uri.queryParameters['lat'] ?? '');
            final lng = double.tryParse(state.uri.queryParameters['lng'] ?? '');
            return PlacesMapPage(initialLat: lat, initialLng: lng);
          },
        ),
        GoRoute(
          path: '/collection',
          builder: (context, state) => const PlacesListPage(),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/places/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final picked = state.extra is PickedLocation ? state.extra as PickedLocation : null;
        return PlaceFormPage(initialLocation: picked);
      },
    ),
    GoRoute(
      path: '/places/pick-location',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final picked = state.extra is PickedLocation ? state.extra as PickedLocation : null;
        return LocationPickerPage(
          initialLatitude: picked?.latitude ?? 40.9876,
          initialLongitude: picked?.longitude ?? 29.0234,
        );
      },
    ),
    GoRoute(
      path: '/places/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PlaceDetailPage(placeId: id);
      },
    ),
    GoRoute(
      path: '/places/:id/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final place = state.extra as Place?;
        return PlaceFormPage(initialPlace: place);
      },
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNavBar({required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/collection')) {
      return 1;
    }
    if (location.startsWith('/wishlist')) {
      return 2;
    }
    if (location.startsWith('/places')) {
      return 0;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/places');
        break;
      case 1:
        context.go('/collection');
        break;
      case 2:
        context.go('/wishlist');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (idx) => _onItemTapped(idx, context),
          backgroundColor: AppColors.backgroundDark,
          indicatorColor: AppColors.primary,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map_rounded, color: Colors.white),
              label: 'Harita',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded),
              selectedIcon: Icon(Icons.grid_view_sharp, color: Colors.white),
              label: 'Koleksiyon',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline_rounded),
              selectedIcon: Icon(Icons.favorite_rounded, color: Colors.white),
              label: 'İstek Listem',
            ),
          ],
        ),
      ),
    );
  }
}

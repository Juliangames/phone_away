// lib/core/router/router.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_away/screens/auth/auth_page.dart';
import 'package:phone_away/screens/friends/friends_page.dart';
import 'package:phone_away/screens/settings/settings_page.dart';
import 'package:phone_away/screens/timer/timer_page.dart';
import 'package:phone_away/screens/tree/tree_model.dart'; // Wichtig für TreePage
import 'package:phone_away/screens/tree/tree_page.dart';

// Diese Zeile ist entscheidend und muss zu deinem Dateinamen passen.
// Da deine Datei `router.dart` heißt, ist `part 'router.g.dart';` korrekt.
part 'router.g.dart';

// Definieren deiner Shell-Route
@TypedShellRoute<MainShellRoute>(
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<TimerRoute>(path: '/timer'),
    TypedGoRoute<TreeRoute>(path: '/tree'),
    TypedGoRoute<FriendsRoute>(path: '/friends'),
    TypedGoRoute<SettingsRoute>(path: '/settings'),
  ],
)
class MainShellRoute extends ShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    // Der navigator ist hier der aktuell angezeigte Child-Route-Inhalt
    return MainNavigationShell(child: navigator);
  }
}

// Separate Definition der Auth-Route
@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData with _$AuthRoute {
  const AuthRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthPage();
}

// Hier kommen die Implementierungen deiner GoRouteData Klassen.
// Diese müssen jetzt NICHT mehr mit @TypedGoRoute annotiert werden,
// da sie bereits oben als Kinder der Shell definiert wurden.
// Sie benötigen aber weiterhin das generierte Mixin.
class TimerRoute extends GoRouteData with _$TimerRoute {
  const TimerRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';
    return TimerPage(userId: userId);
  }
}

class TreeRoute extends GoRouteData with _$TreeRoute {
  const TreeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';
    return TreePage(model: TreeModel(userId: userId));
  }
}

class FriendsRoute extends GoRouteData with _$FriendsRoute {
  const FriendsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';
    return FriendsPage(userId: userId);
  }
}

class SettingsRoute extends GoRouteData with _$SettingsRoute {
  const SettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

// Dein GoRouter-Setup:
final GoRouter appRouter = GoRouter(
  routes: $appRoutes, // Dies ist korrekt mit go_router_builder
  initialLocation: '/timer',
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool loggingIn = state.uri.path == '/auth';

    if (!loggedIn && !loggingIn) {
      return const AuthRoute().location;
    }
    if (loggedIn && loggingIn) {
      return const TimerRoute().location;
    }
    return null;
  },
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Fehler')),
        body: Center(child: Text('Fehler: ${state.error}')),
      ),
);

// Der Widget-Teil der ShellRoute, der die BottomNavigationBar enthält
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key, required this.child});

  final Widget child;

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigiere zur entsprechenden Route basierend auf dem Index
    switch (index) {
      case 0:
        GoRouter.of(context).go(const TimerRoute().location);
        break;
      case 1:
        GoRouter.of(context).go(const TreeRoute().location);
        break;
      case 2:
        GoRouter.of(context).go(const FriendsRoute().location);
        break;
      case 3:
        GoRouter.of(context).go(const SettingsRoute().location);
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String location =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;

    // Verbessere die Logik zur Index-Aktualisierung
    int newIndex =
        _selectedIndex; // Standardmäßig den aktuellen Index beibehalten
    if (location.startsWith('/timer')) {
      newIndex = 0;
    } else if (location.startsWith('/tree')) {
      newIndex = 1;
    } else if (location.startsWith('/friends')) {
      newIndex = 2;
    } else if (location.startsWith('/settings')) {
      newIndex = 3;
    }

    // Nur setState aufrufen, wenn sich der Index tatsächlich geändert hat
    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
          BottomNavigationBarItem(icon: Icon(Icons.park), label: 'Tree'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Friends'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// This code was modified for demo purposes.
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm/routing/routes.dart';
import 'package:flutter_mvvm/routing/session_cubit.dart';
import 'package:flutter_mvvm/ui/feature/auth/login/login_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/feature/home/home_screen.dart';
import '../ui/feature/home/home_view_model.dart';
import '../ui/feature/map/map_screen.dart';

GoRouter router() =>
    GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: _redirect,
      // refreshListenable: session.,
      routes: [

        GoRoute(
          path: Routes.login,
          redirect: _redirect,
          builder: (context, state) {
            return LoginScreen();
          },
        ),
        GoRoute(
          path: Routes.home,
          redirect: _redirect,
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: Routes.map,
          redirect: _redirect,
          builder: (context, state) {
            return const MapWidgetForFlutterFlow();
          },
        ),
      ],
    );

// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final session = context.read<SessionCubit>();
  session.checkSession();

  final bool loggedIn = session.state != null;
  final bool loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}

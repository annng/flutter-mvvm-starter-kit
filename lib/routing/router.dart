// This code was modified for demo purposes.
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm/routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/feature/home/home_screen.dart';
import '../ui/feature/home/home_view_model.dart';

GoRouter router(// AuthRepository authRepository,
        ) =>
    GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: _redirect,
      // refreshListenable: authRepository,
      routes: [
        // GoRoute(
        //   path: Routes.login,
        //   builder: (context, state) {
        //     return LoginScreen(
        //       viewModel: LoginViewModel(
        //         authRepository: context.read(),
        //       ),
        //     );
        //   },
        // ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return BlocProvider<HomeViewModel>(
              create: (_) => HomeViewModel(userRepository: context.read()),
              child: const HomeScreen(),
            );
          },
          routes: [
            // ...
          ],
        ),
      ],
    );

// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  // final bool loggedIn = await context.read<AuthRepository>().isAuthenticated; //todo create auth repository to handle login or not
  final bool loggedIn = true;
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

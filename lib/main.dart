import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm/config/dependencies.dart';
import 'package:flutter_mvvm/routing/router.dart';
import 'package:flutter_mvvm/routing/session_cubit.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: providersRemote,
      child: MultiBlocProvider(providers: blocProvider, child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm/config/core/base_cubit.dart';
import 'package:flutter_mvvm/routing/router.dart';
import 'package:flutter_mvvm/routing/session_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login"),
            ElevatedButton(onPressed: () {
              session.createSession("asd");
            }, child: Text("Login"))
          ],
        ),
      ),
    );
  }
}

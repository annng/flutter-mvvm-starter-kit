import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm/config/core/base_state.dart';
import 'package:flutter_mvvm/routing/session_cubit.dart';
import 'package:flutter_mvvm/ui/feature/auth/login/login_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/assets.dart';
import '../../../../routing/routes.dart';
import '../../../../utils/res/colors.dart';
import 'login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();
    final session = context.read<SessionCubit>();
    final primaryColor = Theme.of(context).colorScheme.primary;
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        //     onPressed: () {
        //       Provider.of<ThemeProvider>(context, listen: false)
        //           .setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(child:
          BlocBuilder<LoginViewModel, BaseState>(builder: (context, state) {
        final successState = state as BaseSuccess<LoginState>;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                Text(
                  'Selamat Datang!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Masukkan akunmu sekarang untuk pengalaman yang lebih lengkap.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32),
                Center(
                  child: Container(
                      width: 200,
                      height: 200,
                      child: SvgPicture.asset(Assets.imgStateSinging)),
                ),
                SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: state.data.obsecurePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outlined),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(successState.data.obsecurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        viewModel
                            .setObsecure(!successState.data.obsecurePassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await session.createSession("asd");
                      context.go(Routes.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Masuk',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Divider(
                        height: 2,
                        thickness: 1,
                        color: Colors.grey.withAlpha(100),
                      ),
                    ),
                    SizedBox(width: 8),
                    Center(
                        child: Text(
                      'Atau masuk dengan',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: MyColors.bodyText),
                    )),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Divider(
                        height: 2,
                        thickness: 1,
                        color: Colors.grey.withAlpha(100),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: SvgPicture.asset(Assets.iconGoogle),
                    label: Text(
                      'Masuk dengan google',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: MyColors.bodyText),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push(Routes.register);
                            },
                          text: 'Daftar',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      })),
    );
  }
}

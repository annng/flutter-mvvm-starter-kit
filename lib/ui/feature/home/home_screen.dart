import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm/ui/feature/event/event_screen.dart';
import 'package:flutter_mvvm/ui/feature/home/component/bottom_navigation_home.dart';
import 'package:flutter_mvvm/ui/feature/home/home_state.dart';

import '../../../config/core/base_state.dart';
import '../../../routing/session_cubit.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      EventScreen(),
      EventScreen(),
      EventScreen(),
    ];

    final viewModel = context.read<HomeViewModel>();

    return BlocBuilder<HomeViewModel, BaseState>(builder: (context, state) {
      final successState = state as BaseSuccess<HomeState>;
      return Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          PageView(
            controller: viewModel.pageController,
            children: _screens,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              //viewModel.setCurrentNavigationItem(index);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: BottomNavigationHome(
                currentIndex: successState.data.currentNavigationIndex,
                onTap: (index) {
                  viewModel.setCurrentNavigationItem(index);
                }),
          ),
        ]),
      );
    });
  }
}

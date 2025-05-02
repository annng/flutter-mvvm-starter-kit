import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm/ui/feature/home/home_state.dart';

import '../../../config/core/base_state.dart';
import '../../../routing/session_cubit.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    final sessionCubit = context.read<SessionCubit>();

    return Scaffold(
      body: SafeArea(child:
      BlocBuilder<HomeViewModel, BaseState>(builder: (context, state) {
        if (state is BaseLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BaseError) {
          final errorState = state;
          return Container(
            child: Text(errorState.message),
          ); // modify with your error state
        }
        if (state is BaseSuccess) {
          final successState = state as BaseSuccess<HomeState>;
          return Column(
            children: [
              if(successState.data.user != null)...[
                Text(successState.data.user?.firstName ?? "")
              ],
              Expanded(
                flex: 1,
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemCount: successState.data.users?.length,
                      itemBuilder: (_, index) =>
                          Container(
                            child: InkWell(
                              onTap: () async {
                                final data = successState.data.users?[index];
                                await viewModel.fetchUserDetails(data?.id ?? 0);
                                // await sessionCubit.clearSession();
                                // context.go(Routes.login);
                                },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: successState.data.users != null
                                    ? Text(
                                    successState.data.users![index].firstName)
                                    : Container(),
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Container();
      })),
    );
  }
}

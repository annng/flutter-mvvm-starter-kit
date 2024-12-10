import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListenableBuilder(
              listenable: viewModel.usersNotifier,
              builder: (context, _) {
                final notifier = viewModel.usersNotifier;

                if (notifier.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (notifier.errorMessage != null) {
                  return Container(
                    child: Text(notifier.errorMessage ?? ""),
                  ); // modify with your error state
                }

                final detail = viewModel.userDetailsNotifier;
                return Column(
                  children: [
                    ListenableBuilder(
                        listenable: viewModel.userDetailsNotifier,
                        builder: (BuildContext context, Widget? child) {
                          return Text("selected : ${detail.data?.firstName}");
                        }),
                    Expanded(
                      flex: 1,
                      child: CustomScrollView(
                        slivers: [
                          SliverList.builder(
                            itemCount: notifier.data?.length,
                            itemBuilder: (_, index) => Container(
                              child: InkWell(
                                onTap: () {
                                  viewModel.getUser(notifier.data![index].id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: notifier.data != null
                                      ? Text(notifier.data![index].firstName)
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
              })),
    );
  }
}

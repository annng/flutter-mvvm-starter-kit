import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_cubit.dart';
import 'base_state.dart';

class BaseView<T> extends StatelessWidget {
  final BaseCubit<T> cubit;
  final Widget Function(T data) onSuccess;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const BaseView({
    required this.cubit,
    required this.onSuccess,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseCubit<T>, BaseState<T>>(
      bloc: cubit,
      builder: (context, state) {
        if (state is BaseLoading<T>) {
          return loadingWidget ?? const Center(child: CircularProgressIndicator());
        } else if (state is BaseSuccess<T>) {
          return onSuccess(state.data);
        } else if (state is BaseError<T>) {
          return errorWidget ?? Center(child: Text((state).message));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
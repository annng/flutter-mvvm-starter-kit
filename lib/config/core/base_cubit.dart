import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_state.dart';

class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(BaseInitial<T>());

  void emitLoading() => emit(BaseLoading<T>());

  void emitSuccess(T data) => emit(BaseSuccess<T>(data));

  void emitError(String message) => emit(BaseError<T>(message));
}
abstract class BaseState<T> {}

class BaseInitial<T> extends BaseState<T> {}

class BaseLoading<T> extends BaseState<T> {}

class BaseSuccess<T> extends BaseState<T> {
  final T data;
  BaseSuccess(this.data);
}

class BaseError<T> extends BaseState<T> {
  final String message;
  BaseError(this.message);
}
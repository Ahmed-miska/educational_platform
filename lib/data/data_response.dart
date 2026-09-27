class DataResponse<T> {
  final T? data;
  final Object? error;

  const DataResponse.withSuccess(T this.data) : error = null;

  const DataResponse.withError(Object this.error) : data = null;

  bool get isSuccess => error == null;
}

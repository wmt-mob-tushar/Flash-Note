class ApiResponse<T> {
  Status? status;

  T? data;

  String? message;

  double? progress;

  dynamic request;

  ApiResponse.loading({this.progress}) : status = Status.LOADING;

  ApiResponse.completed(this.data, {this.request}) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  ApiResponse.message(this.message) : status = Status.MESSAGE;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR, PAGINATE,MESSAGE }
